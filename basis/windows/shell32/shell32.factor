! Copyright (C) 2006, 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.strings alien.syntax
classes.struct combinators io.encodings.utf16n io.files
io.pathnames kernel windows.errors windows.com
windows.com.syntax windows.types windows.user32
windows.ole32 windows specialized-arrays ;
SPECIALIZED-ARRAY: ushort
IN: windows.shell32

CONSTANT: CSIDL_DESKTOP HEX: 00
CONSTANT: CSIDL_INTERNET HEX: 01
CONSTANT: CSIDL_PROGRAMS HEX: 02
CONSTANT: CSIDL_CONTROLS HEX: 03
CONSTANT: CSIDL_PRINTERS HEX: 04
CONSTANT: CSIDL_PERSONAL HEX: 05
CONSTANT: CSIDL_FAVORITES HEX: 06
CONSTANT: CSIDL_STARTUP HEX: 07
CONSTANT: CSIDL_RECENT HEX: 08
CONSTANT: CSIDL_SENDTO HEX: 09
CONSTANT: CSIDL_BITBUCKET HEX: 0a
CONSTANT: CSIDL_STARTMENU HEX: 0b
CONSTANT: CSIDL_MYDOCUMENTS HEX: 0c
CONSTANT: CSIDL_MYMUSIC HEX: 0d
CONSTANT: CSIDL_MYVIDEO HEX: 0e
CONSTANT: CSIDL_DESKTOPDIRECTORY HEX: 10
CONSTANT: CSIDL_DRIVES HEX: 11
CONSTANT: CSIDL_NETWORK HEX: 12
CONSTANT: CSIDL_NETHOOD HEX: 13
CONSTANT: CSIDL_FONTS HEX: 14
CONSTANT: CSIDL_TEMPLATES HEX: 15
CONSTANT: CSIDL_COMMON_STARTMENU HEX: 16
CONSTANT: CSIDL_COMMON_PROGRAMS HEX: 17
CONSTANT: CSIDL_COMMON_STARTUP HEX: 18
CONSTANT: CSIDL_COMMON_DESKTOPDIRECTORY HEX: 19
CONSTANT: CSIDL_APPDATA HEX: 1a
CONSTANT: CSIDL_PRINTHOOD HEX: 1b
CONSTANT: CSIDL_LOCAL_APPDATA HEX: 1c
CONSTANT: CSIDL_ALTSTARTUP HEX: 1d
CONSTANT: CSIDL_COMMON_ALTSTARTUP HEX: 1e
CONSTANT: CSIDL_COMMON_FAVORITES HEX: 1f
CONSTANT: CSIDL_INTERNET_CACHE HEX: 20
CONSTANT: CSIDL_COOKIES HEX: 21
CONSTANT: CSIDL_HISTORY HEX: 22
CONSTANT: CSIDL_COMMON_APPDATA HEX: 23
CONSTANT: CSIDL_WINDOWS HEX: 24
CONSTANT: CSIDL_SYSTEM HEX: 25
CONSTANT: CSIDL_PROGRAM_FILES HEX: 26
CONSTANT: CSIDL_MYPICTURES HEX: 27
CONSTANT: CSIDL_PROFILE HEX: 28
CONSTANT: CSIDL_SYSTEMX86 HEX: 29
CONSTANT: CSIDL_PROGRAM_FILESX86 HEX: 2a
CONSTANT: CSIDL_PROGRAM_FILES_COMMON HEX: 2b
CONSTANT: CSIDL_PROGRAM_FILES_COMMONX86 HEX: 2c
CONSTANT: CSIDL_COMMON_TEMPLATES HEX: 2d
CONSTANT: CSIDL_COMMON_DOCUMENTS HEX: 2e
CONSTANT: CSIDL_COMMON_ADMINTOOLS HEX: 2f
CONSTANT: CSIDL_ADMINTOOLS HEX: 30
CONSTANT: CSIDL_CONNECTIONS HEX: 31
CONSTANT: CSIDL_COMMON_MUSIC HEX: 35
CONSTANT: CSIDL_COMMON_PICTURES HEX: 36
CONSTANT: CSIDL_COMMON_VIDEO HEX: 37
CONSTANT: CSIDL_RESOURCES HEX: 38
CONSTANT: CSIDL_RESOURCES_LOCALIZED HEX: 39
CONSTANT: CSIDL_COMMON_OEM_LINKS HEX: 3a
CONSTANT: CSIDL_CDBURN_AREA HEX: 3b
CONSTANT: CSIDL_COMPUTERSNEARME HEX: 3d
CONSTANT: CSIDL_PROFILES HEX: 3e
CONSTANT: CSIDL_FOLDER_MASK HEX: ff
CONSTANT: CSIDL_FLAG_PER_USER_INIT HEX: 800
CONSTANT: CSIDL_FLAG_NO_ALIAS HEX: 1000
CONSTANT: CSIDL_FLAG_DONT_VERIFY HEX: 4000
CONSTANT: CSIDL_FLAG_CREATE HEX: 8000
CONSTANT: CSIDL_FLAG_MASK HEX: ff00


CONSTANT: ERROR_FILE_NOT_FOUND 2

CONSTANT: SHGFP_TYPE_CURRENT 0
CONSTANT: SHGFP_TYPE_DEFAULT 1

LIBRARY: shell32

FUNCTION: HRESULT SHGetFolderPathW ( HWND hwndOwner, int nFolder, HANDLE hToken, DWORD dwReserved, LPTSTR pszPath ) ;
ALIAS: SHGetFolderPath SHGetFolderPathW

FUNCTION: HINSTANCE ShellExecuteW ( HWND hwnd, LPCTSTR lpOperation, LPCTSTR lpFile, LPCTSTR lpParameters, LPCTSTR lpDirectory, INT nShowCmd ) ;
ALIAS: ShellExecute ShellExecuteW

: open-in-explorer ( dir -- )
    [ f "open" ] dip absolute-path f f SW_SHOWNORMAL ShellExecute drop ;

: shell32-directory ( n -- str )
    f swap f SHGFP_TYPE_DEFAULT
    MAX_UNICODE_PATH <ushort-array>
    [ SHGetFolderPath drop ] keep utf16n alien>string ;

: desktop ( -- str )
    CSIDL_DESKTOPDIRECTORY shell32-directory ;

: my-documents ( -- str )
    CSIDL_PERSONAL shell32-directory ;

: application-data ( -- str )
    CSIDL_APPDATA shell32-directory ;

: windows-directory ( -- str )
    CSIDL_WINDOWS shell32-directory ;

: programs ( -- str )
    CSIDL_PROGRAMS shell32-directory ;

: program-files ( -- str )
    CSIDL_PROGRAM_FILES shell32-directory ;

: program-files-x86 ( -- str )
    CSIDL_PROGRAM_FILESX86 shell32-directory ;

: program-files-common ( -- str )
    CSIDL_PROGRAM_FILES_COMMON shell32-directory ;

: program-files-common-x86 ( -- str )
    CSIDL_PROGRAM_FILES_COMMONX86 shell32-directory ;

CONSTANT: SHCONTF_FOLDERS 32
CONSTANT: SHCONTF_NONFOLDERS 64
CONSTANT: SHCONTF_INCLUDEHIDDEN 128
CONSTANT: SHCONTF_INIT_ON_FIRST_NEXT 256
CONSTANT: SHCONTF_NETPRINTERSRCH 512
CONSTANT: SHCONTF_SHAREABLE 1024
CONSTANT: SHCONTF_STORAGE 2048

TYPEDEF: DWORD SHCONTF

CONSTANT: SHGDN_NORMAL 0
CONSTANT: SHGDN_INFOLDER 1
CONSTANT: SHGDN_FOREDITING HEX: 1000
CONSTANT: SHGDN_INCLUDE_NONFILESYS HEX: 2000
CONSTANT: SHGDN_FORADDRESSBAR HEX: 4000
CONSTANT: SHGDN_FORPARSING HEX: 8000

TYPEDEF: DWORD SHGDNF

ALIAS: SFGAO_CANCOPY           DROPEFFECT_COPY
ALIAS: SFGAO_CANMOVE           DROPEFFECT_MOVE
ALIAS: SFGAO_CANLINK           DROPEFFECT_LINK
CONSTANT: SFGAO_CANRENAME         HEX: 00000010
CONSTANT: SFGAO_CANDELETE         HEX: 00000020
CONSTANT: SFGAO_HASPROPSHEET      HEX: 00000040
CONSTANT: SFGAO_DROPTARGET        HEX: 00000100
CONSTANT: SFGAO_CAPABILITYMASK    HEX: 00000177
CONSTANT: SFGAO_LINK              HEX: 00010000
CONSTANT: SFGAO_SHARE             HEX: 00020000
CONSTANT: SFGAO_READONLY          HEX: 00040000
CONSTANT: SFGAO_GHOSTED           HEX: 00080000
CONSTANT: SFGAO_HIDDEN            HEX: 00080000
CONSTANT: SFGAO_DISPLAYATTRMASK   HEX: 000F0000
CONSTANT: SFGAO_FILESYSANCESTOR   HEX: 10000000
CONSTANT: SFGAO_FOLDER            HEX: 20000000
CONSTANT: SFGAO_FILESYSTEM        HEX: 40000000
CONSTANT: SFGAO_HASSUBFOLDER      HEX: 80000000
CONSTANT: SFGAO_CONTENTSMASK      HEX: 80000000
CONSTANT: SFGAO_VALIDATE          HEX: 01000000
CONSTANT: SFGAO_REMOVABLE         HEX: 02000000
CONSTANT: SFGAO_COMPRESSED        HEX: 04000000
CONSTANT: SFGAO_BROWSABLE         HEX: 08000000
CONSTANT: SFGAO_NONENUMERATED     HEX: 00100000
CONSTANT: SFGAO_NEWCONTENT        HEX: 00200000

TYPEDEF: ULONG SFGAOF

STRUCT: DROPFILES
    { pFiles DWORD }
    { pt POINT }
    { fNC BOOL }
    { fWide BOOL } ;
TYPEDEF: DROPFILES* LPDROPFILES
TYPEDEF: DROPFILES* LPCDROPFILES
TYPEDEF: HANDLE HDROP

STRUCT: SHITEMID
    { cb USHORT }
    { abID BYTE[1] } ;
TYPEDEF: SHITEMID* LPSHITEMID
TYPEDEF: SHITEMID* LPCSHITEMID

STRUCT: ITEMIDLIST
    { mkid SHITEMID } ;
TYPEDEF: ITEMIDLIST* LPITEMIDLIST
TYPEDEF: ITEMIDLIST* LPCITEMIDLIST
TYPEDEF: ITEMIDLIST ITEMID_CHILD
TYPEDEF: ITEMID_CHILD* PITEMID_CHILD
TYPEDEF: ITEMID_CHILD* PCUITEMID_CHILD

CONSTANT: STRRET_WSTR 0
CONSTANT: STRRET_OFFSET 1
CONSTANT: STRRET_CSTR 2

UNION-STRUCT: STRRET-union
    { pOleStr LPWSTR }
    { uOffset UINT }
    { cStr char[260] } ;
STRUCT: STRRET
    { uType int }
    { value STRRET-union } ;

COM-INTERFACE: IEnumIDList IUnknown {000214F2-0000-0000-C000-000000000046}
    HRESULT Next ( ULONG celt, LPITEMIDLIST* rgelt, ULONG* pceltFetched )
    HRESULT Skip ( ULONG celt )
    HRESULT Reset ( )
    HRESULT Clone ( IEnumIDList** ppenum ) ;

COM-INTERFACE: IShellFolder IUnknown {000214E6-0000-0000-C000-000000000046}
    HRESULT ParseDisplayName ( HWND hwndOwner, void* pbcReserved, LPOLESTR lpszDisplayName, ULONG* pchEaten, LPITEMIDLIST* ppidl, ULONG* pdwAttributes )
    HRESULT EnumObjects ( HWND hwndOwner, SHCONTF grfFlags, IEnumIDList** ppenumIDList )
    HRESULT BindToObject ( LPCITEMIDLIST pidl, void* pbcReserved, REFGUID riid, void** ppvOut )
    HRESULT BindToStorage ( LPCITEMIDLIST pidl, void* pbcReserved, REFGUID riid, void** ppvObj )
    HRESULT CompareIDs ( LPARAM lParam, LPCITEMIDLIST pidl1, LPCITEMIDLIST pidl2 )
    HRESULT CreateViewObject ( HWND hwndOwner, REFGUID riid, void** ppvOut )
    HRESULT GetAttributesOf ( UINT cidl, LPCITEMIDLIST* apidl, SFGAOF* rgfInOut )
    HRESULT GetUIObjectOf ( HWND hwndOwner, UINT cidl, LPCITEMIDLIST* apidl, REFGUID riid, UINT* prgfInOut, void** ppvOut )
    HRESULT GetDisplayNameOf ( LPCITEMIDLIST pidl, SHGDNF uFlags, STRRET* lpName )
    HRESULT SetNameOf ( HWND hwnd, LPCITEMIDLIST pidl, LPCOLESTR lpszName, SHGDNF uFlags, LPITEMIDLIST* ppidlOut ) ;

FUNCTION: HRESULT SHGetDesktopFolder ( IShellFolder** ppshf ) ;

FUNCTION: UINT DragQueryFileW ( HDROP hDrop, UINT iFile, LPWSTR lpszFile, UINT cch ) ;
ALIAS: DragQueryFile DragQueryFileW
