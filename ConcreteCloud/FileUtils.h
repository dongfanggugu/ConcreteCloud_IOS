//
//  FileUtils.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/23.
//
//

#ifndef FileUtils_h
#define FileUtils_h


#endif /* FileUtils_h */

@interface FileUtils : NSObject

/**
 *  将数据写入到指定目录的文件中
 *
 */
+ (BOOL)writeFile:(NSData *)data Path:(NSString *)dirPath fileName:(NSString *)fileName;


/**
 *  返回文件是否存在
 *
 */
+ (BOOL)existInPath:(NSString *)dirPath name:(NSString *)fileName;

/**
 *  返回文件路径是否存在
 *
 */
+ (BOOL)existInFilePath:(NSString *)filePath;


/**
 *  从url字符串中解析文件名称
 *

 */
+ (NSString *)getFileNameFromUrlString:(NSString *)urlString;


/**
 *  将同一个目录下的文件重命名

 */
+ (BOOL)renameFileNameInPath:(NSString *)dirPath oldName:(NSString *)oldName toNewName:(NSString *)newName;


+ (BOOL)copyFilesFrom:(NSString *)sourcePath to:(NSString *)destinationPath fileName:(NSString *)name;

@end
