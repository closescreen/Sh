module Sh

compressors() = Dict{Symbol,AbstractString}(:f=>"cat",:gz=>"gzip")

export viatmp
"viatmp(\"aa.txt\") -> Cmd"
viatmp{S<:AbstractString}(file::S) = viatmp(:f=>file)


export viatmpgz
"viatmpgz(\"aa.gz\") -> Cmd"
viatmpgz{S<:AbstractString}(file::S) = viatmp(:gz=>file)

"""viatmp(:gz=>\"aa.gz\") -> `bash -c \"gzip > aa.gz.TMP && mv aa.gz.TMP aa.gz\"`"""
viatmp{S<:AbstractString}(p::Pair{Symbol,S}) = viatmp(p, compressors())

"""viatmp(:myzip=>aa.zip, Dict(:myzip=>\"zip\"))"""
function viatmp{S1<:AbstractString, S2<:AbstractString}( 
		p::Pair{Symbol,S1}, dict::Dict{Symbol,S2} )
 ftype = p[1]
 fname = p[2]
 compr = dict[ftype]
 c("""$compr > \"$fname.TMP\" && mv \"$fname.TMP\" \"$fname\"""")
end


export c
"c(\"echo aa | grep aa\") -> `bash -c \"echo aa | grep aa\"`"
c{S<:AbstractString}(command::S) = `bash -c """$command"""`


export @c_str
""" c\" echo aa | grep aa \" -> `bash -c \"echo aa | grep aa\"` """
macro c_str(command) c(command) end

export @rc_str
""" rc\" command \" # run command"""
macro rc_str(command) run(c(command)) end



end # module