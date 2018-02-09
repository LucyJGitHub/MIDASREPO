     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Standing data authorisation function')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDAUTHFNC - Standing Data Authorisation Function             *
      *                                                               *
      *  Function:  This program displays a list of unauthorised      *
      *             transactions for processing.                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CSD028             Date 22Aug05               *
      *                 BUG6979            Date 03May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5340            Date 05Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD015             Date 03Mar03               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD028 - KYC (Standing Data Authorisations)                  *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5340 - Validate TI account details.                       *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDAUTHFDF CF   E             WORKSTN
     F                                     SFILE(SDAUTHS0:@@RRN)
      ** Midas SD Authorisation Function Display
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
      ** Midas SD Authorisation Log - by Key
 
     FSDAULGL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Function
 
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
      ** Midas SD Compliance Watch Hit List                                                   CSD015
                                                                                              CSD015
     FSDAULGL5  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
     F                                     RENAME(SDAULGD0:SDAULGD2)                          CSD028
      ** Midas SD Authorisation Log - by Function, Key and Status                             CSD028
                                                                                              CSD028
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
      ** Data Structure for SAR Details                                                       CSD015
                                                                                              CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
     D  WMode        E                     EXTFLD(MODE)                                       CSD015
      ** SD data area                                                                         CSD015
                                                                                              CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
      ** 24X7 status data area                                                                CSD015
                                                                                              CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** Data Structure for Watch List Checking Details                                       CSD015
                                                                                              CSD015
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
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
 
      ** Declared variables for enhancement CSD015                                            CSD015
                                                                                              CSD015
     D WFuncType       S              8A                                                      CSD015
     D WIdentifier     S             40A                                                      CSD015
     D PFncCd          S              8A                                                      CSD015
     D PSard           S              6A                                                      CSD015
     D CSC011          S              1A   INZ('N')                                           CSD015
     D CSD015          S              1A   INZ('N')                                           CSD015
                                                                                              CSD015
      ** Declared variables for enhancement CSD028                                            CSD028
      *                                                                                       CSD028
     D PTransType      S              4                                                       CSD028
     D*PCustNum*       S              6  0                                            CSD028 CSD027A
     D PCustNum        S              6A                                                     CSD027A
     D PCustNumC       S              6                                                       CSD028
     D CSD028          S              1A   INZ('N')                                           CSD028
     D P@Rtcd          S                   LIKE(@RTCD)                                        CSD028
     D P@Optn          S                   LIKE(@OPTN)                                        CSD028
                                                                                              CSD028
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
                                                                                           BUG6979
      **  GET ZMUSER to access default branch                                              BUG6979
                                                                                           BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                    BUG6979
     C                   IN        ZMUSER                                                  BUG6979
     C                   UNLOCK    ZMUSER                                                  BUG6979
 
     C                   DO        *HIVAL
 
      ** If no records found, display no record screen and exit
 
     C                   IF        CSD028 = 'N'                                               CSD028
     C     *LOVAL        SETLL     SDAULGL2
     C                   READ      SDAULGL2                               82
     c                   ELSE                                                                 CSD028
     C     *LOVAL        SETLL     SDAULGL5                                                   CSD028
     C                   READ      SDAULGL5                               82                  CSD028
     C                   ENDIF                                                                CSD028
      *
     C                   IF        *IN82 = '1'
      *
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
      *
     C                   WRITE     SDAUTHC1
     C                   EXFMT     SDAUTHNR
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      W0RSF = 'N'
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN05         CASEQ     '1'           SRReload
 
     C     *IN27         CASEQ     '1'           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
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
     C                   WRITE     SDAUTHC0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD             4 0
 
      ** Position file
     C     KAUTH1        KLIST
     C                   KFLD                    DDFNSL
     C                   KFLD                    DDKYSL
                                                                                              CSD028
     C     KAUTH2        KLIST                                                                CSD028
     C                   KFLD                    DDFNSL                                       CSD028
     C                   KFLD                    DDKYSL                                       CSD028
     C                   KFLD                    DDSTSL                                       CSD028
 
     C                   IF        CSD028 = 'N'                                               CSD028
     C     KAUTH1        SETLL     SDAULGL2
     C                   READ      SDAULGL2
     C                   ELSE                                                                 CSD028
     C     KAUTH2        SETLL     SDAULGL5                                                   CSD028
     C                   READ      SDAULGL5                                                   CSD028
     C                   ENDIF                                                                CSD028
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    DDKYSL        WZKYSL
     C                   EVAL      WZKYSL = DDKYSL
     C     *LIKE         DEFINE    DDFNSL        WZFNSL
     C                   EVAL      WZFNSL = DDFNSL
     C     *LIKE         DEFINE    DDSTSL        WZSTSL                                       CSD028
     C                   EVAL      WZSTSL = DDSTSL                                            CSD028
 
      ** Translate search mask for text field
 
     C     *LIKE         DEFINE    DDKYSL        WQKYSL
 
     C                   CALL      'QDCXLATE'
     C                   PARM      20            WQA5N             5 0
     C                   PARM      DDKYSL        WQKYSL
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
     C     *LIKE         DEFINE    DDFNSL        WQFNSL
 
     C                   CALL      'QDCXLATE'
     C                   PARM      21            WQA5N
     C                   PARM      DDFNSL        WQFNSL
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
 
     C                   IF        CSD028 = 'Y'                                               CSD028
     C     *LIKE         DEFINE    DDSTSL        WQSTSL                                       CSD028
                                                                                              CSD028
     C                   CALL      'QDCXLATE'                                                 CSD028
     C                   PARM      1             WQA5N                                        CSD028
     C                   PARM      DDSTSL        WQSTSL                                       CSD028
     C                   PARM      'QSYSTRNTBL'  WQB10X                                       CSD028
     C                   PARM      'QSYS'        WQC10X                                       CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
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
     C                   IF        CSD028 = 'N'                                               CSD028
     C                   READP     SDAULGL2                               60
     C                   READ      SDAULGL2                               60
     C                   ELSE                                                                 CSD028
     C                   READP     SDAULGL5                               60                  CSD028
     C                   READ      SDAULGL5                               60                  CSD028
     C                   ENDIF                                                                CSD028
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
 
      ** Protect fields during Enquiry Mode
 
     C                   IF        DDKYSL <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    ALKEY
     C                   PARM      20            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQKYSL
     C                   PARM      20            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDFNSL <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    ALFUNC
     C                   PARM      21            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQFNSL
     C                   PARM      21            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   IF        DDSTSL <> *BLANKS                                          CSD028
                                                                                              CSD028
     C                   CALL      'QCLSCAN'                                                  CSD028
     C                   PARM                    ALSTAT                                       CSD028
     C                   PARM      1             WQA3N                                        CSD028
     C                   PARM      1             WQB3N                                        CSD028
     C                   PARM                    WQSTSL                                       CSD028
     C                   PARM      1             WQC3N                                        CSD028
     C                   PARM      '1'           WQD1                                         CSD028
     C                   PARM      '1'           WQE1                                         CSD028
     C                   PARM      '?'           WQF1                                         CSD028
     C                   PARM                    WQG3N                                        CSD028
                                                                                              CSD028
     C                   IF        WQG3N < 1                                                  CSD028
     C                   EVAL      WSkipRec = 'Y'                                             CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        WSkipRec = 'N'
 
      ** Load subfile fields
 
     C                   MOVE      *BLANK        DDOPTN
     C                   MOVEL     ALKEY         DDKEY
     C                   MOVEL     ALFUNC        DDFUNC
     C                   MOVE      ALACTN        DDACTN
     C                   MOVE      ALUSER        DDUSER
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   MOVE      ALSTAT        DDSTAT                                       CSD028
     C                   ENDIF                                                                CSD028
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
     C                   WRITE     SDAUTHS0
 
     C                   ELSE
     C                   SUB       1             @@RRN
     C                   ENDIF
 
      ** End of File
 
     C                   IF        CSD028 = 'N'                                               CSD028
     C                   READ      SDAULGL2                               82
     C                   ELSE                                                                 CSD028
     C                   READ      SDAULGL5                               82                  CSD028
     C                   ENDIF                                                                CSD028
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
     C                   EVAL      DDKEY = *Blanks
     C                   EVAL      DDFUNC = *Blanks
     C                   EVAL      DDACTN = *Blanks
     C                   EVAL      DDUSER = *Blanks
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   EVAL      DDSTAT = *Blanks                                           CSD028
     C                   ENDIF                                                                CSD028
      *
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
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
     C                   WRITE     SDAUTHC1
     C                   WRITE     SDAUTHF0
     C                   EXFMT     SDAUTHC0
 
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
 
      ** Change of position specified
 
     C                   IF        WZKYSL <> DDKYSL OR WZFNSL <> DDFNSL
     C                             OR WZSTSL <> DDSTSL AND CSD028 = 'Y'                       CSD028
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C     W0RSF         IFNE      'Y'
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   MOVE      '0'           *IN94
 
     C                   READC     SDAUTHS0                               99
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
     C                   UPDATE    SDAUTHS0
     C                   READC     SDAUTHS0                               99
     C                   ENDDO
 
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
     C                   IF        CSD028 = 'N'                                               CSD028
     C                   If        MODE = 'E' AND DDOPTN <> 'E'
     C                             AND DDOPTN <> ' ' OR
     C                             MODE <> 'E' AND DDOPTN <> 'E' AND DDOPTN
     C                             <> 'D' AND DDOPTN <> 'X' AND DDOPTN <> ' '
      *
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
      *
     C                   If        MODE = 'E'
     C                   EVAL      PZMsgID = 'USR9266'
     C                   Else
     C                   EVAL      PZMsgID = 'USR9267'
     C                   Endif
      *
     C                   EXSR      SRZasnms
     C                   Endif
                                                                                              CSD028
     C                   ELSE                                                                 CSD028
                                                                                              CSD028
     C                   IF        DDFUNC = 'CUSTOMER DETAILS'                                CSD028
                                                                                              CSD028
     C                   SELECT                                                               CSD028
     C                   WHEN      DDOPTN = 'A'                                               CSD028
     C                   IF        DDSTAT = 'P'                                               CSD028
     C                   EVAL      *IN32  = *ON                                               CSD028
     C                   EVAL      *IN94  = *ON                                               CSD028
     C                   EVAL      PZMsgID = 'USR6007'                                        CSD028
     C                   EXSR      SRZasnms                                                   CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   WHEN      DDOPTN = 'K'                                               CSD028
     C                   IF        DDSTAT <> 'I' AND DDSTAT <> 'A' AND                        CSD028
     C                             DDSTAT <> 'R'                                              CSD028
     C                   EVAL      *IN32  = *ON                                               CSD028
     C                   EVAL      *IN94  = *ON                                               CSD028
     C                   EVAL      PZMsgID = 'USR6006'                                        CSD028
     C                   EXSR      SRZasnms                                                   CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   WHEN      DDOPTN = 'D'                                               CSD028
     C                   IF        DDSTAT <> 'R'                                              CSD028
     C                   EVAL      *IN32  = *ON                                               CSD028
     C                   EVAL      *IN94  = *ON                                               CSD028
     C                   EVAL      PZMsgID = 'USR6008'                                        CSD028
     C                   EXSR      SRZasnms                                                   CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   WHEN      DDOPTN = 'X'                                               CSD028
     C                   IF        DDSTAT <> 'A' AND DDSTAT <> *Blanks                        CSD028
     C                   EVAL      *IN32  = *ON                                               CSD028
     C                   EVAL      *IN94  = *ON                                               CSD028
     C                   EVAL      PZMsgID = 'USR6009'                                        CSD028
     C                   EXSR      SRZasnms                                                   CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDSL                                                                CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD028
      *
      ** Check if record still exists
     C     DDKEY         CHAIN     SDAULGL0                           85
      *
      ** Send message 'Record no longer on file'
     C                   If        *IN85 = *ON
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0009'
     C                   EXSR      SRZasnms
     C                   Endif
      *
      ** Validate User
     C                   If        DDOPTN = 'X' AND PsUser = DDUSER
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9268'
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
 
      ** Pass the Key and Action code to the Authorisation programs
 
     C                   SELECT
 
     C                   WHEN      DDFUNC = 'ACCOUNT DETAILS'
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        *IN32 = *OFF                                               CSD015
     C                   CALLB     'GLAMADAUT'
     C                   PARM      *BLANKS       RETCODE          10
     C**********         PARM                    DDKEY            20                          CGL029
     C                   PARM                    DDKEY            26                          CGL029
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG            7
     C                   PARM                    @INKC             1
     C                   ENDIF                                                                CSD015
     C                   Eval      PZMsgFile = 'REUSRMSG'                                    BUG5340
 
     C                   WHEN      DDFUNC = 'EXTENDED SETTLEMENTS'
     C                   CALLB     'SDEXSTAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
 
     C                   WHEN      DDFUNC = 'CURRENCY DETAILS'
     C                   CALLB     'SDCURRAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
 
     C                   WHEN      DDFUNC = 'NOSTRO DETAILS'
     C                   CALLB     'SDNOSTAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
 
     C                   WHEN      DDFUNC = 'HOLIDAY DETAILS'
     C                   CALLB     'SDHOLIAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
 
     C                   WHEN      DDFUNC = 'BASE RATE DETAILS'
     C                   CALLB     'SDBSRTAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
 
     C                   WHEN      DDFUNC = 'COUNTERPARTY NOSTROS'
     C                   CALLB     'SDCPNOAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
 
     C                   WHEN      DDFUNC = 'CUSTOMER DETAILS'
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        DDOPTN <> 'A' AND DDOPTN <> 'K'                            CSD028
     C                   IF        *IN32 = *OFF                                               CSD015
     C                   CALLB     'SDCUSDAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM                    DDACTN                                       CSD028
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        CSD028     = 'Y'                                           CSD028
     C                   IF        DDOPTN     = 'A'                                           CSD028
     C                   EVAL      PTransType = 'AUTH'                                        CSD028
     C                   EVAL      PCustNumC  = %Subst(DDKEY:1:6)                             CSD028
     C                   MOVE      PCustNumC     PCustNum                                     CSD028
     C                   CALL      'SDCUSDSIN'                                                CSD028
     C                   PARM                    PTransType                                   CSD028
     C                   PARM                    PCustNumC                                    CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        DDOPTN    = 'K'                                            CSD028
     C                   EVAL      PCustNumC = %Subst(DDKEY:1:6)                              CSD028
     C                   CALL      'SD000050'                                                 CSD028
     C                   PARM                    PCustNumC                                    CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD028
 
     C                   WHEN      DDFUNC = 'ALTERNATIVE CUSTOMER'
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        *IN32 = *OFF                                               CSD015
     C                   CALLB     'SDCUSAAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
     C                   ENDIF                                                                CSD015
 
     C                   WHEN      DDFUNC = 'CORRESPONDENT DETAILS'
     C                   CALLB     'CGCORRAUT'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM                    DDKEY
     C                   PARM                    DDOPTN
     C                   PARM      *BLANKS       ERRMSG
     C                   PARM                    @INKC
     C/COPY WNCPYSRC,SDH00560
 
     C                   ENDSL
 
      ** Exit if F3 requested
     C                   If        @INKC = '1'
     C                   EXSR      SREnd
     C                   Endif
 
      ** Process any Errors
     C                   If        ERRMSG <> *BLANKS
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = ERRMSG
      *
     C                   If        ERRMSG = 'Y2U0032' or ERRMSG = 'Y2U0009'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   Endif
      *
     C                   EXSR      SRZasnms
     C                   Endif
 
     C                   ENDSR
      /EJECT
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
     C                   EVAL      PZMsgID = 'USR4436'
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
     C                   EVAL      PZMsgFile = 'DRSMM'
     C                   EVAL      PZMsgID = 'RE71070'
     C                   EXSR      SRZasnms
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR4436'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   ENDIF
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile        10
     C                   PARM                    PZMsgID          10
 
     C                   EVAL      PZMsgFile = *BLANKS
 
     C                   ENDSR
      /EJECT
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SRWatch - Subroutine to check the Hit Status of data being   *                       CSD015
      *            authorized on the Compliance Watch engine. This    *                       CSD015
      *            subroutine only checks data being authorized for   *                       CSD015
      *            "SD Customer Details", "GL Account Details Ext.",  *                       CSD015
      *            and "SD Alternate Name and Address".               *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** If 24x7 Midas Availability is not installed or it is installed                       CSD015
      ** and in the main system, perform compliance watch processing                          CSD015
                                                                                              CSD015
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
     C                             OR CSC011 = 'N'                                            CSD015
                                                                                              CSD015
      ** Partial key to access sdcwhtl1                                                       CSD015
                                                                                              CSD015
     C     KCWFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdentifier                                  CSD015
                                                                                              CSD015
      ** Use Key Field in SD Authorization Log File as identifier                             CSD015
                                                                                              CSD015
     C                   EVAL      WIdentifier = ALKEY                                        CSD015
                                                                                              CSD015
     C                   SELECT                                                               CSD015
                                                                                              CSD015
      ** When record being authorized is from GL Account Details,                             CSD015
      ** use "ACCNTAB" as function type                                                       CSD015
                                                                                              CSD015
     C                   WHEN      DDFUNC = 'ACCOUNT DETAILS'                                 CSD015
     C                   EVAL      WFuncType = 'ACCNTAB'                                      CSD015
                                                                                              CSD015
      ** When record being authorized is from SD Customer Details,                            CSD015
      ** use "SDCUSTPD" as function type                                                      CSD015
                                                                                              CSD015
     C                   WHEN      DDFUNC = 'CUSTOMER DETAILS'                                CSD015
     C                   EVAL      WFuncType = 'SDCUSTPD'                                     CSD015
                                                                                              CSD015
      ** When record being authorized is from SD Alternate Name and                           CSD015
      ** Address, use "SDALTNPD" as function type                                             CSD015
                                                                                              CSD015
     C                   WHEN      DDFUNC = 'ALTERNATIVE CUSTOMER'                            CSD015
     C                   EVAL      WFuncType = 'SDALTNPD'                                     CSD015
                                                                                              CSD015
     C                   ENDSL                                                                CSD015
                                                                                              CSD015
      ** Access logical file based on SDCWHTPD to verify Hit Status.                          CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
      ** If found on the hit list file, send error message "Item under                        CSD015
      ** review by Compliance Officer"                                                        CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1)                                           CSD015
     C                   EVAL      *IN32 = *ON                                                CSD015
     C                   EVAL      *IN94 = *ON                                                CSD015
     C                   EVAL      PZMsgID = 'USR9270'                                        CSD015
     C                   EXSR      SRZasnms                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
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
 
     C     *ENTRY        PLIST
      *
     C                   PARM                    MODE              1
 
      ** Initialize program name
 
     C                   MOVEL     'SDAUTHFNC'   DBPGM
 
      ** Move workstation ID to screen field
 
     C                   EVAL      ##PGMQ = PSProcName
     C                   EVAL      DDUSR  = PsUser
     C                   EVAL      DDWID  = PsJobName
 
      ** Set Display according to enquiry or maintenance mode
 
     C     MODE          IFEQ      'E'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
 
      ** Initialise Subfile Control
 
     C                   MOVE      *BLANKS       DDFNSL
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
 
      ****GET*ZMUSER*to*access*default*branch                                              BUG6979
 
     C******DTAARA       DEFINE                  ZMUSER                                    BUG6979
     C**********         IN        ZMUSER                                                  BUG6979
     C**********         UNLOCK    ZMUSER                                                  BUG6979
 
      ** Check if CSC011 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*VERIFY'     @OPTN                                        CSD015
     C                   PARM      'CSC011'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RTCD <> *BLANKS) and                                     CSD015
     C                             (@RTCD <> '*NRF   ')                                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 2                                                  CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RTCD = *BLANKS                                            CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if CSD015 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*VERIFY'     @OPTN                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RTCD <> *BLANKS) and                                     CSD015
     C                             (@RTCD <> '*NRF   ')                                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 3                                                  CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RTCD = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If Enhancement CSD015 is installed, access SDWLCCPD to                               CSD015
      ** see if 'SDCUSD' fucntion code is available.                                          CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*KEY   '     @OPTN                                        CSD015
     C                   PARM      'SDCUSD'      PFncCd                                       CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RTCD <> *BLANKS)                                         CSD015
     C                             AND (@RTCD <> '*NRF')                                      CSD015
     C                   EVAL      DBKEY = 'SDCUSD'                                           CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 4                                                  CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD028
      ** Check if CSD028 is installed                                                         CSD028
      *                                                                                       CSD028
     C                   EVAL      *IN35  = *ON                                               CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   CALLB     'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       P@Rtcd                                       CSD028
     C                   PARM      '*VERIFY'     P@Optn                                       CSD028
     C                   PARM      'CSD028'      PSard                                        CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
                                                                                              CSD028
      ** Database error                                                                       CSD028
                                                                                              CSD028
     C                   IF        (P@Rtcd <> *BLANKS) AND                                    CSD028
     C                             (P@Rtcd <> '*NRF   ')                                      CSD028
     C     *LOCK         IN        LDA                                                        CSD028
     C                   EVAL      DBKEY = 'CSD028'                                           CSD028
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
     C                   EVAL      DBASE = 5                                                  CSD028
     C                   OUT       LDA                                                        CSD028
     C                   EXSR      *PSSR                                                      CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        P@RTCD = *BLANKS                                           CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   EVAL      *IN35  = *OFF                                              CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
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
(c) Finastra International Limited 2001
