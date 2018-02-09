     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Account Posting Task Split Copy Data')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0600T2 - Midas GL Account Posting Task Split Copy Data     *
      *                                                               *
      *  Function:  This program will copy a block of records from    *
      *             the old driver LF/ACCNT to a member in the        *
      *             new driver PF/GLACPOPD.                           *
      *                                                               *
      *  Called By: GLC0600T2                                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1097218          Date 05Apr13               *
      *                 CGL142             Date 06Aug12               *
      *                 CGL120  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1097218 - GLC0720 seq 10001 failed Out of Balance          *
      *  CGL142 - Tactical COB changes GL                             *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     F***ACCNT**   IF   E           K DISK    INFSR(*PSSR)                                    CGL142
     F**********                           IGNORE(ACCNTAAF)                                   CGL142
     F**********                           IGNORE(ACCNTACF)                                   CGL142
      *****************************************************************                       CGL142
     F***SACPO**   IF   F  620    24AIDISK    KEYLOC(2)                                       CGL142
     F**********                           INFSR(*PSSR)                                       CGL142
      *****************************************************************                       CGL142
     F***GLACPOPD  UF A E           K DISK    INFSR(*PSSR)                                    CGL142
     F**********                           RENAME(ACCNTABF:GLACPF)                            CGL142
     FGLACPOPD  O    E             DISK    INFSR(*PSSR)                                       CGL142
     F                                     RENAME(GLACPOF:DRIVEF)                             CGL142
     F                                     COMMIT
      *
     F***GLACPIPD  UF A E           K DISK    INFSR(*PSSR) PREFIX(I_)                         CGL142
     FGLACPIPD  UF A E           K DISK    INFSR(*PSSR)                                       CGL142
     F**********                           RENAME(ACCNTABF:GLACPFI)                           CGL142
     F                                     RENAME(GLACPIF:INDEXF)                             CGL142
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     50 - Indicator for dummy read of GLACPOPD                 *
      *     80 - READ indicator for GLACPIPD                          *
      ******81*-*READ*indicator*for*ACCNT******************************                       CGL142
      ******82*-*READ*indicator*for*SACPO******************************                       CGL142
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      *
     D*DSACCNT**     E DS                  EXTNAME(ACCNTAB)                                   CGL142
     D*DSACCNTSav    E DS                  EXTNAME(ACCNTAB) PREFIX(Sav_)                      CGL142
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Array containing Copyright statement
      *
     D*DSKEY****       DS                                                                     CGL142
     D***KCNUM**                           LIKE(CNUM)                                         CGL142
     D***KCCY***                           LIKE(CCY)                                          CGL142
     D***KACOD**                           LIKE(ACOD)                                         CGL142
     D***KACSQ**                           LIKE(ACSQ)                                         CGL142
     D***KBRCA**                           LIKE(BRCA)                                         CGL142
      *****************************************************************                       CGL142
     D***SCNUM**       S                   LIKE(CNUM)                                         CGL142
     D***SCCY***       S                   LIKE(CCY)                                          CGL142
     D***SACOD**       S                   LIKE(ACOD)                                         CGL142
     D***SACSQ**       S                   LIKE(ACSQ)                                         CGL142
     D***SBRCA**       S                   LIKE(BRCA)                                         CGL142
      *****************************************************************                       CGL142
     D***ACCNTK           DS                                                                  CGL142
      *****************************************************************                       CGL142
      ***ACCNT*Key*Fields**********************************************                       CGL142
      *****************************************************************                       CGL142
     D*A_CNUM***                           LIKE(CNUM)                                         CGL142
     D*A_CCY****                           LIKE(CCY)                                          CGL142
     D*A_ACOD***                           LIKE(ACOD)                                         CGL142
     D*A_ACSQ***                           LIKE(ACSQ)                                         CGL142
     D*A_BRCA***                           LIKE(BRCA)                                         CGL142
      *****************************************************************                       CGL142
     D***SACPOK*          DS                                                                  CGL142
      *****************************************************************                       CGL142
      ***SACPO*Key*Fields**********************************************                       CGL142
      *****************************************************************                       CGL142
     D*P_CNUM***                                                                              CGL142
     D*P_CCY****                                                                              CGL142
     D*P_ACOD***                                                                              CGL142
     D*P_ACSQ***                                                                              CGL142
     D*P_BRCA***                                                                              CGL142
     I***SACPO**   NS  05    1 CP                                                             CGL142
     I**********                        2    7  P_CNUM                                        CGL142
     I**********                        8   10  P_CCY                                         CGL142
     I**********                       15   16 0P_ACSQ                                        CGL142
     I**********                      103  105  P_BRCA                                        CGL142
     I**********                      590  599 0P_ACOD                                        CGL142
      *****************************************************************                       CGL142
      ***Rate*Change*Posting*******************************************                       CGL142
      *****************************************************************                       CGL142
     I**********NS  06    1 CR                                                                CGL142
     I**********                        2    7  P_CNUM                                        CGL142
     I**********                        8   10  P_CCY                                         CGL142
     I**********                       11   14 0ACODQQ                                        CGL142
     I**********                       15   16 0P_ACSQ                                        CGL142
     I**********                        2   10  WNOCC2                                        CGL142
     I**********                       15   16 0WSEQ2                                         CGL142
     I**********                      161  170 0P_ACOD                                        CGL142
     I**********                       23   32 0ACNOP                                         CGL142
     I**********                   P   33   35 0PSTD                                          CGL142
     I**********                   P   36   38 0VALD                                          CGL142
     I**********                   P  239  241 0RRNM                                          CGL142
     I**********                       81   81 0DRCR                                          CGL142
     I**********                       96  102  SPOS                                          CGL142
     I**********                      103  105  P_BRCA                                        CGL142
     I**********                      124  124  ATYPP                                         CGL142
     I**********                      128  128  PRIN                                          CGL142
     I**********                        1  250  LOTSA1                                        CGL142
     I**********                      251  331  LOTSA2                                        CGL142
     I**********                      332  351  ACKEY                                         CGL142
     I**********                      352  352  FEEFLG                                        CGL142
     I**********                   P  353  359 0FEEVAL                                        CGL142
     I**********                      360  364  FEEPCT                                        CGL142
     I**********                      365  384  RORACT                                        CGL142
     I**********                      385  386  RORCTY                                        CGL142
     I**********                      387  406  RORBNK                                        CGL142
     I**********                      407  417  RORCDE                                        CGL142
     I**********                      418  437  PORACT                                        CGL142
     I**********                      438  439  PORCTY                                        CGL142
     I**********                      440  459  PORBNK                                        CGL142
     I**********                      460  470  PORCDE                                        CGL142
     I**********                      471  505  DSTACT                                        CGL142
     I**********                      506  507  DSTCTY                                        CGL142
     I**********                      508  527  DSTBNK                                        CGL142
     I**********                   P  528  530 0SETDAT                                        CGL142
     I**********                      531  540  TICKER                                        CGL142
     I**********                      541  560  EXCHNG                                        CGL142
     I**********                      561  573 2NOMINL                                        CGL142
     I**********                      574  589  FDTRID                                        CGL142
     I**********NS  07                                                                        CGL142
 
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C**********         PARM                    RECTOT            7 0                        CGL142
     C                   PARM                    BLKSZE            7 0                        CGL142
     C                   PARM                    RECCNT           10 0                        CGL142
     C                   PARM                    RTCODE            3
      *
      ** Initial processing
      *
     C                   EXSR      INIT
      *
      ** Split records into new file
      *
     C                   EXSR      TSPLIT
      *
      ** End processing
      *
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/TSPLIT - Split records into new driver and index files.    *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     TSPLIT        BEGSR
      *
     C**********         Z-ADD     1             TOT               7 0                     AR1097218
      *
      ** Check the Index file and set the file pointer to the next
      ** driver record to be copied accordingly.
      *
     C**********         READ      GLACPFI                                80                  CGL142
     C                   READ      INDEXF                                 80                  CGL142
      *
     C     *IN80         IFEQ      '1'
     C******LOVAL        SETLL     ACCNTABF                                                   CGL142
     C******LOVAL        SETLL     SACPO                                                      CGL142
                                                                                              CGL142
      ** Index record not found: Set FROM and TO RRNs                                         CGL142
                                                                                              CGL142
     C                   Z-ADD     1             GLFRRN                                       CGL142
     C                   Z-ADD     BLKSZE        GLTRRN                                       CGL142
     C     GLTRRN        IFGE      RECCNT                                                     CGL142
     C                   Z-ADD     9999999999    GLTRRN                                       CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
      ** Write index record                                                                   CGL142
                                                                                              CGL142
     C                   WRITE     INDEXF                                                     CGL142
                                                                                              CGL142
     C                   ELSE
     C**********         MOVE      I_CNUM        KCNUM                                        CGL142
     C**********         MOVE      I_CCY         KCCY                                         CGL142
     C**********         Z-ADD     I_ACOD        KACOD                                        CGL142
     C**********         Z-ADD     I_ACSQ        KACSQ                                        CGL142
     C**********         MOVE      I_BRCA        KBRCA                                        CGL142
     C**********         MOVE      I_CNUM        P_CNUM                                       CGL142
     C**********         MOVE      I_CCY         P_CCY                                        CGL142
     C**********         Z-ADD     I_ACOD        P_ACOD                                       CGL142
     C**********         Z-ADD     I_ACSQ        P_ACSQ                                       CGL142
     C**********         MOVE      I_BRCA        P_BRCA                                       CGL142
     C*****KEY           SETGT     ACCNTABF                           81                      CGL142
     C*****SACPOK        SETGT     SACPO                              82                      CGL142
                                                                                              CGL142
      ** Index record found: Set FROM and TO RRNs                                             CGL142
                                                                                              CGL142
     C     BLKSZE        ADD       GLFRRN        GLFRRN                                       CGL142
     C     BLKSZE        ADD       GLFRRN        GLTRRN                                       CGL142
     C     GLTRRN        SUB       1             GLTRRN                                       CGL142
     C     GLTRRN        IFGE      RECCNT                                                     CGL142
     C                   Z-ADD     9999999999    GLTRRN                                       CGL142
     C                   ENDIF                                                                CGL142
     C                   UPDATE    INDEXF                                                     CGL142
     C                                                                                        CGL142
     C                   ENDIF
      *****************************************************************                       CGL142
      ***Copy*records*to*the*new*driver*file*until*the*limit***********                       CGL142
      ***specified*in*the*input*parameter*(RECTOT)*is*reached.*********                       CGL142
      *****************************************************************                       CGL142
     C**********         READ      ACCNT                                  81                  CGL142
     C**********         READ      SACPO                                  82                  CGL142
      **********                                                                              CGL142
     C******IN81         IFNE      *ON                                                        CGL142
     C**********         EVAL      A_CNUM = CNUM                                              CGL142
     C**********         EVAL      A_CCY  = CCY                                               CGL142
     C**********         EVAL      A_ACOD = ACOD                                              CGL142
     C**********         EVAL      A_ACSQ = ACSQ                                              CGL142
     C**********         EVAL      A_BRCA = BRCA                                              CGL142
     C**********         ENDIF                                                                CGL142
      *****************************************************************                       CGL142
     C******IN81         DOWNE     '1'                                                        CGL142
     C******IN82         ORNE      '1'                                                        CGL142
      *****************************************************************                       CGL142
      ***Process*when*record*found*on*both*ACCNT*and*SACPO*files*******                       CGL142
      *****************************************************************                       CGL142
     C**********         SELECT                                                               CGL142
     C**********         WHEN      (ACCNTK = SACPOK)                                          CGL142
      *****************************************************************                       CGL142
      ***Keep*going*after*record*limit*if*still*same*combination*of*key                       CGL142
      *****************************************************************                       CGL142
     C*****BRCA*         IFNE      SBRCA                                                      CGL142
     C*****CCY**         ORNE      SCCY                                                       CGL142
     C*****ACOD*         ORNE      SACOD                                                      CGL142
     C*****ACSQ*         ORNE      SACSQ                                                      CGL142
     C*****CNUM*         ORNE      SCNUM                                                      CGL142
     C*****TOT**         IFGT      RECTOT                                                     CGL142
     C**********         LEAVE                                                                CGL142
     C**********         ENDIF                                                                CGL142
     C**********         ENDIF                                                                CGL142
      *****************************************************************                       CGL142
     C**********         WRITE     GLACPF                                                     CGL142
     C**********         ADD       1             TOT                                          CGL142
      *****************************************************************                       CGL142
     C**********         MOVE      CNUM          SCNUM                                        CGL142
     C**********         MOVE      CCY           SCCY                                         CGL142
     C**********         Z-ADD     ACOD          SACOD                                        CGL142
     C**********         Z-ADD     ACSQ          SACSQ                                        CGL142
     C**********         MOVE      BRCA          SBRCA                                        CGL142
      *****************************************************************                       CGL142
     C**********         READ      ACCNT                                  81                  CGL142
      *****************************************************************                       CGL142
     C******IN81         IFNE      *ON                                                        CGL142
     C**********         EVAL      A_CNUM = CNUM                                              CGL142
     C**********         EVAL      A_CCY  = CCY                                               CGL142
     C**********         EVAL      A_ACOD = ACOD                                              CGL142
     C**********         EVAL      A_ACSQ = ACSQ                                              CGL142
     C**********         EVAL      A_BRCA = BRCA                                              CGL142
     C**********         ENDIF                                                                CGL142
      *****************************************************************                       CGL142
     C**********         MOVE      CNUM          KCNUM                                        CGL142
     C**********         MOVE      CCY           KCCY                                         CGL142
     C**********         Z-ADD     ACOD          KACOD                                        CGL142
     C**********         Z-ADD     ACSQ          KACSQ                                        CGL142
     C**********         MOVE      BRCA          KBRCA                                        CGL142
     C**********         MOVE      SCNUM         P_CNUM                                       CGL142
     C**********         MOVE      SCCY          P_CCY                                        CGL142
     C**********         Z-ADD     SACOD         P_ACOD                                       CGL142
     C**********         Z-ADD     SACSQ         P_ACSQ                                       CGL142
     C**********         MOVE      SBRCA         P_BRCA                                       CGL142
     C*****SACPOK        SETGT     SACPO                                                      CGL142
     C**********         READ      SACPO                                  82                  CGL142
      *****************************************************************                       CGL142
      ***Process*when*record*found*on*ACCNT*file*only******************                       CGL142
      *****************************************************************                       CGL142
     C**********         WHEN      ((ACCNTK < SACPOK and *IN81 <> *ON)  or                    CGL142
     C**********                    (*IN82 = *ON))                                            CGL142
      *****************************************************************                       CGL142
      ***Keep*going*after*record*limit*if*still*same*combination*of*key                       CGL142
      *****************************************************************                       CGL142
     C*****BRCA*         IFNE      SBRCA                                                      CGL142
     C*****CCY**         ORNE      SCCY                                                       CGL142
     C*****ACOD*         ORNE      SACOD                                                      CGL142
     C*****ACSQ*         ORNE      SACSQ                                                      CGL142
     C*****CNUM*         ORNE      SCNUM                                                      CGL142
     C*****TOT**         IFGT      RECTOT                                                     CGL142
     C**********         LEAVE                                                                CGL142
     C**********         ENDIF                                                                CGL142
     C**********         ENDIF                                                                CGL142
      *****************************************************************                       CGL142
     C**********         WRITE     GLACPF                                                     CGL142
     C**********         ADD       1             TOT                                          CGL142
      *****************************************************************                       CGL142
     C**********         MOVE      CNUM          SCNUM                                        CGL142
     C**********         MOVE      CCY           SCCY                                         CGL142
     C**********         Z-ADD     ACOD          SACOD                                        CGL142
     C**********         Z-ADD     ACSQ          SACSQ                                        CGL142
     C**********         MOVE      BRCA          SBRCA                                        CGL142
      *****************************************************************                       CGL142
     C**********         READ      ACCNT                                  81                  CGL142
      *****************************************************************                       CGL142
     C******IN81         IFNE      *ON                                                        CGL142
     C**********         EVAL      A_CNUM = CNUM                                              CGL142
     C**********         EVAL      A_CCY  = CCY                                               CGL142
     C**********         EVAL      A_ACOD = ACOD                                              CGL142
     C**********         EVAL      A_ACSQ = ACSQ                                              CGL142
     C**********         EVAL      A_BRCA = BRCA                                              CGL142
     C**********         ENDIF                                                                CGL142
      *****************************************************************                       CGL142
      ***Process*when*record*found*on*SACPO*file*only******************                       CGL142
      *****************************************************************                       CGL142
     C**********         WHEN      ((ACCNTK > SACPOK and *IN82 <> *ON)  or                    CGL142
     C**********                    (*IN81 = *ON))                                            CGL142
      *****************************************************************                       CGL142
     C**********         EVAL      DSACCNTSav = DSACCNT                                       CGL142
     C**********         CLEAR                   GLACPF                                       CGL142
     C**********         EVAL      RECI = 'X'                                                 CGL142
     C**********         EVAL      CNUM = P_CNUM                                              CGL142
     C**********         EVAL      CCY  = P_CCY                                               CGL142
     C**********         EVAL      ACOD = P_ACOD                                              CGL142
     C**********         EVAL      ACSQ = P_ACSQ                                              CGL142
     C**********         EVAL      BRCA = P_BRCA                                              CGL142
     C**********         EVAL      LDBL = *ZERO                                               CGL142
     C**********         EVAL      CLBL = *ZERO                                               CGL142
      *****************************************************************                       CGL142
     C**********         WRITE     GLACPF                                                     CGL142
     C**********         ADD       1             TOT                                          CGL142
      *****************************************************************                       CGL142
     C**********         EVAL      DSACCNT = DSACCNTSav                                       CGL142
      *****************************************************************                       CGL142
     C**********         MOVE      P_CNUM        SCNUM                                        CGL142
     C**********         MOVE      P_CCY         SCCY                                         CGL142
     C**********         Z-ADD     P_ACOD        SACOD                                        CGL142
     C**********         Z-ADD     P_ACSQ        SACSQ                                        CGL142
     C**********         MOVE      P_BRCA        SBRCA                                        CGL142
      *****************************************************************                       CGL142
     C**********         MOVE      P_CNUM        KCNUM                                        CGL142
     C**********         MOVE      P_CCY         KCCY                                         CGL142
     C**********         Z-ADD     P_ACOD        KACOD                                        CGL142
     C**********         Z-ADD     P_ACSQ        KACSQ                                        CGL142
     C**********         MOVE      P_BRCA        KBRCA                                        CGL142
     C*****SACPOK        SETGT     SACPO                                                      CGL142
     C**********         READ      SACPO                                  82                  CGL142
     C**********         ENDSL                                                                CGL142
      *****************************************************************                       CGL142
     C**********         ENDDO                                                                CGL142
      *****************************************************************                       CGL142
      ***If*Index*file*is*empty*write*new*record*to*it,*else*update****                       CGL142
      ***with*details*of*last*record*written.**************************                       CGL142
      *****************************************************************                       CGL142
     C**********         MOVE      SCNUM         I_CNUM                                       CGL142
     C**********         MOVE      SCCY          I_CCY                                        CGL142
     C**********         Z-ADD     SACOD         I_ACOD                                       CGL142
     C**********         Z-ADD     SACSQ         I_ACSQ                                       CGL142
     C**********         MOVE      SBRCA         I_BRCA                                       CGL142
      *****************************************************************                       CGL142
     C******IN80         IFEQ      '1'                                                        CGL142
     C**********         WRITE     GLACPFI                                                    CGL142
     C**********         ELSE                                                                 CGL142
     C**********         UPDATE    GLACPFI                                                    CGL142
     C**********         ENDIF                                                                CGL142
      *
      ** Create the Driver record                                                             CGL142
      *                                                                                       CGL142
     C                   Z-ADD     GLFRRN        GLFERN                                       CGL142
     C                   Z-ADD     GLTRRN        GLTERN                                       CGL142
     C                   WRITE     DRIVEF                                                     CGL142
                                                                                              CGL142
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/END - Exit program and return to calling program.          *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     END           BEGSR
      *
      ***If*end*of*file*on*ACCNT*set*return*code*to*notify*server******                       CGL142
      ** If total eq RECCNT found on file: EOF                                                CGL142
      *
     C******IN81         IFEQ      '1'                                                        CGL142
     C     GLTRRN        IFGE      RECCNT                                                     CGL142
     C*****TOT**         IFEQ      0                                                       AR1097218
     C**********         MOVE      'NRF'         RTCODE                                    AR1097218
     C**********         ELSE                                                              AR1097218
     C                   MOVE      'EOF'         RTCODE
     C**********         ENDIF                                                             AR1097218
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/INIT - Initial processing.                                 *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     INIT          BEGSR
      *****************************************************************                       CGL142
      ***KLIST*for*setting*file*pointer*to*next*record*to*be*copied****                       CGL142
      *****************************************************************                       CGL142
     C*****KEY           KLIST                                                                CGL142
     C**********         KFLD                    KCNUM                                        CGL142
     C**********         KFLD                    KCCY                                         CGL142
     C**********         KFLD                    KACOD                                        CGL142
     C**********         KFLD                    KACSQ                                        CGL142
     C**********         KFLD                    KBRCA                                        CGL142
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *****************************************************************                       CGL142
      ***Dummy*READ*to*GLACPOPD*for*compilation*purpose****************                       CGL142
      *****************************************************************                       CGL142
     C******IN50         IFEQ      '1'                                                        CGL142
     C**********         READ      GLACPOPD                               50                  CGL142
     C**********         ENDIF                                                                CGL142
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ROLBK
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
