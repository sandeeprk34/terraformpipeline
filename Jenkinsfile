node {
   stage 'checkout'
        checkout scm

   stage 'Testing Stage'
        parallel (
            phase1: { sh "echo p1; sleep 20s; echo phase1" },
            phase2: { sh "echo p2; sleep 40s; echo phase2" }
        )
		 
   stage name: 'Terraform Planning Stage', concurrency: 1
        sh "terraform plan --out plan"

   stage name: 'Terraform Deploying Stage', concurrency: 1
        sh "terraform apply --input"

        sh "terraform apply"
}
