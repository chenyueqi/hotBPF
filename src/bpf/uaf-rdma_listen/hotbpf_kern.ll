; ModuleID = 'hotbpf_kern.c'
source_filename = "hotbpf_kern.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.kmem_cache_alloc_context = type { i64, i64, i8*, i64, i64, i32 }
%struct.kfree_context = type { i64, i64, i8* }

@bpf_duration_map = dso_local global %struct.bpf_map_def { i32 1, i32 8, i32 8, i32 4096, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@inuse_map = dso_local global %struct.bpf_map_def { i32 1, i32 8, i32 8, i32 4096, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !14
@infree_map = dso_local global %struct.bpf_map_def { i32 1, i32 8, i32 8, i32 4096, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !26
@__const.probe_kmem_cache_alloc_trace.____fmt = private unnamed_addr constant [47 x i8] c"[hotbpf] fail to do vmalloc, back to original\0A\00", align 16
@__const.probe_kmem_cache_alloc_trace.____fmt.1 = private unnamed_addr constant [38 x i8] c"[hotbpf] do vmalloc and return 0x%lx\0A\00", align 16
@__const.probe_kfree.____fmt = private unnamed_addr constant [35 x i8] c"[hotbpf] never do vfree for 0x%lx\0A\00", align 16
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !28
@_version = dso_local global i32 327680, section "version", align 4, !dbg !34
@llvm.used = appending global [7 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32* @_version to i8*), i8* bitcast (%struct.bpf_map_def* @bpf_duration_map to i8*), i8* bitcast (%struct.bpf_map_def* @infree_map to i8*), i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* bitcast (i32 (%struct.kfree_context*)* @probe_kfree to i8*), i8* bitcast (i32 (%struct.kmem_cache_alloc_context*)* @probe_kmem_cache_alloc_trace to i8*)], section "llvm.metadata"

; Function Attrs: norecurse nounwind readnone uwtable
define dso_local zeroext i1 @is_target_alloc_site(i64 %0) local_unnamed_addr #0 !dbg !79 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !86, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i32 undef, metadata !91, metadata !DIExpression()), !dbg !92
  %2 = icmp eq i64 %0, -2121652416, !dbg !93
  ret i1 %2, !dbg !98
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @probe_kmem_cache_alloc_trace(%struct.kmem_cache_alloc_context* %0) #3 section "tracepoint/kmem/kmem_cache_alloc" !dbg !99 {
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca [47 x i8], align 16
  %5 = alloca [38 x i8], align 16
  call void @llvm.dbg.value(metadata %struct.kmem_cache_alloc_context* %0, metadata !114, metadata !DIExpression()), !dbg !134
  %6 = bitcast i64* %2 to i8*, !dbg !135
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %6) #4, !dbg !135
  call void @llvm.dbg.value(metadata i64 0, metadata !115, metadata !DIExpression()), !dbg !134
  store i64 0, i64* %2, align 8, !dbg !136, !tbaa !137
  %7 = bitcast i64* %3 to i8*, !dbg !141
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %7) #4, !dbg !141
  call void @llvm.dbg.value(metadata i64 0, metadata !116, metadata !DIExpression()), !dbg !134
  store i64 0, i64* %3, align 8, !dbg !142, !tbaa !137
  %8 = getelementptr inbounds %struct.kmem_cache_alloc_context, %struct.kmem_cache_alloc_context* %0, i64 0, i32 1, !dbg !143
  %9 = load i64, i64* %8, align 8, !dbg !143, !tbaa !144
  call void @llvm.dbg.value(metadata i64 %9, metadata !117, metadata !DIExpression()), !dbg !134
  call void @llvm.dbg.value(metadata i64 %9, metadata !86, metadata !DIExpression()), !dbg !149
  call void @llvm.dbg.value(metadata i32 undef, metadata !91, metadata !DIExpression()), !dbg !149
  %10 = icmp eq i64 %9, -2121652416, !dbg !151
  br i1 %10, label %11, label %26, !dbg !152

11:                                               ; preds = %1
  %12 = getelementptr inbounds %struct.kmem_cache_alloc_context, %struct.kmem_cache_alloc_context* %0, i64 0, i32 3, !dbg !153
  %13 = load i64, i64* %12, align 8, !dbg !153, !tbaa !154
  call void @llvm.dbg.value(metadata i64 %13, metadata !116, metadata !DIExpression()), !dbg !134
  store i64 %13, i64* %3, align 8, !dbg !155, !tbaa !137
  %14 = tail call i64 inttoptr (i64 93 to i64 (i64)*)(i64 %13) #4, !dbg !156
  call void @llvm.dbg.value(metadata i64 %14, metadata !115, metadata !DIExpression()), !dbg !134
  store i64 %14, i64* %2, align 8, !dbg !157, !tbaa !137
  %15 = icmp eq i64 %14, 0, !dbg !158
  br i1 %15, label %16, label %19, !dbg !159

16:                                               ; preds = %11
  %17 = getelementptr inbounds [47 x i8], [47 x i8]* %4, i64 0, i64 0, !dbg !160
  call void @llvm.lifetime.start.p0i8(i64 47, i8* nonnull %17) #4, !dbg !160
  call void @llvm.dbg.declare(metadata [47 x i8]* %4, metadata !119, metadata !DIExpression()), !dbg !160
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(47) %17, i8* nonnull align 16 dereferenceable(47) getelementptr inbounds ([47 x i8], [47 x i8]* @__const.probe_kmem_cache_alloc_trace.____fmt, i64 0, i64 0), i64 47, i1 false), !dbg !160
  %18 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %17, i32 47) #4, !dbg !160
  call void @llvm.lifetime.end.p0i8(i64 47, i8* nonnull %17) #4, !dbg !161
  br label %26, !dbg !162

19:                                               ; preds = %11
  %20 = getelementptr inbounds [38 x i8], [38 x i8]* %5, i64 0, i64 0, !dbg !163
  call void @llvm.lifetime.start.p0i8(i64 38, i8* nonnull %20) #4, !dbg !163
  call void @llvm.dbg.declare(metadata [38 x i8]* %5, metadata !128, metadata !DIExpression()), !dbg !163
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(38) %20, i8* nonnull align 16 dereferenceable(38) getelementptr inbounds ([38 x i8], [38 x i8]* @__const.probe_kmem_cache_alloc_trace.____fmt.1, i64 0, i64 0), i64 38, i1 false), !dbg !163
  call void @llvm.dbg.value(metadata i64 %14, metadata !115, metadata !DIExpression()), !dbg !134
  %21 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %20, i32 38, i64 %14) #4, !dbg !163
  call void @llvm.lifetime.end.p0i8(i64 38, i8* nonnull %20) #4, !dbg !164
  call void @llvm.dbg.value(metadata i64* %2, metadata !115, metadata !DIExpression(DW_OP_deref)), !dbg !134
  call void @llvm.dbg.value(metadata i64* %3, metadata !116, metadata !DIExpression(DW_OP_deref)), !dbg !134
  %22 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* nonnull %6, i8* nonnull %7, i64 0) #4, !dbg !165
  %23 = bitcast %struct.kmem_cache_alloc_context* %0 to i8*, !dbg !166
  %24 = load i64, i64* %2, align 8, !dbg !167, !tbaa !137
  call void @llvm.dbg.value(metadata i64 %24, metadata !115, metadata !DIExpression()), !dbg !134
  %25 = call i32 inttoptr (i64 95 to i32 (i8*, i64)*)(i8* %23, i64 %24) #4, !dbg !168
  br label %26

26:                                               ; preds = %16, %19, %1
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %7) #4, !dbg !169
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %6) #4, !dbg !169
  ret i32 0, !dbg !170
}

; Function Attrs: nounwind uwtable
define dso_local i32 @probe_kfree(%struct.kfree_context* %0) #3 section "tracepoint/kmem/kfree" !dbg !171 {
  %2 = alloca i64, align 8
  %3 = alloca [35 x i8], align 16
  call void @llvm.dbg.value(metadata %struct.kfree_context* %0, metadata !181, metadata !DIExpression()), !dbg !192
  %4 = bitcast i64* %2 to i8*, !dbg !193
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %4) #4, !dbg !193
  %5 = getelementptr inbounds %struct.kfree_context, %struct.kfree_context* %0, i64 0, i32 2, !dbg !194
  %6 = bitcast i8** %5 to i64*, !dbg !194
  %7 = load i64, i64* %6, align 8, !dbg !194, !tbaa !195
  call void @llvm.dbg.value(metadata i64 %7, metadata !182, metadata !DIExpression()), !dbg !192
  store i64 %7, i64* %2, align 8, !dbg !197, !tbaa !137
  call void @llvm.dbg.value(metadata i64* %2, metadata !182, metadata !DIExpression(DW_OP_deref)), !dbg !192
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* nonnull %4) #4, !dbg !198
  call void @llvm.dbg.value(metadata i8* %8, metadata !183, metadata !DIExpression()), !dbg !192
  %9 = icmp eq i8* %8, null, !dbg !199
  br i1 %9, label %17, label %10, !dbg !200

10:                                               ; preds = %1
  %11 = getelementptr inbounds [35 x i8], [35 x i8]* %3, i64 0, i64 0, !dbg !201
  call void @llvm.lifetime.start.p0i8(i64 35, i8* nonnull %11) #4, !dbg !201
  call void @llvm.dbg.declare(metadata [35 x i8]* %3, metadata !185, metadata !DIExpression()), !dbg !201
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(35) %11, i8* nonnull align 16 dereferenceable(35) getelementptr inbounds ([35 x i8], [35 x i8]* @__const.probe_kfree.____fmt, i64 0, i64 0), i64 35, i1 false), !dbg !201
  %12 = load i64, i64* %2, align 8, !dbg !201, !tbaa !137
  call void @llvm.dbg.value(metadata i64 %12, metadata !182, metadata !DIExpression()), !dbg !192
  %13 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %11, i32 35, i64 %12) #4, !dbg !201
  call void @llvm.lifetime.end.p0i8(i64 35, i8* nonnull %11) #4, !dbg !202
  call void @llvm.dbg.value(metadata i64* %2, metadata !182, metadata !DIExpression(DW_OP_deref)), !dbg !192
  %14 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* nonnull %4) #4, !dbg !203
  %15 = bitcast %struct.kfree_context* %0 to i8*, !dbg !204
  %16 = call i32 inttoptr (i64 95 to i32 (i8*, i64)*)(i8* %15, i64 0) #4, !dbg !205
  br label %17, !dbg !206

17:                                               ; preds = %1, %10
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %4) #4, !dbg !207
  ret i32 0, !dbg !207
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { norecurse nounwind readnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!75, !76, !77}
!llvm.ident = !{!78}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "bpf_duration_map", scope: !2, file: !3, line: 21, type: !16, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !11, globals: !13, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "hotbpf_kern.c", directory: "/home/yueqichen/hotbpf/src/bpf/uaf-rdma_listen")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 10, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/include/linux/stddef.h", directory: "/home/yueqichen/hotbpf/src/bpf/uaf-rdma_listen")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10}
!9 = !DIEnumerator(name: "false", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "true", value: 1, isUnsigned: true)
!11 = !{!12}
!12 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!13 = !{!0, !14, !26, !28, !34, !40, !45, !53, !60, !65, !70}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "inuse_map", scope: !2, file: !3, line: 28, type: !16, isLocal: false, isDefinition: true)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !17, line: 196, size: 224, elements: !18)
!17 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/tools/testing/selftests/bpf/bpf_helpers.h", directory: "/home/yueqichen/hotbpf/src/bpf/uaf-rdma_listen")
!18 = !{!19, !20, !21, !22, !23, !24, !25}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !16, file: !17, line: 197, baseType: !7, size: 32)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !16, file: !17, line: 198, baseType: !7, size: 32, offset: 32)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !16, file: !17, line: 199, baseType: !7, size: 32, offset: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !16, file: !17, line: 200, baseType: !7, size: 32, offset: 96)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !16, file: !17, line: 201, baseType: !7, size: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !16, file: !17, line: 202, baseType: !7, size: 32, offset: 160)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !16, file: !17, line: 203, baseType: !7, size: 32, offset: 192)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "infree_map", scope: !2, file: !3, line: 35, type: !16, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 187, type: !30, isLocal: false, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 32, elements: !32)
!31 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!32 = !{!33}
!33 = !DISubrange(count: 4)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "_version", scope: !2, file: !3, line: 188, type: !36, isLocal: false, isDefinition: true)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "u32", file: !37, line: 21, baseType: !38)
!37 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/include/asm-generic/int-ll64.h", directory: "/home/yueqichen/hotbpf/src/bpf/uaf-rdma_listen")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !39, line: 27, baseType: !7)
!39 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/include/uapi/asm-generic/int-ll64.h", directory: "/home/yueqichen/hotbpf/src/bpf/uaf-rdma_listen")
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bpf_vmalloc", scope: !2, file: !17, line: 175, type: !42, isLocal: true, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DISubroutineType(types: !44)
!44 = !{!12, !12}
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !17, line: 30, type: !47, isLocal: true, isDefinition: true)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DISubroutineType(types: !49)
!49 = !{!50, !51, !50, null}
!50 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !17, line: 14, type: !55, isLocal: true, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{!50, !58, !58, !58, !59}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!59 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "bpf_override_return2", scope: !2, file: !17, line: 179, type: !62, isLocal: true, isDefinition: true)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!50, !58, !12}
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !17, line: 12, type: !67, isLocal: true, isDefinition: true)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = !DISubroutineType(types: !69)
!69 = !{!58, !58, !58}
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bpf_map_delete_elem", scope: !2, file: !17, line: 17, type: !72, isLocal: true, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DISubroutineType(types: !74)
!74 = !{!50, !58, !58}
!75 = !{i32 7, !"Dwarf Version", i32 4}
!76 = !{i32 2, !"Debug Info Version", i32 3}
!77 = !{i32 1, !"wchar_size", i32 4}
!78 = !{!"clang version 10.0.0-4ubuntu1 "}
!79 = distinct !DISubprogram(name: "is_target_alloc_site", scope: !3, file: !3, line: 115, type: !80, scopeLine: 115, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !85)
!80 = !DISubroutineType(types: !81)
!81 = !{!82, !12}
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !83, line: 30, baseType: !84)
!83 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/include/linux/types.h", directory: "/home/yueqichen/hotbpf/src/bpf/uaf-rdma_listen")
!84 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!85 = !{!86, !87, !91}
!86 = !DILocalVariable(name: "curr_ip", arg: 1, scope: !79, file: !3, line: 115, type: !12)
!87 = !DILocalVariable(name: "alloc_site_array", scope: !79, file: !3, line: 116, type: !88)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 64, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 1)
!91 = !DILocalVariable(name: "cnt", scope: !79, file: !3, line: 119, type: !50)
!92 = !DILocation(line: 0, scope: !79)
!93 = !DILocation(line: 121, column: 15, scope: !94)
!94 = distinct !DILexicalBlock(scope: !95, file: !3, line: 121, column: 7)
!95 = distinct !DILexicalBlock(scope: !96, file: !3, line: 120, column: 39)
!96 = distinct !DILexicalBlock(scope: !97, file: !3, line: 120, column: 2)
!97 = distinct !DILexicalBlock(scope: !79, file: !3, line: 120, column: 2)
!98 = !DILocation(line: 125, column: 1, scope: !79)
!99 = distinct !DISubprogram(name: "probe_kmem_cache_alloc_trace", scope: !3, file: !3, line: 128, type: !100, scopeLine: 129, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !113)
!100 = !DISubroutineType(types: !101)
!101 = !{!50, !102}
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "kmem_cache_alloc_context", file: !3, line: 59, size: 384, elements: !104)
!104 = !{!105, !107, !108, !109, !110, !111}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !103, file: !3, line: 60, baseType: !106, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !39, line: 31, baseType: !59)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "call_site", scope: !103, file: !3, line: 61, baseType: !106, size: 64, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "ptr", scope: !103, file: !3, line: 62, baseType: !58, size: 64, offset: 128)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_req", scope: !103, file: !3, line: 63, baseType: !106, size: 64, offset: 192)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_alloc", scope: !103, file: !3, line: 64, baseType: !106, size: 64, offset: 256)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "gfp_flags", scope: !103, file: !3, line: 65, baseType: !112, size: 32, offset: 320)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "gfp_t", file: !83, line: 158, baseType: !7)
!113 = !{!114, !115, !116, !117, !119, !128}
!114 = !DILocalVariable(name: "ctx", arg: 1, scope: !99, file: !3, line: 128, type: !102)
!115 = !DILocalVariable(name: "alloc_addr", scope: !99, file: !3, line: 130, type: !12)
!116 = !DILocalVariable(name: "alloc_size", scope: !99, file: !3, line: 131, type: !12)
!117 = !DILocalVariable(name: "ip", scope: !99, file: !3, line: 133, type: !118)
!118 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!119 = !DILocalVariable(name: "____fmt", scope: !120, file: !3, line: 144, type: !125)
!120 = distinct !DILexicalBlock(scope: !121, file: !3, line: 144, column: 25)
!121 = distinct !DILexicalBlock(scope: !122, file: !3, line: 143, column: 34)
!122 = distinct !DILexicalBlock(scope: !123, file: !3, line: 143, column: 21)
!123 = distinct !DILexicalBlock(scope: !124, file: !3, line: 138, column: 39)
!124 = distinct !DILexicalBlock(scope: !99, file: !3, line: 138, column: 13)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 376, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 47)
!128 = !DILocalVariable(name: "____fmt", scope: !129, file: !3, line: 147, type: !131)
!129 = distinct !DILexicalBlock(scope: !130, file: !3, line: 147, column: 25)
!130 = distinct !DILexicalBlock(scope: !122, file: !3, line: 145, column: 24)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 304, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 38)
!134 = !DILocation(line: 0, scope: !99)
!135 = !DILocation(line: 130, column: 9, scope: !99)
!136 = !DILocation(line: 130, column: 23, scope: !99)
!137 = !{!138, !138, i64 0}
!138 = !{!"long", !139, i64 0}
!139 = !{!"omnipotent char", !140, i64 0}
!140 = !{!"Simple C/C++ TBAA"}
!141 = !DILocation(line: 131, column: 9, scope: !99)
!142 = !DILocation(line: 131, column: 23, scope: !99)
!143 = !DILocation(line: 133, column: 24, scope: !99)
!144 = !{!145, !146, i64 8}
!145 = !{!"kmem_cache_alloc_context", !146, i64 0, !146, i64 8, !147, i64 16, !146, i64 24, !146, i64 32, !148, i64 40}
!146 = !{!"long long", !139, i64 0}
!147 = !{!"any pointer", !139, i64 0}
!148 = !{!"int", !139, i64 0}
!149 = !DILocation(line: 0, scope: !79, inlinedAt: !150)
!150 = distinct !DILocation(line: 138, column: 13, scope: !124)
!151 = !DILocation(line: 121, column: 15, scope: !94, inlinedAt: !150)
!152 = !DILocation(line: 138, column: 13, scope: !99)
!153 = !DILocation(line: 140, column: 35, scope: !123)
!154 = !{!145, !146, i64 24}
!155 = !DILocation(line: 140, column: 28, scope: !123)
!156 = !DILocation(line: 141, column: 30, scope: !123)
!157 = !DILocation(line: 141, column: 28, scope: !123)
!158 = !DILocation(line: 143, column: 22, scope: !122)
!159 = !DILocation(line: 143, column: 21, scope: !123)
!160 = !DILocation(line: 144, column: 25, scope: !120)
!161 = !DILocation(line: 144, column: 25, scope: !121)
!162 = !DILocation(line: 145, column: 17, scope: !121)
!163 = !DILocation(line: 147, column: 25, scope: !129)
!164 = !DILocation(line: 147, column: 25, scope: !130)
!165 = !DILocation(line: 148, column: 25, scope: !130)
!166 = !DILocation(line: 149, column: 46, scope: !130)
!167 = !DILocation(line: 149, column: 66, scope: !130)
!168 = !DILocation(line: 149, column: 25, scope: !130)
!169 = !DILocation(line: 155, column: 1, scope: !99)
!170 = !DILocation(line: 153, column: 9, scope: !99)
!171 = distinct !DISubprogram(name: "probe_kfree", scope: !3, file: !3, line: 158, type: !172, scopeLine: 159, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !180)
!172 = !DISubroutineType(types: !173)
!173 = !{!50, !174}
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !175, size: 64)
!175 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "kfree_context", file: !3, line: 107, size: 192, elements: !176)
!176 = !{!177, !178, !179}
!177 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !175, file: !3, line: 108, baseType: !106, size: 64)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "call_site", scope: !175, file: !3, line: 109, baseType: !106, size: 64, offset: 64)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "ptr", scope: !175, file: !3, line: 110, baseType: !58, size: 64, offset: 128)
!180 = !{!181, !182, !183, !185}
!181 = !DILocalVariable(name: "ctx", arg: 1, scope: !171, file: !3, line: 158, type: !174)
!182 = !DILocalVariable(name: "alloc_addr", scope: !171, file: !3, line: 160, type: !12)
!183 = !DILocalVariable(name: "alloc_size", scope: !171, file: !3, line: 161, type: !184)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!185 = !DILocalVariable(name: "____fmt", scope: !186, file: !3, line: 164, type: !189)
!186 = distinct !DILexicalBlock(scope: !187, file: !3, line: 164, column: 3)
!187 = distinct !DILexicalBlock(scope: !188, file: !3, line: 163, column: 18)
!188 = distinct !DILexicalBlock(scope: !171, file: !3, line: 163, column: 6)
!189 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 280, elements: !190)
!190 = !{!191}
!191 = !DISubrange(count: 35)
!192 = !DILocation(line: 0, scope: !171)
!193 = !DILocation(line: 160, column: 2, scope: !171)
!194 = !DILocation(line: 160, column: 49, scope: !171)
!195 = !{!196, !147, i64 16}
!196 = !{!"kfree_context", !146, i64 0, !146, i64 8, !147, i64 16}
!197 = !DILocation(line: 160, column: 16, scope: !171)
!198 = !DILocation(line: 161, column: 21, scope: !171)
!199 = !DILocation(line: 163, column: 6, scope: !188)
!200 = !DILocation(line: 163, column: 6, scope: !171)
!201 = !DILocation(line: 164, column: 3, scope: !186)
!202 = !DILocation(line: 164, column: 3, scope: !187)
!203 = !DILocation(line: 168, column: 3, scope: !187)
!204 = !DILocation(line: 180, column: 24, scope: !187)
!205 = !DILocation(line: 180, column: 3, scope: !187)
!206 = !DILocation(line: 181, column: 3, scope: !187)
!207 = !DILocation(line: 185, column: 1, scope: !171)
