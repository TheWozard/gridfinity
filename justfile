output_dir := "output"

default:
    @just --list

_build name models="default":
    mkdir -p {{output_dir}}/{{name}}
    for model in {{models}}; do \
        openscad -o {{output_dir}}/{{name}}/${model}.stl -D "model=\"${model}\"" {{name}}.scad; \
    done

gridfinity_extruded: (_build "gridfinity_extruded")
home_assistant: (_build "home_assistant")
mirror: (_build "mirror" "frame intersection corners")
server: (_build "server" "stopper ha_green netgear_gs308 half_u_cover")
zooz: (_build "zooz")
mini_rack: (_build "mini_rack" "plate stopper focusrite schitt schitt_switch pcpannel")

clean:
    find {{output_dir}} -name "*.stl" -delete
