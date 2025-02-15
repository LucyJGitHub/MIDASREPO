     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Bank of England Extra Account Data Update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BYAMADW0UP - Window update module                            *
      *                                                               *
      *  Function:  This module updates the data to the required      *
      *             extension file.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD044880           Date 15Jan18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD027             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022             Date 24Jan05               *
      *                 LLN018  *CREATE    Date 17Apr01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  LLN018 - Upgrade BoE to APIs and addition of 2 new fields    *
      *           on ICD.
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. UPDAT   -   Update Processing                          *
      *     2. #EMOVO  -   Move screen fields back                    *
      *     3. *PSSR   -   Database Error Handling                    *
      *     4. END     -   Leave program                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN                *
      *       20      FIELDS TO BE PRETECTED DURING ENQUIRY           *
      *       28      REDISPLAY THE SCREEN                            *
      *       29      AT LEAST ONE FIELD ENTRY IN ERROR               *
      *---------------------------------------------------------------*
      *       89      CHAIN TO BYACCTY1 FAILED                        *
      *---------------------------------------------------------------*
      *****************************************************************
      ** Input Files
      *
     FBYACCTY1  UF A E           K DISK
     F                                     COMMIT
      ** BY Extension file (Update)
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** � Manually included D-specs            �
      ** � =========================            �
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      *
      ** Local data area for database error details
      *
      *** Datastructure to define input parameter DATA
      /COPY QWINDSRC,GLAMADDTA
 
      * Valid Bank of England Details layout
     D ValidBoE      E DS                  EXTNAME(GLVAMADX0)
 
      ** Bank of England details file
     D NWRCD         E DS                  EXTNAME(BYACCTY1)
 
      ** Bank of England Details File
     D SVRCD         E DS                  EXTNAME(BYACCTY1)
     D                                     PREFIX(SV)
 
 
      **   Declared variables
      **   ==================
      **
 
     D U#ACOD          S             10  0                                                    LLN022
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D TITLE           S              7
 
      ** Define *entry parameters
 
     D Idx             S              3P 0                                      Index error array
     D WIdx            S              3P 0                                      Index warning array
 
     D @RETURN         S              6
     D @TYPE           S              1
 
      *****************************************************************
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      **   Parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    @RTCD
     C                   PARM                    WFIND
     C                   PARM                    ValidBoE
     C                   PARM                    SVRCD
      *
     C     KLIST1        KLIST
     C                   KFLD                    U#BRCD            3
     C**********         KFLD                    U#CNUM            6 0                        CSD027
     C                   KFLD                    U#CNUM            6                          CSD027
     C                   KFLD                    U#CCY             3
     C**********         KFLD                    U#ACOD            4 0                        LLN022
     C                   KFLD                    U#ACOD                                       LLN022
     C                   KFLD                    U#ACSQ            2 0
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
 
     C                   EXSR      UPDAT
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATE THE EXTENSION FILE
      *****************************************************************
      *                                                               *
      *  SR/UPDAT                                                     *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     UPDAT         BEGSR
      *
      *
     C                   MOVEL     LVBRCD        U#BRCD
     C**********         MOVEL     LVCNUM        U#CNUM                                       CSD027
     C                   MOVE      LVCNUM        U#CNUM                                       CSD027
     C                   MOVEL     LVCCY         U#CCY
     C                   MOVEL     LVACOD        U#ACOD
     C                   MOVEL     LVACSQ        U#ACSQ
 
      ** Access extended file
      *
     C     KLIST1        CHAIN     BYACCTY1                           8991
      *
      *  If interactive mode
      *
     C     @TYPE         IFEQ      '1'
      *
      ** If record locked, display screen again, with information message.
      *
     C     *IN91         IFEQ      *ON
     C                   MOVEL     '*RECLCK'     @RTCD
     C                   EXSR      END
     C                   ENDIF
      *
      ** In Amend Mode
      ** Check record exists before update
      *
     C     ACTN          IFEQ      'A'
      *
      ** If the record does not exist, or has been modified by another user
      *
     C     *IN89         IFEQ      *ON
     C     *IN89         OREQ      *OFF
     C     NWRCD         ANDNE     SVRCD
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   EXSR      END
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** IN INSERT MODE
      *
     C     ACTN          IFEQ      'I'
      *
      *
      ** If the record exists                                               r
      *
     C     *IN89         IFEQ      *OFF
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   EXSR      END
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Write, delete or Update extended file
      *
     C     ACTN          IFEQ      'D'
      **********                                                                            MD044880
      ***Delete*record                                                                      MD044880
      **********                                                                            MD044880
     C******IN89         IFEQ      *OFF                                                     MD044880
     C**********         DELETE    BYACCTY1                                                 MD044880
     C**********         ENDIF                                                              MD044880
      **********                                                                            MD044880
     C                   ELSE
      *
     C                   MOVEL     ValidBoE      NWRCD
      *
      ** Write or update extended record
      *
     C     *IN89         IFEQ      *OFF
     C                   EXSR      #EMOVO
     C                   UPDATE    BYACCTD0
     C                   ELSE
     C                   EXSR      #EMOVO
     C                   WRITE     BYACCTD0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MOVE FIELDS OUT OF SCREEN FIELDS
      *****************************************************************
      *                                                               *
      *  SR/#EMOVO                                                    *
      *                                                               *
      *  Called by: UPDAT                                             *
      *                                                               *
      *  Calls: -                                                     *
      *                                                               *
      *****************************************************************
      *
     C     #EMOVO        BEGSR
      *
     C     ACTN          IFEQ      'A'
     C     ACTN          OREQ      'I'
      *
     C                   MOVE      LVBRCD        LBRCD
     C                   MOVE      LVCNUM        LCNUM
     C                   MOVE      LVCCY         LCCY
     C                   MOVE      LVACOD        LACOD
     C                   MOVE      LVACSQ        LACSQ
     C                   MOVE      LVNETI        LNETI
     C                   MOVE      LVDPTP        LDPTP
     C                   MOVE      LVSNOD        LSNOD
     C                   MOVE      LVLNTP        LLNTP
     C                   MOVE      LVMDAT        LMDAT
     C                   MOVE      LVLLIM        LLLIM
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END   - End Program, no errors                               *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR                                                              **
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
