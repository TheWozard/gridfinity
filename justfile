output_dir := "output"

default:
    @just --list

_build name models="default":
    mkdir -p {{output_dir}}/{{name}}
    for model in {{models}}; do \
        openscad -o {{output_dir}}/{{name}}/${model}.stl -D "model=\"${model}\"" {{name}}.scad; \
    done

home_assistant: (_build "home_assistant")
server: (_build "server" "stopper ha_green netgear_gs308 half_u_cover")
zooz: (_build "zooz")

clean:
    find {{output_dir}} -name "*.stl" -delete
