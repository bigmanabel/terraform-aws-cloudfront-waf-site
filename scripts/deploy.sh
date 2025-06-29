#!/bin/bash

# Terraform AWS CloudFront WAF Site Deployment Script
# Usage: ./deploy.sh <environment> [action]
# Example: ./deploy.sh dev plan
#          ./deploy.sh prod apply

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <environment> [action]"
    echo ""
    echo "Environments:"
    echo "  dev     - Development environment"
    echo "  prod    - Production environment"
    echo ""
    echo "Actions:"
    echo "  init    - Initialize Terraform"
    echo "  plan    - Show deployment plan"
    echo "  apply   - Apply changes"
    echo "  destroy - Destroy infrastructure"
    echo "  validate - Validate configuration"
    echo "  output  - Show outputs"
    echo ""
    echo "Examples:"
    echo "  $0 dev plan"
    echo "  $0 prod apply"
    echo "  $0 dev destroy"
}

# Check if environment is provided
if [ $# -eq 0 ]; then
    print_error "No environment specified"
    show_usage
    exit 1
fi

ENVIRONMENT=$1
ACTION=${2:-plan}

# Validate environment
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "prod" ]]; then
    print_error "Invalid environment: $ENVIRONMENT"
    print_info "Valid environments: dev, prod"
    exit 1
fi

# Set working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

# Check if environment directory exists
if [ ! -d "$ENV_DIR" ]; then
    print_error "Environment directory not found: $ENV_DIR"
    exit 1
fi

print_info "Deploying to $ENVIRONMENT environment"
print_info "Working directory: $ENV_DIR"

# Change to environment directory
cd "$ENV_DIR"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    print_warning "terraform.tfvars not found"
    if [ -f "terraform.tfvars.example" ]; then
        print_info "Creating terraform.tfvars from example file"
        cp terraform.tfvars.example terraform.tfvars
        print_warning "Please edit terraform.tfvars with your actual values before proceeding"
        print_info "Required variables: project_name, aws_region"
        exit 1
    else
        print_error "No terraform.tfvars.example found"
        exit 1
    fi
fi

# Check if .env file exists in project root
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    print_warning ".env file not found in project root"
    if [ -f "$PROJECT_ROOT/.env.example" ]; then
        print_info "Please copy .env.example to .env and configure your AWS credentials"
        print_info "Run: cp $PROJECT_ROOT/.env.example $PROJECT_ROOT/.env"
        exit 1
    fi
fi

# Source environment variables if .env exists
if [ -f "$PROJECT_ROOT/.env" ]; then
    print_info "Loading environment variables from .env"
    source "$PROJECT_ROOT/.env"
fi

# Validate AWS credentials
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    print_warning "AWS credentials not found in environment variables"
    print_info "Make sure AWS CLI is configured or .env file contains valid credentials"
fi

# Execute the specified action
case $ACTION in
    init)
        print_info "Initializing Terraform..."
        terraform init
        print_success "Terraform initialized successfully"
        ;;
    
    validate)
        print_info "Validating Terraform configuration..."
        terraform validate
        print_success "Configuration is valid"
        ;;
    
    plan)
        print_info "Creating Terraform plan..."
        terraform init -upgrade
        terraform validate
        terraform plan -var-file="terraform.tfvars" -detailed-exitcode
        ;;
    
    apply)
        print_info "Applying Terraform configuration..."
        terraform init -upgrade
        terraform validate
        terraform plan -var-file="terraform.tfvars" -out=tfplan
        
        if [ "$ENVIRONMENT" == "prod" ]; then
            print_warning "You are about to deploy to PRODUCTION environment"
            read -p "Are you sure you want to continue? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Deployment cancelled"
                rm -f tfplan
                exit 0
            fi
        fi
        
        terraform apply tfplan
        rm -f tfplan
        print_success "Deployment completed successfully"
        print_info "Getting outputs..."
        terraform output
        ;;
    
    destroy)
        print_warning "You are about to DESTROY the $ENVIRONMENT environment"
        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Destruction cancelled"
            exit 0
        fi
        
        print_info "Destroying infrastructure..."
        terraform destroy -var-file="terraform.tfvars"
        print_success "Infrastructure destroyed"
        ;;
    
    output)
        print_info "Showing Terraform outputs..."
        terraform output
        ;;
    
    *)
        print_error "Invalid action: $ACTION"
        show_usage
        exit 1
        ;;
esac

print_success "Operation completed successfully"
