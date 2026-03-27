function kn
    set -l namespace (kubectl get ns -o name | fzf -d/ --with-nth=2 | cut -d/ -f2)
    if test -n "$namespace"
        kubectl config set-context --current --namespace "$namespace"
    end
end
