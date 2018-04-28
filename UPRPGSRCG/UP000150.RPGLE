      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas UP X-check GP/GZSMENUPD, GPMTXTPD, T_GRMENUL')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000150 - Cross check the Menu Item Unqiue Codes in         *
      *             GPMENUPD, GZSFMENUPD, GPMTXTPD and T_GRMENUL.     *
      *             UP008020P1 will list any discrepancies.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256038  *CREATE    Date 21Mar05               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  256038 - This program will cross check the menu item unique  *
      *           codes in the menu files (GPMTXTPD, GZSFMENUPD,      *
      *           GPMENUPD and T_GRMENUL).  The check of the unique   *
      *           codes from T_GRMENUL to other menu files will not be*
      *           done in this program because it is included in      *
      *           program UP1729.  Program UPC1729 will call UP1729   *
      *           and this program to give a complete cross check     *
      *           of these 4 menu files and generate a report.        *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain - record not found
      *
     FGPMTXTL0  IF   E           K DISK    INFSR(*PSSR)
      *  RTV:  Global Menu Item Text by Unique Code
      *
     FGZSFMENUL0IF   E           K DISK    INFSR(*PSSR) PREFIX(Z_)
      *  RTV:  Menu Master Data by Unique Code
      *
     FGPMENUL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SFMENUD0:GPMENUD0) PREFIX(G_)
      *  RTV:  Global Menu Master Data by Unique Code
      *
     FGPGMULL4  IF   E           K DISK    INFSR(*PSSR)
      *  RTV:  Menu link items by Menu Codes which are not at null values.
      *
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Arrays containing Section id and Section Descriptions
     DA_SectId         S             10    DIM(9) CTDATA PERRCD(1) ASCEND
     DA_SectTxt        S             90    DIM(9) ALT(A_SectId)
      *
      ** Array containing report heading information
     DA_SectPref       S              2    DIM(2) CTDATA PERRCD(1) ASCEND
     DA_SectInfo       S              9    DIM(2) ALT(A_SectPref)
      *
      ** Array containing column lines of each section
     DA_ColLines       S            100    DIM(6) CTDATA PERRCD(1)
      *
      * Entry for array A_SectInfo
     D                 DS
     DSectInfoEntry            1      9
     D  SInfo_SHSPos           1      3  0                                      Details start positi
     D  SInfo_ColSLin          4      6  0                                      start entry for sect
     D  SInfo_ColELin          7      9  0                                      End entry for sect
      *
      * Data structure for Section Headers file
     D                 DS
     DSectHeader               1    116
     D  SHID                   1     10
     D  SPref                  1      2
     D  SHSEQ                 11     13  0
     D  SHDSPos               14     16  0
     D  SHHdr                 17    116
      *
      * Data structure for Error Messages file
     D                 DS
     DErrorMsg                 1    197
     D  SEID                   1     10
     D  SEKFLD                11     97
     D  SEMDTL                98    197
      *
      * Data structure for link details to be output to Error Messages file
     D                 DS
     DOpMTxtDtl                1     89
     D  OpMTxtSCode            1     20
     D  OpMTxtDesc            25     69
     D  OpMTxtDel             78     89
      *
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D SectPrefix      S              2                                         Section Prefix
     D A_Idx           S              3  0                                      A_SectId n A_SectTxt
                                                                                index
     D Ix              S              2  0                                      A_SectPref index
     D CIdx            S              2  0                                      A_ColLines index
     D TtlSectEntry    S              3  0 INZ(9)                               = DIM of A_SectId
     D TtlSPrefEntry   S              3  0 INZ(2)                               =DIM of A_SectPref
      *
     D PrevMenuCode    S                   LIKE(MLMenuCode)                     Prev. Menu code
      *
      *****************************************************************
      * Main processing
      *****************************************************************
      *
      * Output section headers to file UPSHDRPD.
     C                   EXSR      OpSectHdrs
      *
      * X-check unique codes from GPMTXTPD against GPMENUPD, GZSFMENUPD and T_GRMENUL:
     C                   EXSR      XChkMTXT
      *
      * X-check unique codes from GPMENUPD against GPMTXTPD, GZSFMENUPD and T_GRMENUL:
     C                   EXSR      XChkGPMENU
      *
      * X-check unique codes from GZSFMENUPD against GPMTXTPD, GPMENUPD and T_GRMENUL:
     C                   EXSR      XChkGZSFMENU
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallToWrtMsg  - Call program UP008020 to write message to     *
      *                 UPSERRPD.                                     *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - None                                            *
      *                                                               *
      *****************************************************************
     C     CallToWrtMsg  BEGSR
      *
     C                   CALL      'UP008020'
     C                   PARM      '*WRTDTL'     Mode              7
     C                   PARM      ErrorMsg      PassDtl         197
      *
     C     CallToWrtMsgE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpMTxtMsg  - Output GPMTXTPD warning message.                 *
      *                                                               *
      * Called from - XChkMTXT                                        *
      *                                                               *
      * Call        - CallToWrtMsg                                    *
      *                                                               *
      *****************************************************************
     C     OpMTxtMsg     BEGSR
      *
     C                   EVAL      SEKFLD   = MIINDX
      *
     C                   EVAL      OpMTxtSCode = MISNAM
     C                   EVAL      OpMTxtDesc  = MIINAR
     C                   EVAL      OpMTxtDel   = MIDEL
      *
     C                   EVAL      SEMDTL   = OpMTxtDtl
     C                   EXSR      CallToWrtMsg
      *
     C     OpMTxtMsgE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * XChkMTXT - X-check menu items from GPMTXTPD against GPMENUPD, *
      *            GZSFMENUPD and T_GRMENUL.                          *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - OpMTxtMsg                                       *
      *                                                               *
      *****************************************************************
     C     XChkMTXT      BEGSR
      *
     C     *LOVAL        SETLL     GPMTXTL0
      *
     C                   READ      GPMTXTL0                               20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * Skip the logically deleted record.
     C                   IF        MIDEL     = 'Y'
     C                   GOTO      ReadNMTXTL0
     C                   ENDIF                                                  FI MIDEL = 'Y'
      *
      * If unique code starting with *G, it should exist in GPMENUPD.
     C                   IF        %SUBST(MIINDX:1:2) = '*G'
     C     MIINDX        CHAIN     GPMENUL0                           30        record not found
      *
      * If no record is found, output line (MT01NOGMNU)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'MT01NOGMNU'
     C                   EXSR      OpMTxtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C                   ELSE
      * Else it should exist in GZSFMENUPD.
     C     MIINDX        CHAIN     GZSFMENUl0                         30        record not found
      *
      * If no record is found, output line (MT02NOZMNU)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'MT02NOZMNU'
     C                   EXSR      OpMTxtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C                   ENDIF                                                  FI %SUBST(MIINDX:1:2
      *                                                                            = '*G'
      *
      * The unique code should exist in T_GREMNUL.
     C     MIINDX        CHAIN     GPGMULL4                           30        record not found
      *
      * If no record is found, output line (MT03NOGMUL)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'MT03NOGMUL'
     C                   EXSR      OpMTxtMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C     ReadNMTXTL0   Tag
     C                   READ      GPMTXTL0                               20    EOF
     C                   ENDDO
      *
      *
     C     XChkMTXTE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpGPMenuMsg   - Output GPMENUPD warning message.              *
      *                                                               *
      * Called from - XChkGPMENU                                      *
      *                                                               *
      * Call        - CallToWrtMsg                                    *
      *                                                               *
      *****************************************************************
     C     OpGPMenuMsg   BEGSR
      *
     C                   EVAL      SEKFLD   = G_MIINDX
     C                   EVAL      %SUBST(SEKFLD:15) = G_MIZONE
      *
     C                   EVAL      SEMDTL   = G_MIPATH
      *
     C                   EXSR      CallToWrtMsg
      *
     C     OpGPMenuMsgE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * XChkGPMENU - X-check menu items from GPMENUPD against GPMTXTPD*
      *              GZSFMENUPD and T_GRMENUL.                        *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - OpGPMenuMsg                                     *
      *                                                               *
      *****************************************************************
     C     XChkGPMENU    BEGSR
      *
     C     *LOVAL        SETLL     GPMENUL0
      *
     C                   READ      GPMENUL0                               20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * The unique code should exist in GPMTXTPD with MIDEL <> 'Y'.
     C     G_MIINDX      CHAIN     GPMTXTL0                           30        record not found
      *
      * If no record is found, output line (MU01NOMTXT)
     C                   IF        *IN30    = *ON  OR
     C                             (*IN30   = *OFF AND
     C                              MIDEL   = 'Y')
     C                   EVAL      SEID     = 'MU01NOMTXT'
     C                   EXSR      OpGPMenuMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * The unique code should not exist in GZSFMENUPD.
     C     G_MIINDX      CHAIN     GZSFMENUL0                         30        record not found
      *
      * If record is found, output line (MU02INZMNU)
     C                   IF        *IN30    = *OFF
     C                   EVAL      SEID     = 'MU02INZMNU'
     C                   EXSR      OpGPMenuMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * The unique code should exist in T_GREMNUL.
     C     G_MIINDX      CHAIN     GPGMULL4                           30        record not found
      *
      * If no record is found, output line (MU03NOGMUL)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'MU03NOGMUL'
     C                   EXSR      OpGPMenuMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C                   READ      GPMENUL0                               20    EOF
      *
     C                   ENDDO
      *
     C     XChkGPMENUE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpGZMenuMsg   - Output GZSFMENUPD warning message.            *
      *                                                               *
      * Called from - XChkGZSFMENU                                    *
      *                                                               *
      * Call        - CallToWrtMsg                                    *
      *                                                               *
      *****************************************************************
     C     OpGZMenuMsg   BEGSR
      *
     C                   EVAL      SEKFLD   = Z_MIINDX
     C                   EVAL      %SUBST(SEKFLD:15) = Z_MIZONE
      *
     C                   EVAL      SEMDTL   = Z_MIPATH
      *
     C                   EXSR      CallToWrtMsg
      *
     C     OpGZMenuMsgE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * XChkGZSFMENU - X-check menu items from GZSFMENUPD against     *
      *                GPMTXTPD, GPMENUPD and T_GRMENUL.              *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - OpGZMenuMsg                                     *
      *                                                               *
      *****************************************************************
     C     XChkGZSFMENU  BEGSR
      *
     C     *LOVAL        SETLL     GZSFMENUL0
      *
     C                   READ      GZSFMENUL0                             20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * The unique code should exist in GPMTXTPD with MIDEL <> 'Y'.
     C     Z_MIINDX      CHAIN     GPMTXTL0                           30        record not found
      *
      * If no record is found, output line (MU04NOMTXT)
     C                   IF        *IN30    = *ON  OR
     C                             (*IN30   = *OFF AND
     C                              MIDEL   = 'Y')
     C                   EVAL      SEID     = 'MU04NOMTXT'
     C                   EXSR      OpGZMenuMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * The unique code should not exist in GPMENUPD.
     C     Z_MIINDX      CHAIN     GPMENUL0                           30        record not found
      *
      * If record is found, output line (MU05INGMNU)
     C                   IF        *IN30    = *OFF
     C                   EVAL      SEID     = 'MU05INGMNU'
     C                   EXSR      OpGZMenuMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * The unique code should exist in T_GREMNUL.
     C     Z_MIINDX      CHAIN     GPGMULL4                           30        record not found
      *
      * If no record is found, output line (MU06NOGMUL)
     C                   IF        *IN30    = *ON
     C                   EVAL      SEID     = 'MU06NOGMUL'
     C                   EXSR      OpGZMenuMsg
     C                   ENDIF                                                  FI *IN30 = *ON
      *
     C                   READ      GZSFMENUL0                             20    EOF
      *
     C                   ENDDO
      *
     C     XChkGZSFMENUE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * CallToWrtSect - Call program UP008020 to write section header.*
      *                                                               *
      * Called from - OpSectHdrs                                      *
      *                                                               *
      * Call        - None                                            *
      *                                                               *
      *****************************************************************
     C     CallToWrtSect BEGSR
      *
     C                   CALL      'UP008020'
     C                   PARM      '*WRTHDR'     Mode              7
     C                   PARM      SectHeader    PassDtl         197
      *
     C     CallToWrtSectEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * OpSectHdrs - Output secition header records to file UPSHDRPD. *
      *                                                               *
      * Called from - Main processing                                 *
      *                                                               *
      * Call        - CallToWrtSect                                   *
      *                                                               *
      *****************************************************************
     C     OpSectHdrs    BEGSR
      *
      * Output section text lines:
      * =========================
      *
      * Initialise variables.
     C                   EVAL      A_Idx = 1                                    A_SectId index
     C                   EVAL      SHSEQ = 0
     C                   EVAL      SHID  = *BLANK
      *
     C                   DOW       A_Idx <= TtlSectEntry
      *
      * If change of section prefix,
      *   get descriptions starting positions for the section type from Table TabSectInfo
     C                   IF        SPref <> %SUBST(A_SectId(A_Idx):1:2)
     C                   EVAL      SectPrefix  = %SUBST(A_SectId(A_Idx):1:2)
     C                   EVAL      Ix = 1                                       A_SectPref index
     C     SectPrefix    LOOKUP    A_SectPref(Ix)                         40
     C  N40              EXSR      *PSSR
      *
     C                   EVAL      SectInfoEntry = A_SectInfo(Ix)
     C                   EVAL      SHDSPOS = SInfo_SHSPos
     C                   ENDIF                                                  ENDIF diff. s prefix
      *
     C                   IF        SHID  <> A_SectId(A_Idx)
     C                   EVAL      SHID    = A_SectId(A_Idx)
     C                   EVAL      SHSEQ   = 1
     C                   ELSE
     C                   EVAL      SHSEQ   = SHSEQ + 1
     C                   ENDIF
      *
     C                   EVAL      SHHDR   = A_SectTxt(A_Idx)
      *
     C                   EXSR      CallToWrtSect
      *
     C                   EVAL      A_Idx = A_Idx + 1
     C                   ENDDO                                                  DOW A_Idx <=
      *                                                                             TtlSectEntry
      * Output column lines:
      * ===================                                                         TtlSectEntry
      *
     C                   EVAL      A_Idx = 1                                    A_SectInfo index
      *
     C                   DOW       A_Idx <= TtlSPrefEntry
      *
      * Get one section prefix information entry from A_SectInfo.
     C                   EVAL      SectInfoEntry = A_SectInfo(A_Idx)
      *
     C                   EVAL      SHID    = A_SectPref(A_Idx) + 'COL'
     C                   EVAL      SHDSPOS = SInfo_SHSPos
      *
     C                   EVAL      CIdx    = SInfo_ColSLin
     C                   EVAL      SHSEQ   = 0
      *
      * Write all column lines for the section prefix.
     C                   DOW       CIdx    <= SInfo_ColELin
      *
     C                   EVAL      SHSEQ   = SHSEQ + 1
     C                   EVAL      SHHDR   = A_ColLines(CIdx)
      *
     C                   EXSR      CallToWrtSect
      *
     C                   EVAL      CIdx    = Cidx  + 1
     C                   ENDDO                                                  WDO CIdx <=
      *                                                                             SInfo_ColELin
      * Increment index for next section info entry
     C                   EVAL      A_Idx    = A_Idx  + 1
     C                   ENDDO                                                  UDO A_Idx =
      *                                                                             TtlSPrefEntry
      *
     C     OpSectHdrsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  A_SectId, T_SectTxt
MT01NOGMNUWARNING: Menu Item Unique Codes in GPMTXTPD start with *G but not found in GPMENUPD:
MT02NOZMNUWARNING: Menu Item Unique Codes in GPMTXTPD not start with *G but not found in GZSFMENUPD:
MT03NOGMULWARNING: Menu Item Unique Codes in GPMTXTPD not found in T_GRMENUL:
MU01NOMTXTWARNING: Menu Item Unique Codes in GPMENUPD not found or logically deleted in GPMTXTPD:
MU02INZMNUMenu Item Unique Codes in GPMENUPD found in GZSFMENUPD:
MU03NOGMULWARNING: Menu Item Unique Codes in GPMENUPD not found in T_GRMENUL:
MU04NOMTXTWARNING: Menu Item Unique Codes in GZSFMENUPD not found or logically deleted in GPMTXTPD:
MU05INGMNUMenu Item Unique Codes in GZSFMENUPD found in GPMENUPD:
MU06NOGMULWARNING: Menu Item Inique Codes in GZSFMENUPD not found in T_GRMENUL:
**  A_SectPref, A_SectInfo
MT016001003
MU029004006
**       A_ColLines
Menu Item      Menu Item               Description                                      Logically
Unqiue Code    Short Code                                                               Deleted?
-----------    --------------------    ---------------------------------------------    ---------
Menu Item     Zone          Path/Command Parameters
Unqiue Code
-----------   ---------     ------------------------------------------------------------------------
