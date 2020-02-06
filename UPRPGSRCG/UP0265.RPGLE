     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *  OVRDBF FILE(FILEMULMBR) TOFILE(*LIBL/QAFDMBR)                *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Add logical file members to files')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0265 - Add logical file members back to file               *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK020             Date 28Jul04               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 CUP019             Date 06Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 19Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CUP015             Date 28Jun01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CUP008             Date 19Jul00               *
      *                 CUP007             Date 28Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP001  *CREATE    Date 23Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CPK020 - Move to global layer.                               *
      *  CUP019 - In some circumstances the LF does not exist in the  *
      *           'to' library and so the library field on FILEMULMBR *
      *           is blank.  Stop processing for this case.           *
      *  CPK015 - 4.01 packaging.  Improve error handling.            *
      *  CUP015 - Remove specific member or file handling.  This is   *
      *            replaced by a check in UPC0266.                    *
      *  CUP008 - Change error handling for re-startability.          *
      *  CUP007 - Handle new files that are created with members.     *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** File containing list on non-referenced fields
     FFILEMULMBRIF   E             DISK
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D BaseCmd         C                   'ADDLFM FILE('
 
     D MbrKWord        C                   'MBR('
 
     D DMKWord         C                   'DTAMBRS('
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CmdString       S           1160
     D CmdLen          S             15  5
 
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C     *ENTRY        PLIST                                                                CPK015
     C                   PARM                    Reply                                        CPK015
 
     C                   Z-ADD     1160          CmdLen
      ** Read first record;
     C                   READ      FILEMULMBR                             99
     C     *IN99         IFEQ      *ON                                          I01
     C                   GOTO      ENDPGM
     C                   ENDIF                                                  E01
 
     C                   DOU       *IN99 = *ON
 
     C                   RESET                   mbrstr
 
     C                   MOVEL     MBLIB         mblib1           10
     C                   MOVEL     MBFILE        mbfile1          10
     C                   MOVEL     MBNAME        mbname1          10
     C                   MOVEL     mblib1        mbrstr           35
     C     mbrstr        CAT       '/':0         mbrstr
     C     mbrstr        CAT       mbfile1:0     mbrstr
     C     mbrstr        CAT       ')':0         mbrstr
     C     mbrstr        CAT       MbrKWord:1    mbrstr
     C     mbrstr        CAT       mbname1:0     mbrstr
     C     mbrstr        CAT       ')':0         mbrstr
      * Set loop to the value of 'Files accessed'
     C                   Z-ADD     MBNSCM        loop              3 0
 
     C     1             DO        loop
      *  Concatenate DTAMBRS string
      *****-*but*not*if*OTC*as*this*will*always*be*part*of*creation                           CUP015
      *****-*or*CGCGRPL0,*L1,*L2* CGCPNDL0,*L4,*CGGCONL0,*L1,*L2,*CGPASCL0,*L1,*L2,*L3 CUP007 CUP015
      **********CGPDECL0,*L2,*L4,*CGPDEFL0,*TOOL                                       CUP007 CUP015
      *****-*or*TTRANL1*or*TTRANL2                                                     CUP007 CUP015
      *****-*or*files*DEPCASHL1,*DEPEVNTL1,*DEPPOSNL1,*DEPTRANL1*and*DEPTRANL3         CUP007 CUP015
      *****                                                                                   CUP015
     C*****MBNAME        IFNE      'OTC'                                                      CUP015
     C*****MBNAME        ANDNE     'CGCGRPL0'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGCGRPL1'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGCGRPL2'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGCONDL0'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGCONDL4'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGGCONL0'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGGCONL1'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGGCONL2'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPASCL0'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPASCL1'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPASCL2'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPASCL3'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPDECL0'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPDECL2'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPDECL4'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'CGPDEFL0'                                          CUP007 CUP015
     C*****MBNAME        ANDNE     'TOOL'                                              CUP007 CUP015
     C*****MBNAME        ANDNE     'TTRANL1'                                           CUP007 CUP015
     C*****MBNAME        ANDNE     'TTRANL2'                                           CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPCASHL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPEVNTL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPPOSNL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPTRANL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPTRANL3'                                         CUP007 CUP015
     C     '('           CAT       MBBOL:0       lfmstr           35
     C     lfmstr        CAT       '/':0         lfmstr
     C     lfmstr        CAT       MBBOF:0       lfmstr
     C     lfmstr        CAT       '(':1         lfmstr
     C     lfmstr        CAT       MBBOM:0       lfmstr
     C     lfmstr        CAT       '))':0        lfmstr
      * Build up entire string
     C     alllfmstr     CAT       lfmstr:1      alllfmstr      1120
     C                   RESET                   lfmstr
     C*****              ENDIF                                                                CUP015
 
     C                   READ      FILEMULMBR                             99
 
     C                   ENDDO
      **Build*command*string;*but*not*if*member*is*OTC                                        CUP015
      *****-*or*CGCGRPL0,*L1,*L2,*CGCPNDL0,*L4,*CGGCONL0,*L1,*L2,*CGPASCL0,*L1,*L2,*L3,CUP007 CUP015
      **********CGPDECL0,*L2,*L4,*CGPDEFL0,*TOOL                                       CUP007 CUP015
      *****-*or*TTRANL1*or*TTRANL2                                                     CUP007 CUP015
      *****-*or*files*DEPCASHL1,*DEPEVNTL1,*DEPPOSNL1,*DEPTRANL1*and*DEPTRANL3         CUP007 CUP015
     C*****mbname1       IFNE      'OTC'                                                      CUP015
     C*****mbname1       ANDNE     'CGCGRPL0'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGCGRPL1'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGCGRPL2'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGCONDL0'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGCONDL4'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGGCONL0'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGGCONL1'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGGCONL2'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPASCL0'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPASCL1'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPASCL2'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPASCL3'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPDECL0'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPDECL2'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPDECL4'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'CGPDEFL0'                                          CUP007 CUP015
     C*****mbname1       ANDNE     'TOOL'                                              CUP007 CUP015
     C*****mbname1       ANDNE     'TTRANL1'                                           CUP007 CUP015
     C*****mbname1       ANDNE     'TTRANL2'                                           CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPCASHL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPEVNTL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPPOSNL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPTRANL1'                                         CUP007 CUP015
     C*****MBFILE        ANDNE     'DEPTRANL3'                                         CUP007 CUP015
      * Build command string                                                                  CUP015
     C                   MOVEL     BaseCmd       CmdString
     C     CmdString     CAT       mbrstr:0      CmdString
     C     CmdString     CAT       DMKWord:1     CmdString
     C     CmdString     CAT       alllfmstr:0   CmdString
     C     CmdString     CAT       ')':0         CmdString
 
     C*****              CALL      'QCMDEXC'                                                  CUP008
     C*****              PARM                    CmdString                                    CUP008
     C*****              PARM                    CmdLen                                       CUP008
     C     mblib1        IFNE      *blanks                                                    CUP019
     C                   CALL      'UPC0266'                                                  CUP008
     C                   PARM                    CmdString                                    CUP008
     C                   PARM                    CmdLen                                       CUP008
     C                   PARM                    mblib1                                       CUP015
     C                   PARM                    mbfile1                                      CUP015
     C                   PARM                    mbname1                                      CUP015
     C                   PARM      *blanks       Reply             1                          CUP008
     C     Reply         IFEQ      'C'                                                        CUP008
     C                   GOTO      ENDPGM                                                     CUP008
     C                   ENDIF                                                                CUP008
     C                   ENDIF                                                                CUP008
      *                                                                                       CUP019
     C                   RESET                   CmdString
     C                   RESET                   alllfmstr
 
     C*****              ENDIF                                                                CUP015
     C                   ENDDO                                                  ED01
 
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
**CTDATA cpy@
(c) Finastra International Limited 2001
