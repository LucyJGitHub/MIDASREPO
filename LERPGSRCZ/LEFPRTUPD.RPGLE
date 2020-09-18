     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(FCLTYX) TOFILE(FCLTY) SHARE(*NO)                 *
/*XBIB*  OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)               *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant update')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFPRTUPD -  Funding Participant Update                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3112            Date 08Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 15Apr03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CLE023             Date 12Apr02               *
      *                 CAP068  *CREATE    Date 20Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3112- Missing Facility History Improvements (CLE023)      *
      *           change.                                             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CLE023 - Recompiled due to changes to LEVFCLNPD.             *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FFCLTYX    UF A E           K DISK    INFSR(*PSSR) IGNORE(FCLTYFNF)
     F                                     USROPN
     F                                     COMMIT
     FFCLTYXFN  UF A E           K DISK    INFSR(*PSSR) PREFIX(F@)
     F                                     IGNORE(FCLTYFMF:FCLTYHHF:FCLTYZZF)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D OVRDBF          C                   'OVRDBF FILE(FCLTYX)-
     D                                       TOFILE(FCLTY) SHARE(*NO)'
     D OVRDBFB         C                   'OVRDBF FILE(FCLTYXFN)-
     D                                       TOFILE(FCLTY) SHARE(*NO)'

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Funding Participant Details in file format
     D FCLTYFM       E DS                  EXTNAME(FCLTYFM)

      ** Funding Participant Details in file format
     D FCLTYFN       E DS                  EXTNAME(FCLTYFN) PREFIX(F@)

      ** Valid Funding Participant Details in file format record 'A'
     D LEVFCLMPD     E DS                  EXTNAME(LEVFCLMPD)

      ** Valid Funding Participant Details in file format record 'B'
     D LEVFCLNPD     E DS                  EXTNAME(LEVFCLNPD)

      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)

      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)

      ** Funding Participant Details OK indicator
     D FPRT_OK       E DS                  EXTNAME(LEEFPRTPD)


      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)


     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D                                     PREFIX(SC_)
      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D WDealNo         S              6A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *
      ** Clear output fields
      *
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx

     C                   MOVEL     *BLANK        A_FCNO

     C                   SELECT

      **  Write facility record
      **  =====================

     C     S#ACTN        WHENEQ    'I'
     C                   EXSR      WRITER

      **  Update facility record
      **  ======================

     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDR

      **  Reverse facility record
      **  =======================

     C     S#ACTN        WHENEQ    'R'
     C                   EXSR      REVERR
      *
     C                   ENDSL

      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR

      ** Setup Funding Participant support log

     C                   CALLB     'LEFPRTLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    S#ACTN
     C                   PARM                    FCLTYFM
     C                   PARM                    TRANSDTL

      ** Write to support database log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'LEFPRT'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     FPFRNT        APFOTRANID
     C                   MOVEL     FPAFRT        APFOASOCID
     C                   MOVEL     FPCNUM        W@FPCNUM          6
     C                   MOVEL     FPFACT        W@FPFACT          3
     C                   MOVEL     FPFCNO        W@FPFCNO          2
     C                   EVAL      PDealNo = W@FPCNUM + W@FPFACT +
     C                                       W@FPFCNO
     C                   EVAL      PADealNo = *BLANKS

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo

     C                   ENDIF

      ** If error occured,

     C                   IF        RetCodeOut <> *BLANKS

     C                   EVAL      RetCodeIn = '*ERROR'

     C                   ENDIF

     C                   ENDIF

      **  Update the trailer if no errors
      **  Else report an error

     C     Ix            IFEQ      0
     C                   EXSR      UPDTRL
     C                   ELSE
     C     RetCodeIn     IFEQ      *BLANK
     C                   MOVEL     '*ERROR    '  RetCodeIn
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN

      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WRITER   : Write a record to facility file                    *
      *****************************************************************
     C     WRITER        BEGSR

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      **  Write facility record type 'A'
     C                   MOVEL     LEVFCLMPD     FCLTYFM
     C                   EVAL      STMP  = TimeStamp
     C                   Z-ADD     0             REXR                                         CAP084
     C                   Z-ADD     0             PEXR                                         CAP084

     C                   WRITE     FCLTYFMF

      **  Write facility record type 'B'
     C                   MOVEL     LEVFCLNPD     FCLTYFN
     C                   Z-ADD     0             F@CEXP                                      BUG3112

     C                   WRITE     FCLTYFNF

      * Return assigned facility number
     C                   MOVE      FPFCNO        A_FCNO
      *
     C     EWRITER       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AMENDR   : Update Facility File                               *
      *****************************************************************
     C     AMENDR        BEGSR

      ** Set up the key to the facility file

     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO

      ** Access facility record type 'A'

     C                   MOVE      'A'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAMENDR
     C                   ENDIF

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      ** Update facility record type 'A'

     C                   MOVEL     LEVFCLMPD     FCLTYFM
     C                   EVAL      STMP = TimeStamp

     C                   UPDATE    FCLTYFMF

      ** Access facility record type 'B'

     C                   MOVE      'B'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFNF                           70

      ** Update facility record type 'B'

     C                   MOVEL     LEVFCLNPD     FCLTYFN

     C                   UPDATE    FCLTYFNF
      *
     C     EAMENDR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * REVERR   : Reverse a record                                   *
      *****************************************************************
     C     REVERR        BEGSR

      ** Set up the key to the facility file

     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO

      ** Access facility record type 'A'

     C                   MOVE      'A'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EREVERR
     C                   ENDIF

      ** Update facility record type 'A'

     C                   Z-ADD     FAMT          W#SFAMT
     C                   MOVE      'R'           RECI
     C                   Z-ADD     NATN          TNLU
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      S#ACTN        CHTP

     C                   UPDATE    FCLTYFMF

      ** Access facility record type 'B'

     C                   MOVE      'B'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFNF                           70

      ** Update facility record type 'B'

     C                   MOVE      'R'           RECI
     C                   Z-ADD     NATN          TNLU
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      S#ACTN        CHTP

     C                   UPDATE    FCLTYFNF
      *
     C     EREVERR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * UPDTRL   : Update trailer                                     *
      *****************************************************************
     C     UPDTRL        BEGSR
      *
      ** Update the file controls on LF/FCLTY
      *
     C**********         Z-ADD     999999        K#CNUM                                       CSD027
     C                   EVAL      K#CNUM = '999999'                                          CSD027
     C                   Z-ADD     999           K#FACT
     C                   Z-ADD     99            K#FCNO
     C                   MOVE      'Z'           K#RCTP

     C     K#FCTY        CHAIN     FCLTYZZF                           70

     C     *IN70         IFEQ      '1'
     C     *IN70         OREQ      '0'
     C     RECI          ANDNE     'T'
     C                   MOVEL     'FCLTYZZ '    DBFILE
     C                   MOVEL     '800'         DBASE
     C                   MOVEL     K#CNUM        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SELECT
      *
      **  Inserts
     C     S#ACTN        WHENEQ    'I'

     C                   ADD       2             NORE
     C                   ADD       2             NINS
     C                   ADD       2             NLRA
      *
      ** Set up amount fields
     C     FAMT          DIV       1000          ZZAMT            15 3
      *
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
      *
      **  Save it to calculate totals
     C                   Z-ADD     FAMT          ZAMT             15 0
      *
      **  Amend
     C     S#ACTN        WHENEQ    'A'
      *
     C                   Z-ADD     VRAF          ZZTOTI
     C                   Z-ADD     VRAL          ZZTOTD
     C     FAMT          SUB       W#SFAMT       W#ADJ            15 0
     C                   MOVE      W#ADJ         ZZAMT
     C     W#ADJ         DIV       1000          ZZAMT            15 3
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VRAF
     C                   Z-ADD     ZZTOTD        VRAL
      *
     C                   Z-ADD     W#ADJ         ZAMT
      *
      **  Reverse
     C     S#ACTN        WHENEQ    'R'
      *
      **  Only update number of live records
     C                   ADD       2             NDEL
     C                   SUB       2             NLRA
      *
      ** Set up amount fields
     C     W#SFAMT       DIV       1000          ZZAMT            15 3
      *
     C                   Z-ADD     VRDF          ZZTOTI
     C                   Z-ADD     VRDL          ZZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VRDF
     C                   Z-ADD     ZZTOTD        VRDL
      *
     C                   Z-SUB     W#SFAMT       ZAMT
      *
     C                   ENDSL
      *
      ** Calculate Totals
      *
     C     ZAMT          DIV       1000          ZZAMT
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      S#ACTN        CHTP
     C                   Z-ADD     NATN          TNLU
     C                   UPDATE    FCLTYZZF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRZADD   : Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*
      *****************************************************************
     C     SRZADD        BEGSR
      *
      ** Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      SRZSUM
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRZSUM   : Carries out the addition of the amounts            *
      *****************************************************************
     C     SRZSUM        BEGSR
      *
      ** Save values of indicators to be used in the program
     C                   MOVE      *IN91         WIN91             1
     C                   MOVE      *IN92         WIN92             1
     C                   MOVE      *IN93         WIN93             1
     C                   MOVE      *IN94         WIN94             1
     C                   MOVE      *IN95         WIN95             1
     C                   MOVEA     '00000'       *IN(91)
     C                   MOVE      '0'           *IN99
      *
     C                   DO
      *
      ** Determine sign of ZZAMTI and ZZAMTD, 92 IF NEG
      ** If both are zero, bypass processing
      *
     C     ZZAMTI        IFEQ      *ZEROS
     C     ZZAMTD        ANDEQ     *ZEROS
     C                   LEAVE
     C                   ELSE
     C     ZZAMTI        IFLT      *ZEROS
     C     ZZAMTD        ORLT      *ZEROS
     C                   MOVE      '1'           *IN92
     C                   ENDIF
     C                   ENDIF
      *
      ** Determine sign of ZZTOTI and ZZTOTD, 91 IF NEG.
      ** If ZZTOTAL is ZERO, return ZZAMOUNT.
      *
     C     ZZTOTI        IFEQ      *ZEROS
     C     ZZTOTD        ANDEQ     *ZEROS
     C                   Z-ADD     ZZAMTI        ZZTOTI           15 0
     C                   Z-ADD     ZZAMTD        ZZTOTD            3 0
     C                   LEAVE
     C                   ELSE
     C     ZZTOTI        IFLT      *ZEROS
     C     ZZTOTD        ORLT      *ZEROS
     C                   MOVE      '1'           *IN91
     C                   ENDIF
     C                   ENDIF
      *
      ** If signs differ, bypass overflow checks
      *
     C     *IN91         IFEQ      '0'
     C     *IN92         ANDEQ     '0'
     C     *IN91         OREQ      '1'
     C     *IN92         ANDEQ     '1'
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         IFGT      999
     C     ZZWK2         ORLE      999
     C     ZZWK2         ANDLT     -999
      *
     C     *IN92         IFEQ      '0'
     C     ZZAMTI        ADD       1             ZZWK3            15 0
     C                   ELSE
     C     ZZAMTI        SUB       1             ZZWK3
     C                   ENDIF
     C     ZZTOTI        ADD       ZZWK3         ZZWK3
      *
     C                   ELSE
     C     ZZTOTI        ADD       ZZAMTI        ZZWK3
     C                   ENDIF
      *
      ** If the modulus of ZZWK3 is less than the modulus of ZZTOTI,
      ** then overflow has occurred
      *
     C     *IN92         IFEQ      '0'
     C     ZZWK3         COMP      ZZTOTI                               99
     C                   ELSE
     C     ZZWK3         COMP      ZZTOTI                             99
     C                   ENDIF
      *
      ** If overflow occurs, zeroise ZZAMT
      *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             ZZAMT            15 3
     C                   ELSE
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** the signs are different
      *
     C     *IN91         IFEQ      '1'
     C     *IN92         ANDEQ     '0'
     C     *IN91         OREQ      '0'
     C     *IN92         ANDEQ     '1'
      *
      ** If ZZAMT was negative, make it positive to compare with ZZTOT
      *
     C     *IN92         IFEQ      '1'
     C                   Z-SUB     ZZAMTI        ZZAMTI           15 0
     C                   Z-SUB     ZZAMTD        ZZAMTD            3 0
     C                   ENDIF
      *
      ** If ZZTOT was negative, make it positive to compare with ZZAMT
      *
     C     *IN91         IFEQ      '1'
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Both ZZAMT and ZZTOT are now positive
      ** If ZZTOT equals ZZAMT, return zero
      *
     C                   MOVE      '0'           *IN93
     C     ZZTOTI        IFEQ      ZZAMTI
     C     ZZTOTD        ANDEQ     ZZAMTD
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   LEAVE
     C                   ELSE
     C     ZZTOTI        IFGT      ZZAMTI
     C     ZZTOTD        OREQ      ZZAMTD
     C                   MOVE      '1'           *IN93
     C                   ENDIF
     C                   ENDIF
      *
      ** If ZZTOT greater than ZZAMT
      *
     C     *IN93         IFEQ      '1'
     C     ZZAMTD        IFGT      ZZTOTD
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWK2
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C     ZZWK2         SUB       ZZAMTD        ZZTOTD
     C                   ELSE
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
      *
      ** If ZZAMT greater than ZZAMT
      *
     C                   ELSE
     C     ZZTOTD        IFGT      ZZAMTD
     C     ZZAMTI        SUB       1             ZZWK3            15 0
     C     ZZAMTD        ADD       1000          ZZWK2
     C     ZZWK3         SUB       ZZTOTI        ZZTOTI
     C     ZZWK2         SUB       ZZTOTD        ZZTOTD
     C                   ELSE
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
     C                   ENDIF
      *
      ** Reverse sign of ZZTOT if larger input fields were negative
      *
     C     *IN93         IFEQ      '1'
     C     *IN91         ANDEQ     '1'
     C     *IN93         OREQ      '0'
     C     *IN92         ANDEQ     '1'
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Restore sign of ZZAMTI & ZZAMTD if reversed
      *
     C     *IN92         IFEQ      '1'
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If ZZTOTD is zero, and ZZTOTI is negative, setup  ZZNEGD
      *
     C     ZZTOTD        IFEQ      *ZEROS
     C     ZZTOTI        ANDLT     *ZEROS
     C                   MOVE      '.000-'       ZZNEGD            5
     C                   ENDIF
      *
      ** Restore previous indicator values
      *
     C                   MOVE      WIN91         *IN91
     C                   MOVE      WIN92         *IN92
     C                   MOVE      WIN93         *IN93
     C                   MOVE      WIN94         *IN94
     C                   MOVE      WIN95         *IN95
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZTNLU1        BEGSR

     C                   CALLB     'ZTNLU1'
     C                   PARM                    RetCodeOut
     C                   PARM                    NATN              5 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN            1

      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU            5 0

      * Funding Participant Details in file format record 'A'
     C                   PARM                    LEVFCLMPD
      * Funding Participant Details in file format record 'B'
     C                   PARM                    LEVFCLNPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FPRT_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
      * Facility sequence assigned

     C                   PARM                    A_FCNO            2

     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO

     C     *LIKE         DEFINE    FCNO          K4FCNO
     C     *LIKE         DEFINE    RCTP          K#RCTP

     C     *LIKE         DEFINE    FAMT          W#SFAMT

      * Key lists

     C     K#FCTY        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCTP

      *
      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** OVRDBF FCLTYX to FCLTY then OPEN FCLTYX

     C                   EVAL      LENGTH = %SIZE(OVRDBF)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF        QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      FCLTYX

      ** OVRDBF FCLTYXFN to FCLTY

     C                   EVAL      LENGTH = %SIZE(OVRDBFB)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBFB       QCMD             70
     C                   PARM                    LENGTH           15 5

      ** Check if CSC011 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD = *Blanks

     C                   EVAL      CSC011 = 'Y'

     C                   IN        SC24X7
     C                   IN        SDSTAT

     C                   ELSE

      ** Database error

     C                   IF        PRTCD <> '*NRF'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      *COPY*ZACPYSRC*PSSR_ILE**                                                               CAP084
      /COPY ZACPYSRC,PSSR_ILENE                                                               CAP084
     C                   MOVEL     'ERROR'       RetCodeIn                                    CAP084
     C                   RETURN                                                               CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
