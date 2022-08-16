; ModuleID = 'hotbpf_kern.c'
source_filename = "hotbpf_kern.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.pt_regs = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }

@allocs_map = dso_local global %struct.bpf_map_def { i32 1, i32 4, i32 4, i32 4096, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@inuse_map = dso_local global %struct.bpf_map_def { i32 1, i32 8, i32 8, i32 4096, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !8
@__const.probe_nf_tables_newflowtable.____fmt = private unnamed_addr constant [41 x i8] c"single_open start: update map failed %d\0A\00", align 16
@__const.clear_allocs_map.____fmt = private unnamed_addr constant [47 x i8] c"single_open end: delete map failed %d  %u  %u\0A\00", align 16
@__const.clear_allocs_map.____fmt.1 = private unnamed_addr constant [52 x i8] c"single_open end bad thing happens pid:%d  *pval:%u\0A\00", align 16
@__const.probe_kmem_cache_alloc_trace.____fmt = private unnamed_addr constant [47 x i8] c"[hotbpf] fail to do vmalloc, back to original\0A\00", align 16
@__const.probe_kmem_cache_alloc_trace.____fmt.2 = private unnamed_addr constant [38 x i8] c"[hotbpf] do vmalloc and return 0x%lx\0A\00", align 16
@__const.probe_kfree.____fmt = private unnamed_addr constant [35 x i8] c"[hotbpf] never do vfree for 0x%lx\0A\00", align 16
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !21
@_version = dso_local global i32 327680, section "version", align 4, !dbg !27
@llvm.used = appending global [7 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32* @_version to i8*), i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* bitcast (i32 (%struct.pt_regs*)* @probe_kfree to i8*), i8* bitcast (i32 (%struct.pt_regs*)* @probe_kmem_cache_alloc_trace to i8*), i8* bitcast (i32 ()* @probe_nf_tables_newflowtable to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local i32 @probe_nf_tables_newflowtable() #0 section "kprobe/nf_tables_newtable" !dbg !77 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca [41 x i8], align 16
  %4 = bitcast i32* %1 to i8*, !dbg !91
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3, !dbg !91
  %5 = tail call i64 inttoptr (i64 14 to i64 ()*)() #3, !dbg !92
  %6 = trunc i64 %5 to i32, !dbg !92
  call void @llvm.dbg.value(metadata i32 %6, metadata !81, metadata !DIExpression()), !dbg !93
  store i32 %6, i32* %1, align 4, !dbg !94, !tbaa !95
  %7 = bitcast i32* %2 to i8*, !dbg !99
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %7) #3, !dbg !99
  call void @llvm.dbg.value(metadata i32 1, metadata !82, metadata !DIExpression()), !dbg !93
  store i32 1, i32* %2, align 4, !dbg !100, !tbaa !95
  call void @llvm.dbg.value(metadata i32 0, metadata !83, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.value(metadata i32* %1, metadata !81, metadata !DIExpression(DW_OP_deref)), !dbg !93
  call void @llvm.dbg.value(metadata i32* %2, metadata !82, metadata !DIExpression(DW_OP_deref)), !dbg !93
  %8 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %4, i8* nonnull %7, i64 0) #3, !dbg !101
  call void @llvm.dbg.value(metadata i32 %8, metadata !83, metadata !DIExpression()), !dbg !93
  %9 = icmp slt i32 %8, 0, !dbg !102
  br i1 %9, label %10, label %13, !dbg !103

10:                                               ; preds = %0
  %11 = getelementptr inbounds [41 x i8], [41 x i8]* %3, i64 0, i64 0, !dbg !104
  call void @llvm.lifetime.start.p0i8(i64 41, i8* nonnull %11) #3, !dbg !104
  call void @llvm.dbg.declare(metadata [41 x i8]* %3, metadata !84, metadata !DIExpression()), !dbg !104
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(41) %11, i8* nonnull align 16 dereferenceable(41) getelementptr inbounds ([41 x i8], [41 x i8]* @__const.probe_nf_tables_newflowtable.____fmt, i64 0, i64 0), i64 41, i1 false), !dbg !104
  %12 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %11, i32 41, i32 %8) #3, !dbg !104
  call void @llvm.lifetime.end.p0i8(i64 41, i8* nonnull %11) #3, !dbg !105
  br label %13, !dbg !106

13:                                               ; preds = %0, %10
  %14 = phi i32 [ %8, %10 ], [ 0, %0 ], !dbg !93
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %7) #3, !dbg !107
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3, !dbg !107
  ret i32 %14, !dbg !107
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @clear_allocs_map() local_unnamed_addr #0 !dbg !108 {
  %1 = alloca i32, align 4
  %2 = alloca [47 x i8], align 16
  %3 = alloca [52 x i8], align 16
  %4 = bitcast i32* %1 to i8*, !dbg !130
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3, !dbg !130
  %5 = tail call i64 inttoptr (i64 14 to i64 ()*)() #3, !dbg !131
  %6 = trunc i64 %5 to i32, !dbg !131
  call void @llvm.dbg.value(metadata i32 %6, metadata !110, metadata !DIExpression()), !dbg !132
  store i32 %6, i32* %1, align 4, !dbg !133, !tbaa !95
  call void @llvm.dbg.value(metadata i32 0, metadata !111, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.value(metadata i32* null, metadata !112, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.value(metadata i32 0, metadata !114, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.value(metadata i32* %1, metadata !110, metadata !DIExpression(DW_OP_deref)), !dbg !132
  %7 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %4) #3, !dbg !134
  %8 = bitcast i8* %7 to i32*, !dbg !134
  call void @llvm.dbg.value(metadata i32* %8, metadata !112, metadata !DIExpression()), !dbg !132
  %9 = icmp eq i8* %7, null, !dbg !135
  br i1 %9, label %18, label %10, !dbg !136

10:                                               ; preds = %0
  call void @llvm.dbg.value(metadata i32* %1, metadata !110, metadata !DIExpression(DW_OP_deref)), !dbg !132
  %11 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %4) #3, !dbg !137
  call void @llvm.dbg.value(metadata i32 %11, metadata !111, metadata !DIExpression()), !dbg !132
  %12 = icmp slt i32 %11, 0, !dbg !138
  br i1 %12, label %13, label %22, !dbg !139

13:                                               ; preds = %10
  %14 = getelementptr inbounds [47 x i8], [47 x i8]* %2, i64 0, i64 0, !dbg !140
  call void @llvm.lifetime.start.p0i8(i64 47, i8* nonnull %14) #3, !dbg !140
  call void @llvm.dbg.declare(metadata [47 x i8]* %2, metadata !115, metadata !DIExpression()), !dbg !140
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(47) %14, i8* nonnull align 16 dereferenceable(47) getelementptr inbounds ([47 x i8], [47 x i8]* @__const.clear_allocs_map.____fmt, i64 0, i64 0), i64 47, i1 false), !dbg !140
  %15 = load i32, i32* %1, align 4, !dbg !140, !tbaa !95
  call void @llvm.dbg.value(metadata i32 %15, metadata !110, metadata !DIExpression()), !dbg !132
  %16 = load i32, i32* %8, align 4, !dbg !140, !tbaa !95
  %17 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %14, i32 47, i32 %11, i32 %15, i32 %16) #3, !dbg !140
  call void @llvm.lifetime.end.p0i8(i64 47, i8* nonnull %14) #3, !dbg !141
  br label %22, !dbg !142

18:                                               ; preds = %0
  %19 = getelementptr inbounds [52 x i8], [52 x i8]* %3, i64 0, i64 0, !dbg !143
  call void @llvm.lifetime.start.p0i8(i64 52, i8* nonnull %19) #3, !dbg !143
  call void @llvm.dbg.declare(metadata [52 x i8]* %3, metadata !124, metadata !DIExpression()), !dbg !143
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(52) %19, i8* nonnull align 16 dereferenceable(52) getelementptr inbounds ([52 x i8], [52 x i8]* @__const.clear_allocs_map.____fmt.1, i64 0, i64 0), i64 52, i1 false), !dbg !143
  %20 = load i32, i32* %1, align 4, !dbg !143, !tbaa !95
  call void @llvm.dbg.value(metadata i32 %20, metadata !110, metadata !DIExpression()), !dbg !132
  %21 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %19, i32 52, i32 %20, i32 undef) #3, !dbg !143
  call void @llvm.lifetime.end.p0i8(i64 52, i8* nonnull %19) #3, !dbg !144
  br label %22

22:                                               ; preds = %18, %10, %13
  %23 = phi i32 [ %11, %13 ], [ 0, %10 ], [ 0, %18 ], !dbg !132
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3, !dbg !145
  ret i32 %23, !dbg !145
}

; Function Attrs: nounwind uwtable
define dso_local i32 @in_context(i32 %0) local_unnamed_addr #0 !dbg !146 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata i32 %0, metadata !150, metadata !DIExpression()), !dbg !152
  store i32 %0, i32* %2, align 4, !tbaa !95
  call void @llvm.dbg.value(metadata i32* null, metadata !151, metadata !DIExpression()), !dbg !152
  %3 = bitcast i32* %2 to i8*, !dbg !153
  call void @llvm.dbg.value(metadata i32* %2, metadata !150, metadata !DIExpression(DW_OP_deref)), !dbg !152
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %3) #3, !dbg !154
  call void @llvm.dbg.value(metadata i8* %4, metadata !151, metadata !DIExpression()), !dbg !152
  %5 = icmp eq i8* %4, null, !dbg !155
  %6 = select i1 %5, i32 -1, i32 1, !dbg !157
  ret i32 %6, !dbg !158
}

; Function Attrs: nounwind uwtable
define dso_local i32 @probe_kmem_cache_alloc_trace(%struct.pt_regs* %0) #0 section "kprobe/kmem_cache_alloc_trace" !dbg !159 {
  %2 = alloca i32, align 4
  %3 = alloca [47 x i8], align 16
  call void @llvm.dbg.declare(metadata [47 x i8]* %3, metadata !115, metadata !DIExpression()), !dbg !205
  %4 = alloca [52 x i8], align 16
  call void @llvm.dbg.declare(metadata [52 x i8]* %4, metadata !124, metadata !DIExpression()), !dbg !207
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca [47 x i8], align 16
  %9 = alloca [38 x i8], align 16
  call void @llvm.dbg.value(metadata %struct.pt_regs* %0, metadata !188, metadata !DIExpression()), !dbg !208
  %10 = bitcast i64* %6 to i8*, !dbg !209
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %10) #3, !dbg !209
  call void @llvm.dbg.value(metadata i64 0, metadata !189, metadata !DIExpression()), !dbg !208
  store i64 0, i64* %6, align 8, !dbg !210, !tbaa !211
  %11 = bitcast i64* %7 to i8*, !dbg !213
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %11) #3, !dbg !213
  call void @llvm.dbg.value(metadata i64 0, metadata !190, metadata !DIExpression()), !dbg !208
  store i64 0, i64* %7, align 8, !dbg !214, !tbaa !211
  %12 = tail call i64 inttoptr (i64 14 to i64 ()*)() #3, !dbg !215
  %13 = trunc i64 %12 to i32, !dbg !215
  call void @llvm.dbg.value(metadata i32 %13, metadata !191, metadata !DIExpression()), !dbg !208
  %14 = bitcast i32* %5 to i8*, !dbg !216
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14), !dbg !216
  call void @llvm.dbg.value(metadata i32 %13, metadata !150, metadata !DIExpression()) #3, !dbg !216
  store i32 %13, i32* %5, align 4, !tbaa !95
  call void @llvm.dbg.value(metadata i32* null, metadata !151, metadata !DIExpression()) #3, !dbg !216
  call void @llvm.dbg.value(metadata i32* %5, metadata !150, metadata !DIExpression(DW_OP_deref)) #3, !dbg !216
  %15 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %14) #3, !dbg !218
  call void @llvm.dbg.value(metadata i8* %15, metadata !151, metadata !DIExpression()) #3, !dbg !216
  %16 = icmp eq i8* %15, null, !dbg !219
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14), !dbg !220
  call void @llvm.dbg.value(metadata i32 undef, metadata !192, metadata !DIExpression()), !dbg !208
  br i1 %16, label %51, label %17, !dbg !221

17:                                               ; preds = %1
  %18 = bitcast i32* %2 to i8*, !dbg !222
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %18) #3, !dbg !222
  %19 = call i64 inttoptr (i64 14 to i64 ()*)() #3, !dbg !223
  %20 = trunc i64 %19 to i32, !dbg !223
  call void @llvm.dbg.value(metadata i32 %20, metadata !110, metadata !DIExpression()) #3, !dbg !224
  store i32 %20, i32* %2, align 4, !dbg !225, !tbaa !95
  call void @llvm.dbg.value(metadata i32 0, metadata !111, metadata !DIExpression()) #3, !dbg !224
  call void @llvm.dbg.value(metadata i32* null, metadata !112, metadata !DIExpression()) #3, !dbg !224
  call void @llvm.dbg.value(metadata i32 0, metadata !114, metadata !DIExpression()) #3, !dbg !224
  call void @llvm.dbg.value(metadata i32* %2, metadata !110, metadata !DIExpression(DW_OP_deref)) #3, !dbg !224
  %21 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %18) #3, !dbg !226
  %22 = bitcast i8* %21 to i32*, !dbg !226
  call void @llvm.dbg.value(metadata i32* %22, metadata !112, metadata !DIExpression()) #3, !dbg !224
  %23 = icmp eq i8* %21, null, !dbg !227
  br i1 %23, label %32, label %24, !dbg !228

24:                                               ; preds = %17
  call void @llvm.dbg.value(metadata i32* %2, metadata !110, metadata !DIExpression(DW_OP_deref)) #3, !dbg !224
  %25 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @allocs_map to i8*), i8* nonnull %18) #3, !dbg !229
  call void @llvm.dbg.value(metadata i32 %25, metadata !111, metadata !DIExpression()) #3, !dbg !224
  %26 = icmp slt i32 %25, 0, !dbg !230
  br i1 %26, label %27, label %36, !dbg !231

27:                                               ; preds = %24
  %28 = getelementptr inbounds [47 x i8], [47 x i8]* %3, i64 0, i64 0, !dbg !205
  call void @llvm.lifetime.start.p0i8(i64 47, i8* nonnull %28) #3, !dbg !205
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(47) %28, i8* nonnull align 16 dereferenceable(47) getelementptr inbounds ([47 x i8], [47 x i8]* @__const.clear_allocs_map.____fmt, i64 0, i64 0), i64 47, i1 false) #3, !dbg !205
  %29 = load i32, i32* %2, align 4, !dbg !205, !tbaa !95
  call void @llvm.dbg.value(metadata i32 %29, metadata !110, metadata !DIExpression()) #3, !dbg !224
  %30 = load i32, i32* %22, align 4, !dbg !205, !tbaa !95
  %31 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %28, i32 47, i32 %25, i32 %29, i32 %30) #3, !dbg !205
  call void @llvm.lifetime.end.p0i8(i64 47, i8* nonnull %28) #3, !dbg !232
  br label %36, !dbg !233

32:                                               ; preds = %17
  %33 = getelementptr inbounds [52 x i8], [52 x i8]* %4, i64 0, i64 0, !dbg !207
  call void @llvm.lifetime.start.p0i8(i64 52, i8* nonnull %33) #3, !dbg !207
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(52) %33, i8* nonnull align 16 dereferenceable(52) getelementptr inbounds ([52 x i8], [52 x i8]* @__const.clear_allocs_map.____fmt.1, i64 0, i64 0), i64 52, i1 false) #3, !dbg !207
  %34 = load i32, i32* %2, align 4, !dbg !207, !tbaa !95
  call void @llvm.dbg.value(metadata i32 %34, metadata !110, metadata !DIExpression()) #3, !dbg !224
  %35 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %33, i32 52, i32 %34, i32 undef) #3, !dbg !207
  call void @llvm.lifetime.end.p0i8(i64 52, i8* nonnull %33) #3, !dbg !234
  br label %36

36:                                               ; preds = %24, %27, %32
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %18) #3, !dbg !235
  %37 = getelementptr inbounds %struct.pt_regs, %struct.pt_regs* %0, i64 0, i32 12, !dbg !236
  %38 = load i64, i64* %37, align 8, !dbg !236, !tbaa !237
  call void @llvm.dbg.value(metadata i64 %38, metadata !190, metadata !DIExpression()), !dbg !208
  store i64 %38, i64* %7, align 8, !dbg !239, !tbaa !211
  %39 = call i64 inttoptr (i64 93 to i64 (i64)*)(i64 %38) #3, !dbg !240
  call void @llvm.dbg.value(metadata i64 %39, metadata !189, metadata !DIExpression()), !dbg !208
  store i64 %39, i64* %6, align 8, !dbg !241, !tbaa !211
  %40 = icmp eq i64 %39, 0, !dbg !242
  br i1 %40, label %41, label %44, !dbg !243

41:                                               ; preds = %36
  %42 = getelementptr inbounds [47 x i8], [47 x i8]* %8, i64 0, i64 0, !dbg !244
  call void @llvm.lifetime.start.p0i8(i64 47, i8* nonnull %42) #3, !dbg !244
  call void @llvm.dbg.declare(metadata [47 x i8]* %8, metadata !193, metadata !DIExpression()), !dbg !244
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(47) %42, i8* nonnull align 16 dereferenceable(47) getelementptr inbounds ([47 x i8], [47 x i8]* @__const.probe_kmem_cache_alloc_trace.____fmt, i64 0, i64 0), i64 47, i1 false), !dbg !244
  %43 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %42, i32 47) #3, !dbg !244
  call void @llvm.lifetime.end.p0i8(i64 47, i8* nonnull %42) #3, !dbg !245
  br label %51, !dbg !246

44:                                               ; preds = %36
  %45 = getelementptr inbounds [38 x i8], [38 x i8]* %9, i64 0, i64 0, !dbg !247
  call void @llvm.lifetime.start.p0i8(i64 38, i8* nonnull %45) #3, !dbg !247
  call void @llvm.dbg.declare(metadata [38 x i8]* %9, metadata !199, metadata !DIExpression()), !dbg !247
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(38) %45, i8* nonnull align 16 dereferenceable(38) getelementptr inbounds ([38 x i8], [38 x i8]* @__const.probe_kmem_cache_alloc_trace.____fmt.2, i64 0, i64 0), i64 38, i1 false), !dbg !247
  call void @llvm.dbg.value(metadata i64 %39, metadata !189, metadata !DIExpression()), !dbg !208
  %46 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %45, i32 38, i64 %39) #3, !dbg !247
  call void @llvm.lifetime.end.p0i8(i64 38, i8* nonnull %45) #3, !dbg !248
  call void @llvm.dbg.value(metadata i64* %6, metadata !189, metadata !DIExpression(DW_OP_deref)), !dbg !208
  call void @llvm.dbg.value(metadata i64* %7, metadata !190, metadata !DIExpression(DW_OP_deref)), !dbg !208
  %47 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* nonnull %10, i8* nonnull %11, i64 0) #3, !dbg !249
  %48 = bitcast %struct.pt_regs* %0 to i8*, !dbg !250
  %49 = load i64, i64* %6, align 8, !dbg !251, !tbaa !211
  call void @llvm.dbg.value(metadata i64 %49, metadata !189, metadata !DIExpression()), !dbg !208
  %50 = call i32 inttoptr (i64 95 to i32 (i8*, i64)*)(i8* %48, i64 %49) #3, !dbg !252
  br label %51

51:                                               ; preds = %44, %41, %1
  %52 = phi i32 [ -1, %1 ], [ 0, %41 ], [ 0, %44 ], !dbg !208
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %11) #3, !dbg !253
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %10) #3, !dbg !253
  ret i32 %52, !dbg !253
}

; Function Attrs: nounwind uwtable
define dso_local i32 @probe_kfree(%struct.pt_regs* %0) #0 section "kprobe/kfree" !dbg !254 {
  %2 = alloca i64, align 8
  %3 = alloca [35 x i8], align 16
  call void @llvm.dbg.value(metadata %struct.pt_regs* %0, metadata !256, metadata !DIExpression()), !dbg !268
  %4 = bitcast i64* %2 to i8*, !dbg !269
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %4) #3, !dbg !269
  %5 = getelementptr inbounds %struct.pt_regs, %struct.pt_regs* %0, i64 0, i32 14, !dbg !270
  %6 = load i64, i64* %5, align 8, !dbg !270, !tbaa !271
  call void @llvm.dbg.value(metadata i64 %6, metadata !257, metadata !DIExpression()), !dbg !268
  store i64 %6, i64* %2, align 8, !dbg !272, !tbaa !211
  call void @llvm.dbg.value(metadata i64* %2, metadata !257, metadata !DIExpression(DW_OP_deref)), !dbg !268
  %7 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* nonnull %4) #3, !dbg !273
  call void @llvm.dbg.value(metadata i8* %7, metadata !258, metadata !DIExpression()), !dbg !268
  %8 = icmp eq i8* %7, null, !dbg !274
  br i1 %8, label %16, label %9, !dbg !275

9:                                                ; preds = %1
  %10 = getelementptr inbounds [35 x i8], [35 x i8]* %3, i64 0, i64 0, !dbg !276
  call void @llvm.lifetime.start.p0i8(i64 35, i8* nonnull %10) #3, !dbg !276
  call void @llvm.dbg.declare(metadata [35 x i8]* %3, metadata !261, metadata !DIExpression()), !dbg !276
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 16 dereferenceable(35) %10, i8* nonnull align 16 dereferenceable(35) getelementptr inbounds ([35 x i8], [35 x i8]* @__const.probe_kfree.____fmt, i64 0, i64 0), i64 35, i1 false), !dbg !276
  %11 = load i64, i64* %2, align 8, !dbg !276, !tbaa !211
  call void @llvm.dbg.value(metadata i64 %11, metadata !257, metadata !DIExpression()), !dbg !268
  %12 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %10, i32 35, i64 %11) #3, !dbg !276
  call void @llvm.lifetime.end.p0i8(i64 35, i8* nonnull %10) #3, !dbg !277
  call void @llvm.dbg.value(metadata i64* %2, metadata !257, metadata !DIExpression(DW_OP_deref)), !dbg !268
  %13 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @inuse_map to i8*), i8* nonnull %4) #3, !dbg !278
  %14 = bitcast %struct.pt_regs* %0 to i8*, !dbg !279
  %15 = call i32 inttoptr (i64 95 to i32 (i8*, i64)*)(i8* %14, i64 0) #3, !dbg !280
  br label %16, !dbg !281

16:                                               ; preds = %1, %9
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %4) #3, !dbg !282
  ret i32 0, !dbg !282
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "allocs_map", scope: !2, file: !3, line: 20, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "hotbpf_kern.c", directory: "/home/yueqichen/hotbpf/src/bpf/bug-nf_tables_commit")
!4 = !{}
!5 = !{!6}
!6 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!7 = !{!0, !8, !21, !27, !33, !39, !46, !53, !58, !63, !68}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "inuse_map", scope: !2, file: !3, line: 27, type: !10, isLocal: false, isDefinition: true)
!10 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !11, line: 196, size: 224, elements: !12)
!11 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/tools/testing/selftests/bpf/bpf_helpers.h", directory: "/home/yueqichen/hotbpf/src/bpf/bug-nf_tables_commit")
!12 = !{!13, !15, !16, !17, !18, !19, !20}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !10, file: !11, line: 197, baseType: !14, size: 32)
!14 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !10, file: !11, line: 198, baseType: !14, size: 32, offset: 32)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !10, file: !11, line: 199, baseType: !14, size: 32, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !10, file: !11, line: 200, baseType: !14, size: 32, offset: 96)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !10, file: !11, line: 201, baseType: !14, size: 32, offset: 128)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !10, file: !11, line: 202, baseType: !14, size: 32, offset: 160)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !10, file: !11, line: 203, baseType: !14, size: 32, offset: 192)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 144, type: !23, isLocal: false, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "_version", scope: !2, file: !3, line: 145, type: !29, isLocal: false, isDefinition: true)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "u32", file: !30, line: 21, baseType: !31)
!30 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/include/asm-generic/int-ll64.h", directory: "/home/yueqichen/hotbpf/src/bpf/bug-nf_tables_commit")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !32, line: 27, baseType: !14)
!32 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/include/uapi/asm-generic/int-ll64.h", directory: "/home/yueqichen/hotbpf/src/bpf/bug-nf_tables_commit")
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "bpf_get_current_pid_tgid", scope: !2, file: !11, line: 36, type: !35, isLocal: true, isDefinition: true)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DISubroutineType(types: !37)
!37 = !{!38}
!38 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !11, line: 14, type: !41, isLocal: true, isDefinition: true)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DISubroutineType(types: !43)
!43 = !{!44, !45, !45, !45, !38}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !11, line: 30, type: !48, isLocal: true, isDefinition: true)
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = !DISubroutineType(types: !50)
!50 = !{!44, !51, !44, null}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !11, line: 12, type: !55, isLocal: true, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{!45, !45, !45}
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bpf_map_delete_elem", scope: !2, file: !11, line: 17, type: !60, isLocal: true, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DISubroutineType(types: !62)
!62 = !{!44, !45, !45}
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "bpf_vmalloc", scope: !2, file: !11, line: 175, type: !65, isLocal: true, isDefinition: true)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DISubroutineType(types: !67)
!67 = !{!6, !6}
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bpf_override_return2", scope: !2, file: !11, line: 179, type: !70, isLocal: true, isDefinition: true)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DISubroutineType(types: !72)
!72 = !{!44, !45, !6}
!73 = !{i32 7, !"Dwarf Version", i32 4}
!74 = !{i32 2, !"Debug Info Version", i32 3}
!75 = !{i32 1, !"wchar_size", i32 4}
!76 = !{!"clang version 10.0.0-4ubuntu1 "}
!77 = distinct !DISubprogram(name: "probe_nf_tables_newflowtable", scope: !3, file: !3, line: 35, type: !78, scopeLine: 36, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !80)
!78 = !DISubroutineType(types: !79)
!79 = !{!44}
!80 = !{!81, !82, !83, !84}
!81 = !DILocalVariable(name: "pid", scope: !77, file: !3, line: 37, type: !29)
!82 = !DILocalVariable(name: "val", scope: !77, file: !3, line: 38, type: !29)
!83 = !DILocalVariable(name: "err", scope: !77, file: !3, line: 39, type: !44)
!84 = !DILocalVariable(name: "____fmt", scope: !85, file: !3, line: 42, type: !88)
!85 = distinct !DILexicalBlock(scope: !86, file: !3, line: 42, column: 9)
!86 = distinct !DILexicalBlock(scope: !87, file: !3, line: 41, column: 18)
!87 = distinct !DILexicalBlock(scope: !77, file: !3, line: 41, column: 9)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 328, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 41)
!91 = !DILocation(line: 37, column: 5, scope: !77)
!92 = !DILocation(line: 37, column: 15, scope: !77)
!93 = !DILocation(line: 0, scope: !77)
!94 = !DILocation(line: 37, column: 9, scope: !77)
!95 = !{!96, !96, i64 0}
!96 = !{!"int", !97, i64 0}
!97 = !{!"omnipotent char", !98, i64 0}
!98 = !{!"Simple C/C++ TBAA"}
!99 = !DILocation(line: 38, column: 5, scope: !77)
!100 = !DILocation(line: 38, column: 9, scope: !77)
!101 = !DILocation(line: 40, column: 11, scope: !77)
!102 = !DILocation(line: 41, column: 13, scope: !87)
!103 = !DILocation(line: 41, column: 9, scope: !77)
!104 = !DILocation(line: 42, column: 9, scope: !85)
!105 = !DILocation(line: 42, column: 9, scope: !86)
!106 = !DILocation(line: 43, column: 9, scope: !86)
!107 = !DILocation(line: 46, column: 1, scope: !77)
!108 = distinct !DISubprogram(name: "clear_allocs_map", scope: !3, file: !3, line: 48, type: !78, scopeLine: 49, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !109)
!109 = !{!110, !111, !112, !114, !115, !124}
!110 = !DILocalVariable(name: "pid", scope: !108, file: !3, line: 50, type: !29)
!111 = !DILocalVariable(name: "err", scope: !108, file: !3, line: 51, type: !44)
!112 = !DILocalVariable(name: "pval", scope: !108, file: !3, line: 52, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!114 = !DILocalVariable(name: "val", scope: !108, file: !3, line: 53, type: !29)
!115 = !DILocalVariable(name: "____fmt", scope: !116, file: !3, line: 58, type: !121)
!116 = distinct !DILexicalBlock(scope: !117, file: !3, line: 58, column: 13)
!117 = distinct !DILexicalBlock(scope: !118, file: !3, line: 57, column: 22)
!118 = distinct !DILexicalBlock(scope: !119, file: !3, line: 57, column: 13)
!119 = distinct !DILexicalBlock(scope: !120, file: !3, line: 55, column: 15)
!120 = distinct !DILexicalBlock(scope: !108, file: !3, line: 55, column: 9)
!121 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 376, elements: !122)
!122 = !{!123}
!123 = !DISubrange(count: 47)
!124 = !DILocalVariable(name: "____fmt", scope: !125, file: !3, line: 62, type: !127)
!125 = distinct !DILexicalBlock(scope: !126, file: !3, line: 62, column: 9)
!126 = distinct !DILexicalBlock(scope: !120, file: !3, line: 61, column: 12)
!127 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 416, elements: !128)
!128 = !{!129}
!129 = !DISubrange(count: 52)
!130 = !DILocation(line: 50, column: 5, scope: !108)
!131 = !DILocation(line: 50, column: 15, scope: !108)
!132 = !DILocation(line: 0, scope: !108)
!133 = !DILocation(line: 50, column: 9, scope: !108)
!134 = !DILocation(line: 54, column: 12, scope: !108)
!135 = !DILocation(line: 55, column: 9, scope: !120)
!136 = !DILocation(line: 55, column: 9, scope: !108)
!137 = !DILocation(line: 56, column: 15, scope: !119)
!138 = !DILocation(line: 57, column: 17, scope: !118)
!139 = !DILocation(line: 57, column: 13, scope: !119)
!140 = !DILocation(line: 58, column: 13, scope: !116)
!141 = !DILocation(line: 58, column: 13, scope: !117)
!142 = !DILocation(line: 59, column: 13, scope: !117)
!143 = !DILocation(line: 62, column: 9, scope: !125)
!144 = !DILocation(line: 62, column: 9, scope: !126)
!145 = !DILocation(line: 65, column: 1, scope: !108)
!146 = distinct !DISubprogram(name: "in_context", scope: !3, file: !3, line: 67, type: !147, scopeLine: 68, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !149)
!147 = !DISubroutineType(types: !148)
!148 = !{!44, !29}
!149 = !{!150, !151}
!150 = !DILocalVariable(name: "pid", arg: 1, scope: !146, file: !3, line: 67, type: !29)
!151 = !DILocalVariable(name: "pval", scope: !146, file: !3, line: 69, type: !113)
!152 = !DILocation(line: 0, scope: !146)
!153 = !DILocation(line: 70, column: 45, scope: !146)
!154 = !DILocation(line: 70, column: 12, scope: !146)
!155 = !DILocation(line: 71, column: 9, scope: !156)
!156 = distinct !DILexicalBlock(scope: !146, file: !3, line: 71, column: 9)
!157 = !DILocation(line: 0, scope: !156)
!158 = !DILocation(line: 76, column: 1, scope: !146)
!159 = distinct !DISubprogram(name: "probe_kmem_cache_alloc_trace", scope: !3, file: !3, line: 79, type: !160, scopeLine: 80, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !187)
!160 = !DISubroutineType(types: !161)
!161 = !{!44, !162}
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "pt_regs", file: !164, line: 56, size: 1344, elements: !165)
!164 = !DIFile(filename: "../../../baremetal/linux-5.0.0-rc7-harden/linux-5.0-rc7/arch/x86/include/asm/ptrace.h", directory: "/home/yueqichen/hotbpf/src/bpf/bug-nf_tables_commit")
!165 = !{!166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "r15", scope: !163, file: !164, line: 61, baseType: !6, size: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "r14", scope: !163, file: !164, line: 62, baseType: !6, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "r13", scope: !163, file: !164, line: 63, baseType: !6, size: 64, offset: 128)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "r12", scope: !163, file: !164, line: 64, baseType: !6, size: 64, offset: 192)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "bp", scope: !163, file: !164, line: 65, baseType: !6, size: 64, offset: 256)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "bx", scope: !163, file: !164, line: 66, baseType: !6, size: 64, offset: 320)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "r11", scope: !163, file: !164, line: 68, baseType: !6, size: 64, offset: 384)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "r10", scope: !163, file: !164, line: 69, baseType: !6, size: 64, offset: 448)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "r9", scope: !163, file: !164, line: 70, baseType: !6, size: 64, offset: 512)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "r8", scope: !163, file: !164, line: 71, baseType: !6, size: 64, offset: 576)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "ax", scope: !163, file: !164, line: 72, baseType: !6, size: 64, offset: 640)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "cx", scope: !163, file: !164, line: 73, baseType: !6, size: 64, offset: 704)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "dx", scope: !163, file: !164, line: 74, baseType: !6, size: 64, offset: 768)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "si", scope: !163, file: !164, line: 75, baseType: !6, size: 64, offset: 832)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "di", scope: !163, file: !164, line: 76, baseType: !6, size: 64, offset: 896)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "orig_ax", scope: !163, file: !164, line: 81, baseType: !6, size: 64, offset: 960)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "ip", scope: !163, file: !164, line: 83, baseType: !6, size: 64, offset: 1024)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "cs", scope: !163, file: !164, line: 84, baseType: !6, size: 64, offset: 1088)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !163, file: !164, line: 85, baseType: !6, size: 64, offset: 1152)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "sp", scope: !163, file: !164, line: 86, baseType: !6, size: 64, offset: 1216)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "ss", scope: !163, file: !164, line: 87, baseType: !6, size: 64, offset: 1280)
!187 = !{!188, !189, !190, !191, !192, !193, !199}
!188 = !DILocalVariable(name: "ctx", arg: 1, scope: !159, file: !3, line: 79, type: !162)
!189 = !DILocalVariable(name: "alloc_addr", scope: !159, file: !3, line: 81, type: !6)
!190 = !DILocalVariable(name: "alloc_size", scope: !159, file: !3, line: 82, type: !6)
!191 = !DILocalVariable(name: "pid", scope: !159, file: !3, line: 84, type: !29)
!192 = !DILocalVariable(name: "err", scope: !159, file: !3, line: 85, type: !44)
!193 = !DILocalVariable(name: "____fmt", scope: !194, file: !3, line: 95, type: !121)
!194 = distinct !DILexicalBlock(scope: !195, file: !3, line: 95, column: 13)
!195 = distinct !DILexicalBlock(scope: !196, file: !3, line: 94, column: 26)
!196 = distinct !DILexicalBlock(scope: !197, file: !3, line: 94, column: 13)
!197 = distinct !DILexicalBlock(scope: !198, file: !3, line: 88, column: 12)
!198 = distinct !DILexicalBlock(scope: !159, file: !3, line: 86, column: 9)
!199 = !DILocalVariable(name: "____fmt", scope: !200, file: !3, line: 98, type: !202)
!200 = distinct !DILexicalBlock(scope: !201, file: !3, line: 98, column: 13)
!201 = distinct !DILexicalBlock(scope: !196, file: !3, line: 96, column: 16)
!202 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 304, elements: !203)
!203 = !{!204}
!204 = !DISubrange(count: 38)
!205 = !DILocation(line: 58, column: 13, scope: !116, inlinedAt: !206)
!206 = distinct !DILocation(line: 89, column: 6, scope: !197)
!207 = !DILocation(line: 62, column: 9, scope: !125, inlinedAt: !206)
!208 = !DILocation(line: 0, scope: !159)
!209 = !DILocation(line: 81, column: 5, scope: !159)
!210 = !DILocation(line: 81, column: 19, scope: !159)
!211 = !{!212, !212, i64 0}
!212 = !{!"long", !97, i64 0}
!213 = !DILocation(line: 82, column: 5, scope: !159)
!214 = !DILocation(line: 82, column: 19, scope: !159)
!215 = !DILocation(line: 84, column: 15, scope: !159)
!216 = !DILocation(line: 0, scope: !146, inlinedAt: !217)
!217 = distinct !DILocation(line: 85, column: 15, scope: !159)
!218 = !DILocation(line: 70, column: 12, scope: !146, inlinedAt: !217)
!219 = !DILocation(line: 71, column: 9, scope: !156, inlinedAt: !217)
!220 = !DILocation(line: 76, column: 1, scope: !146, inlinedAt: !217)
!221 = !DILocation(line: 86, column: 9, scope: !159)
!222 = !DILocation(line: 50, column: 5, scope: !108, inlinedAt: !206)
!223 = !DILocation(line: 50, column: 15, scope: !108, inlinedAt: !206)
!224 = !DILocation(line: 0, scope: !108, inlinedAt: !206)
!225 = !DILocation(line: 50, column: 9, scope: !108, inlinedAt: !206)
!226 = !DILocation(line: 54, column: 12, scope: !108, inlinedAt: !206)
!227 = !DILocation(line: 55, column: 9, scope: !120, inlinedAt: !206)
!228 = !DILocation(line: 55, column: 9, scope: !108, inlinedAt: !206)
!229 = !DILocation(line: 56, column: 15, scope: !119, inlinedAt: !206)
!230 = !DILocation(line: 57, column: 17, scope: !118, inlinedAt: !206)
!231 = !DILocation(line: 57, column: 13, scope: !119, inlinedAt: !206)
!232 = !DILocation(line: 58, column: 13, scope: !117, inlinedAt: !206)
!233 = !DILocation(line: 59, column: 13, scope: !117, inlinedAt: !206)
!234 = !DILocation(line: 62, column: 9, scope: !126, inlinedAt: !206)
!235 = !DILocation(line: 65, column: 1, scope: !108, inlinedAt: !206)
!236 = !DILocation(line: 91, column: 22, scope: !197)
!237 = !{!238, !212, i64 96}
!238 = !{!"pt_regs", !212, i64 0, !212, i64 8, !212, i64 16, !212, i64 24, !212, i64 32, !212, i64 40, !212, i64 48, !212, i64 56, !212, i64 64, !212, i64 72, !212, i64 80, !212, i64 88, !212, i64 96, !212, i64 104, !212, i64 112, !212, i64 120, !212, i64 128, !212, i64 136, !212, i64 144, !212, i64 152, !212, i64 160}
!239 = !DILocation(line: 91, column: 20, scope: !197)
!240 = !DILocation(line: 92, column: 22, scope: !197)
!241 = !DILocation(line: 92, column: 20, scope: !197)
!242 = !DILocation(line: 94, column: 14, scope: !196)
!243 = !DILocation(line: 94, column: 13, scope: !197)
!244 = !DILocation(line: 95, column: 13, scope: !194)
!245 = !DILocation(line: 95, column: 13, scope: !195)
!246 = !DILocation(line: 96, column: 9, scope: !195)
!247 = !DILocation(line: 98, column: 13, scope: !200)
!248 = !DILocation(line: 98, column: 13, scope: !201)
!249 = !DILocation(line: 99, column: 13, scope: !201)
!250 = !DILocation(line: 100, column: 34, scope: !201)
!251 = !DILocation(line: 100, column: 54, scope: !201)
!252 = !DILocation(line: 100, column: 13, scope: !201)
!253 = !DILocation(line: 112, column: 1, scope: !159)
!254 = distinct !DISubprogram(name: "probe_kfree", scope: !3, file: !3, line: 115, type: !160, scopeLine: 116, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !255)
!255 = !{!256, !257, !258, !261}
!256 = !DILocalVariable(name: "ctx", arg: 1, scope: !254, file: !3, line: 115, type: !162)
!257 = !DILocalVariable(name: "alloc_addr", scope: !254, file: !3, line: 117, type: !6)
!258 = !DILocalVariable(name: "alloc_size", scope: !254, file: !3, line: 118, type: !259)
!259 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !260, size: 64)
!260 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!261 = !DILocalVariable(name: "____fmt", scope: !262, file: !3, line: 121, type: !265)
!262 = distinct !DILexicalBlock(scope: !263, file: !3, line: 121, column: 3)
!263 = distinct !DILexicalBlock(scope: !264, file: !3, line: 120, column: 18)
!264 = distinct !DILexicalBlock(scope: !254, file: !3, line: 120, column: 6)
!265 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 280, elements: !266)
!266 = !{!267}
!267 = !DISubrange(count: 35)
!268 = !DILocation(line: 0, scope: !254)
!269 = !DILocation(line: 117, column: 2, scope: !254)
!270 = !DILocation(line: 117, column: 29, scope: !254)
!271 = !{!238, !212, i64 112}
!272 = !DILocation(line: 117, column: 16, scope: !254)
!273 = !DILocation(line: 118, column: 21, scope: !254)
!274 = !DILocation(line: 120, column: 6, scope: !264)
!275 = !DILocation(line: 120, column: 6, scope: !254)
!276 = !DILocation(line: 121, column: 3, scope: !262)
!277 = !DILocation(line: 121, column: 3, scope: !263)
!278 = !DILocation(line: 125, column: 3, scope: !263)
!279 = !DILocation(line: 137, column: 24, scope: !263)
!280 = !DILocation(line: 137, column: 3, scope: !263)
!281 = !DILocation(line: 138, column: 3, scope: !263)
!282 = !DILocation(line: 142, column: 1, scope: !254)
