     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Accrued Interest Adjustments Selection')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  DL0101 - DL Accrued Interest Adjustments Selection           *
      *                                                               *
      *  Function:  This program displays a list of unauthorised      *
      *             and authorised transactions.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR1016548          Date 15Oct12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7067            Date 13May05               *
      *                 BUG6696            Date 25Apr05               *
      *                 CDL026  *Create    Date 12NOV04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1016548 - Database error encountered during authorization  *
      *              (Child:AR1016553)                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      * BUG7067 - F9 fails on 'No Recs to Display' screen             *
      * BUG6696 - Format amount correctly                             *
      * CDL026 - Authorisation on Dealing Accrued Interest Adjustments*
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDL0101DF  CF   E             WORKSTN
     F                                     SFILE(DL0101S0:@@RRN)
      ** Midas SD Authorisation DL Adjustments Function Display
 
     FDLAIAUL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLAIAUD0:DLAIAUD2)
      ** Midas DL Accrued Interest Adjustments Authorisation (Upd)
 
     FDLAIAUL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Accrued Interest Adjustments Authorisation (Rtv)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                         BUG6696
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                             BUG6696
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                BUG6696
                                                                                         BUG6696
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                             BUG6696
      ** EXTERNAL DS FOR DL ICD DETAILS                                                  BUG6696
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
                                                                                         BUG6696
     D DSSDY         E DS                  EXTNAME(DSSDY)                                BUG6696
      ** First DS for Access Programs, long Data Structure                               BUG6696
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     DDEALKEY          DS
     DDKDLNO                   1      6
     DNKDLNO                   1      6  0
     DCUSTOMERKEY      DS
     DDKCNUM                   1      6
     D*NKCNUM**                1      6  0                                                    CSD027
     DNKCNUM                   1      6A                                                      CSD027
     DDEALDSP          DS
     DDDDLNO                   1      6
     DNDDLNO                   1      6  0
     DCUSTOMERDSP      DS
     DDDCNUM                   1      6
     D*NDCNUM**                1      6  0                                                    CSD027
     DNDCNUM                   1      6A                                                      CSD027
     DTIMEDSP          DS                                                       BUG6696
     DDDIPTM                   1      6                                         BUG6696
     DNDIPTM                   1      6  0                                      BUG6696
     DBJRDNBDSP        DS                                                       BUG6696
     DDDRDNB                   1      5                                         BUG6696
     DNDRDNB                   1      5  0                                      BUG6696
     DDEALNUMB         DS
     DDLNO                     1      6  0
     DCDLNO                    1      6
     DCUSTOMERNUMB     DS
     D*CNUM****                1      6  0                                                    CSD027
     DCNUM                     1      6A                                                      CSD027
     DCCNUM                    1      6
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D W0RSF           S              1
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WQB10X          S             10
     D WQG3N           S              3  0
     D WSkipRec        S              1
     D @RUN            S              1
     D CPY2@           S             80
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** If no records found, display no record screen and exit
 
     C     *LOVAL        SETLL     DLAIAUL0
     C                   READ      DLAIAUL0                               82
      *
     C                   IF        *IN82 = '1'
      *
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
      *
     C                   WRITE     DL0101C1
     C                   EXFMT     DL0101NR
                                                                                        BUG7067
     C     *IN03         CASEQ     '1'           SREnd                                  BUG7067
     C     *IN09         CASEQ     '1'           SRAdd                                  BUG7067
     C                   ENDCS                                                          BUG7067
                                                                                        BUG7067
     C                   ELSE
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
     C******             ENDIF                                                          BUG7067
 
     C                   EVAL      W0RSF = 'N'
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN05         CASEQ     '1'           SRReload
 
     C     *IN27         CASEQ     '1'           SRLoad
 
     C     *IN09         CASEQ     '1'           SRADD
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDIF                                                           BUG7067
                                                                                         BUG7067
     C                   ENDDO
 
      /EJECT
      *****************************************************************
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : QDCXLATE, SRLoad                                   *
      *****************************************************************
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     DL0101C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD             4 0
     C                   Z-ADD     0             NKIPTM            6 0          BUG6696
     C                   Z-ADD     0             NKRDNB            5 0          BUG6696
 
      ** Position file
     C     KAUTH1        KLIST
     C                   KFLD                    NKDLNO
     C                   KFLD                    NKCNUM
     C                   KFLD                    NKIPTM                         BUG6696
     C                   KFLD                    NKRDNB                         BUG6696
      ** Position file
     C     KAUTH2        KLIST
     C                   KFLD                    NDDLNO
     C                   KFLD                    NDCNUM
     C                   KFLD                    NDIPTM                         BUG6696
     C                   KFLD                    NDRDNB                         BUG6696
 
 
     C     KAUTH1        SETLL     DLAIAUL0
     C                   READ      DLAIAUL0
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    DKDLNO        WZDLNO
     C                   EVAL      WZDLNO = DKDLNO
     C     *LIKE         DEFINE    DKCNUM        WZCNUM
     C                   EVAL      WZCNUM = DKCNUM
 
      ** Translate search mask for text field
 
     C     *LIKE         DEFINE    DKDLNO        WQDLNO
 
     C                   CALL      'QDCXLATE'
     C                   PARM      6             WQA5N             5 0
     C                   PARM      DKDLNO        WQDLNO
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
     C     *LIKE         DEFINE    DKCNUM        WQCNUM
 
     C                   CALL      'QDCXLATE'
     C                   PARM      6             WQA5N
     C                   PARM      DKCNUM        WQCNUM
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      * Calls    : QCLSCAN                                            *
      *****************************************************************
     C     SRLoad        BEGSR
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        *IN27 and *IN82 = '0'
     C                   READP     DLAIAUL0                               60
     C                   READ      DLAIAUL0                               60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         @@RRN
     C                   Z-ADD     1             WRCTR             5 0
 
      ** Load next subfile page
 
     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             @@RRN
     C                   EVAL      *IN32 = '0'
 
     C                   IF        DKDLNO <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    CDLNO
     C                   PARM      6             WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQDLNO
     C                   PARM      6             WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DKCNUM <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCNUM
     C                   PARM      6             WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQCNUM
     C                   PARM      6             WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Load subfile fields
 
     C                   MOVE      *BLANK        DDOPTN
     C                   MOVEL     DLNO          DDDLNO
     C                   MOVEL     CNUM          DDCNUM
     C**********         MOVEL     MAAM          DDMAAM                         BUG6696
      *                                                                         BUG6696
      ** Format Amount                                                          BUG6696
     C                   CALLB     'AOCURRR0'                                   BUG6696
     C                   PARM      *BLANK        @RTCD             7            BUG6696
     C                   PARM      '*KEY   '     @OPTN             7            BUG6696
     C                   PARM                    CCY                            BUG6696
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG6696
      *                                                                         BUG6696
     C                   Z-ADD     MAAM          @@AMTW                         BUG6696
     C                   Z-ADD     A6NBDP        @@QECN                         BUG6696
     C                   EXSR      FMTAMT                                       BUG6696
     C                   MOVE      @@AMTD        DDMAAM                         BUG6696
                                                                                BUG6696
     C                   MOVEL     SIGN          DDSIGN
     C                   MOVEL     CCY           DDCCY
     C                   MOVEL     INIRS         DDINRS
     C     CHTP          IFEQ      'X'
     C                   MOVEL     'AUTHORISED  'DDSTAT
     C                   else
     C                   MOVEL     'UNAUTHORISED'DDSTAT
     C                   endif
 
     C                   MOVE      INPTM         DDIPTM                         BUG6696
     C                   MOVE      INPDAY        DDRDNB                         BUG6696
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
     C                   WRITE     DL0101S0
 
     C                   ELSE
     C                   SUB       1             @@RRN
     C                   ENDIF
 
      ** End of File
 
     C                   READ      DLAIAUL0                               82
     C                   ENDDO
 
     C                   Z-ADD     @@RRN         WLRCD
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess                            *
      * Calls    :                                                    *
      *****************************************************************
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W0RSF = 'Y'
 
     C                   IF        *IN05
     C                   MOVE      '0'           *IN32
     C                   MOVE      '0'           *IN94
      *
     C                   EVAL      DDOPTN = *Blanks
     C                   EVAL      DDDLNO= *Blanks
     C                   EVAL      DDCNUM = *Blanks
     C                   EVAL      DDMAAM = *Blanks
     C                   EVAL      DDSIGN = *Blanks
     C                   EVAL      DDCCY  = *Blanks
     C                   EVAL      DDINRS = *Blanks
     C                   EVAL      DDSTAT = *Blanks
     C                   EVAL      DDIPTM = *Zeros                              BUG6696
     C                   EVAL      DDRDNB = *Zeros                              BUG6696
      *
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
     C                   EVAL      W0RSF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    :                                                   *
      *****************************************************************
     C     SRDisplay     BEGSR
 
      ** PUTOVR unless conditioned fields change
 
     C                   EVAL      *IN86 = *ON
 
     C                   TIME                    DDTIME
     C                   WRITE     DL0101C1
     C                   WRITE     DL0101F0
     C                   EXFMT     DL0101C0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : SRReload, SRValid, SRSelection                     *
      *****************************************************************
     C     SRProcess     BEGSR
      *
 
      ** Change of position specified
 
     C                   IF        WZDLNO <> DKDLNO OR WZCNUM <> DKCNUM
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C     W0RSF         IFNE      'Y'
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   MOVE      '0'           *IN94
 
     C                   READC     DL0101S0                               99
     C     *IN99         DOWEQ     '0'
      *
      * Validate option code
     C                   EXSR      SRValid
      *
      ** If action code is valid process selection
      *
     C     *IN32         IFEQ      '0'
     C     DDOPTN        ANDNE     *BLANK
     C                   EXSR      SRSelection
     C                   ENDIF
      *
     C     *IN32         IFEQ      '0'
     C                   EVAL      DDOPTN = *Blanks
     C                   EVAL      W0RSF = 'Y'
     C                   ENDIF
      *
     C                   UPDATE    DL0101S0
     C                   READC     DL0101S0                               99
     C                   ENDDO
      *
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRValid - Validate Option code                                *
      *                                                               *
      * Called by: SRProcess                                          *
      * Calls    : SRZasnms                                           *
      *****************************************************************
     C     SRValid       BEGSR
 
     C                   MOVE      '0'           *IN32
      *
      ** Validate Action Code
     C                   If        DDOPTN <> 'D' AND DDOPTN <> 'X'
     C                             AND DDOPTN <> ' '
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9269'
     C                   EXSR      SRZasnms
     C                   Endif
 
 
      ** Check if record still exists
     C     KAUTH2        CHAIN     DLAIAUL2                           85
      *
      ** Send message 'Record no longer on file'
     C                   If        *IN85 = *ON
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0009'
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile        10
     C                   PARM                    PZMsgID          10
 
     C                   ELSE                                                              AR1016548
     C                   UNLOCK    DLAIAUL2                                                AR1016548
     C                   Endif
      *
      ** Validate Delete Action against status
     C                   If        DDOPTN = 'D' AND CHTP = 'X'
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9270'
     C                   EXSR      SRZasnms
     C                   Endif
      *
      ** Validate Authorise action against authorising user
     C                   If        DDOPTN = 'X' and CHTP = 'X'
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9271'
     C                   EXSR      SRZasnms
     C                   Endif
      *
      ** Validate Authorising User against Input User
     C                   If        DDOPTN = 'X' and PsUser = INPUSR
     C                             AND CHTP <> 'X'
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9272'
     C                   EXSR      SRZasnms
     C                   Endif
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   ENDIF
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ACSSEM
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSelection - Process Selected transaction                    *
      *                                                               *
      * Called by: SRProcess                                          *
      * Calls    : Authorisation Programs, SREnd, SRZasnms            *
      *****************************************************************
     C     SRSelection   BEGSR
 
      ** Process all modified subfile records
      ** Pass the Key and Action code to the Authorisation programs
 
     C                   SELECT
 
     C                   WHEN      DDOPTN = 'D'
     C                   EXSR      SRDelete
 
     C                   WHEN      DDOPTN = 'X'
     C                   Z-ADD     NDDLNO        PPDLNO            6 0
     C**********         Z-ADD     NDCNUM        PPCNUM            6 0                        CSD027
     C                   MOVE      NDCNUM        PPCNUM            6                          CSD027
     C                   Z-ADD     NDIPTM        PPIPTM            6 0          BUG6696
     C                   Z-ADD     NDRDNB        PPRDNB            5 0          BUG6696
     C                   UNLOCK    DLAIAUL2
     C                   CALL      'DL0100'
     C                   PARM      DDOPTN        PPOPTN            1
     C                   PARM                    PPDLNO
     C                   PARM                    PPCNUM
     C                   PARM                    PPIPTM                         BUG6696
     C                   PARM                    PPRDNB                         BUG6696
     C                   PARM                    @INKC             1
 
     C                   ENDSL
 
      ** Exit if F3 requested
     C                   If        @INKC = '1'
     C                   EXSR      SREnd
     C                   Endif
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *****************************************************************
      * SRDelete - Delete Unauthorised Records                        *
      *                                                               *
      * Called by: SRSelection                                        *
      * Calls    :                                                    *
      *****************************************************************
     C     SRDelete      BEGSR
 
 
      ** Delete record
     C     KAUTH2        CHAIN     DLAIAUL2                           91
      *
     C                   IF        *IN91 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'DLAIAUL2'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     DDDLNO        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   DELETE    DLAIAUL2
      ** Request subfile reload
 
     C                   MOVE      '0'           *IN32
     C                   MOVE      '0'           *IN94
      *
     C                   EVAL      DDOPTN = *Blanks
     C                   EVAL      DDDLNO= *Blanks
     C                   EVAL      DDCNUM = *Blanks
     C                   EVAL      DDMAAM = *Blanks
     C                   EVAL      DDSIGN = *Blanks
     C                   EVAL      DDCCY  = *Blanks
     C                   EVAL      DDINRS = *Blanks
     C                   EVAL      DDSTAT = *Blanks
     C                   EVAL      DDIPTM = *Zeros                              BUG6696
     C                   EVAL      DDRDNB = *Zeros                              BUG6696
      *
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDOPTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9273'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDOPTN        ZACTN             1
     C                   PARM      BRC           ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9274'
     C                   EXSR      SRZasnms
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9273'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRADD - ADD Manual Adjustement                                *
      *                                                               *
      * Called by: Main routine, SRSelection                          *
      * Calls    :                                                    *
      *****************************************************************
     C     SRADD         BEGSR
     C                   MOVEL     'Y'           W0RSF
     C                   CALL      'DL0100'
     C                   PARM      *BLANK        PPOPTN
     C                   PARM      *ZEROS        PPDLNO
     C**********         PARM      *ZEROS        PPCNUM                                       CSD027
     C                   PARM      *BLANKS       PPCNUM                                       CSD027
     C                   PARM      *ZEROS        PPIPTM                         BUG6696
     C                   PARM      *ZEROS        PPRDNB                         BUG6696
     C                   PARM      *BLANK        @INKC
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine, SRSelection                          *
      * Calls    :                                                    *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      * Calls    : ZA0340                                             *
      *****************************************************************
     C     SRZasnms      BEGSR
 
     C                   IF        PZMsgFile = *BLANKS
     C                   EVAL      PZMsgFile = 'DRSMM'
     C                   ENDIF
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile        10
     C                   PARM                    PZMsgID          10
 
     C                   EVAL      PZMsgFile = *BLANKS
 
     C                   ENDSR
      *****************************************************************         BUG6696
      /EJECT                                                                    BUG6696
      *****************************************************************         BUG6696
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *         BUG6696
      *****************************************************************         BUG6696
     C     FMTAMT        BEGSR                                                  BUG6696
      *                                                                         BUG6696
     C                   CALLB     'ZA0920'                                     BUG6696
     C                   PARM      *BLANK        @@RETC           10            BUG6696
     C                   PARM                    @@AMTW           13 0          BUG6696
     C                   PARM                    @@QECN            1 0          BUG6696
     C                   PARM                    BNDCSP            1            BUG6696
     C                   PARM      *BLANK        @@AMTD           14            BUG6696
      *                                                                         BUG6696
     C                   ENDSR                                                  BUG6696
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
 
      ** Initialize program name
 
     C                   MOVEL     'DL0101'      DBPGM
 
      ** Move workstation ID to screen field
 
     C                   EVAL      ##PGMQ = PSProcName
     C                   EVAL      DDUSR  = PsUser
     C                   EVAL      DDWID  = PsJobName
 
      ** Initialise Subfile Control
 
     C                   MOVE      *BLANKS       DDCNUM
     C                   Z-ADD     13            WSFPG             3 0
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                         BUG6696
      ** Access DL ICD details                                                  BUG6696
      *                                                                         BUG6696
     C                   CALL      'AODEALR1'                                   BUG6696
     C                   PARM      *BLANKS       @RTCD             7            BUG6696
     C                   PARM      '*FIRST '     @OPTN             7            BUG6696
     C     SDDEAL        PARM      SDDEAL        DSSDY                          BUG6696
      *                                                                         BUG6696
      * Database error                                                          BUG6696
     C     @RTCD         IFNE      *BLANK                                       BUG6696
     C                   MOVEL     @OPTN         DBKEY                          BUG6696
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *************
     C                   END                                                    BUG6696
 
      **  GET ZMUSER to access default branch
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
