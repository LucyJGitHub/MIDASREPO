     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Aggregated Facility Hist. Report - Prompt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000056P - Aggregated Facility History Report - Prompt      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG5998            Date 08Mar05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG5998 - LEC000056 failed due to pointer or parameter error *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Aggregated Facility History Report - Prompt Display
     FLE000056DFCF   E             WORKSTN INFSR(*PSSR)
 
      ** Midas LE Aggregate Facility File
     FLEAGFCL3  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Aggregate Facilities Detail B Record
     FLEAGFYL2  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure used by access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D PPARM           DS           100
     D   ParmCUST              1      6
     D   ParmFACT              7      9
     D   ParmFCNO             10     11
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSEQ            S              5
     D PLEV            S              1
     D PENT            S              3
     D PACT            S              1
     D PCMD            S              1
 
     D PZMsgFile       S             10
     D PZMsgID         S             10
     D PRTCD           S              7
     D POPTN           S              7
 
     D WkFCLT          S             11
     D*WkCUST***       S              6S 0                                                    CSD027
     D WkCUST          S              6A                                                      CSD027
     D WkFACT          S              3S 0
     D WkFCNO          S              2S 0
 
     D WPass           S              3
     D WError          S              1
     D WRUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Display detail screen
 
     C                   EXSR      SRDisplay
     C                   EVAL      WkFCLT = DDCUST + DDFACT + DDFCNO
 
      ** Validate fields
 
     C                   IF        *INKL = *OFF
     C                   EVAL      WError = 'N'
     C                   EXSR      SRValidate
 
     C                   IF        WError = 'N'
     C                   IF        WPass = '1ST'
     C                   EVAL      *IN50 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      WPass = '2ND'
     C                   EVAL      PZMsgID = 'LEF0431'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   IF        WkFCLT <> *BLANKS                                         BUG5998
     C                   EVAL      ParmCUST = DDCUST
     C                   EVAL      ParmFACT = DDFACT
     C                   EVAL      ParmFCNO = DDFCNO
     C                   ELSE                                                                BUG5998
     C                   EVAL      ParmCUST = *ZEROS                                         BUG5998
     C                   EVAL      ParmFACT = *ZEROS                                         BUG5998
     C                   EVAL      ParmFCNO = *ZEROS                                         BUG5998
     C                   ENDIF                                                               BUG5998
     C                   EXSR      SREnd
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Screen                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   WRITE     LE000056C0
     C                   TIME                    DDTIME
     C                   WRITE     LE000056F0
     C                   EXFMT     LE000056D0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Reset error indicators
 
     C                   EVAL      *IN25 = *OFF
 
     C                   IF        *INKC = *ON
     C                   EVAL      PCMD = 'E'
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   IF        *INKL = *ON
     C                   IF        WPass = '1ST'
     C                   EVAL      PCMD = 'F'
     C                   EXSR      SREnd
     C                   ELSE
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      WPass = '1ST'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate Details                                *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** Validate Aggregate Facility
 
     C                   EXSR      SRVFCLT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFCLT - Validate Aggregate Facility                        *
      *                                                               *
      *****************************************************************
 
     C     SRVFCLT       BEGSR
 
     C                   IF        WkFCLT <> *BLANKS
 
     C     KFCLTY        KLIST
     C                   KFLD                    WkCUST
     C                   KFLD                    WkFACT
     C                   KFLD                    WkFCNO
 
     C                   MOVE      DDCUST        WkCUST
     C                   MOVE      DDFACT        WkFACT
     C                   MOVE      DDFCNO        WkFCNO
 
     C     KFCLTY        CHAIN     LEAGFCL3                           75
 
     C                   IF        *IN75 = *ON
 
     C     KFCLTY        CHAIN     LEAGFYL2                           76
 
     C                   IF        *IN76 = *ON
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'LEF0432'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN75 = *OFF or *IN76 = *OFF
     C                   MOVE      CNUM          DDCUST
     C                   MOVE      FACT          DDFACT
     C                   MOVE      FCNO          DDFCNO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Terminate Program                                    *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZasnms - Message Handling Subroutine                       *
      *                                                               *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    PLEV
     C                   PARM                    PENT
     C                   PARM                    PPARM
     C                   PARM                    PACT
     C                   PARM                    PCMD
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Define message file
 
     C                   EVAL      PZMsgFile = 'GBLERMSGF'
     C                   EVAL      DBPGM = 'LE000056P'
     C                   EVAL      WPass = '1ST'
 
     C                   EVAL      DDPGMQ = PSProcName
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      DDUSER = PSUser
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
