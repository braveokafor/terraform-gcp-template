#!/usr/bin/env bash
while getopts a:n:u:d: flag
do
    case "${flag}" in
        a) author=${OPTARG};;
        n) name=${OPTARG};;
        u) urlname=${OPTARG};;
        d) description=${OPTARG};;
    esac
done

echo "Author: $author";
echo "Project Name: $name";
echo "Project URL name: $urlname";
echo "Description: $description";

echo "Renaming project..."

original_author="braveokafor"
original_name="terraform-gcp-template"
original_urlname="terraform-gcp-template"
original_description="Terraform template to bootstrap a baseline project in Google Cloud."

for filename in $(git ls-files) 
do
    sed -i "s/$original_author/$author/g" $filename
    sed -i "s/$original_name/$name/g" $filename
    sed -i "s/$original_urlname/$urlname/g" $filename
    sed -i "s/$original_description/$description/g" $filename
    echo "Renamed $filename"
done


rm -rf .terraform-docs.yml .pre-commit-config.yaml 
rm -rf .github/rename_project.sh .github/workflows/release.yaml .github/workflows/bootstrap-repo.yaml

mv .github/workflows/terraform-plan.yaml.disabled .github/workflows/terraform-plan.yaml
mv .github/workflows/terraform-apply.yaml.disabled .github/workflows/terraform-apply.yaml

sed -i '/<!-- BEGIN_TEMPLATE_DOCUMENTATION -->/,/<!-- END_TEMPLATE_DOCUMENTATION -->/d' README.md
sed -i '/<!-- BEGIN_TF_DOCS -->/,/<!-- END_TF_DOCS -->/d' README.md

echo "This repository was created from [braveokafor/terraform-gcp-template](https://github.com/braveokafor/terraform-gcp-template)  " >> README.md
