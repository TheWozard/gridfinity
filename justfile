output_dir := "output"

default:
    @just --list

server:
    mkdir -p {{output_dir}}/server
    for model in stopper ha_green netgear_gs308 half_u_cover; do \
        openscad -o {{output_dir}}/server/${model}.stl -D "model=\"${model}\"" server.scad; \
    done

clean:
    find {{output_dir}} -name "*.stl" -delete
