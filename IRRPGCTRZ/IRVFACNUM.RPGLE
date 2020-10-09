     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Facility Details')                   *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRVCUSTNUM - Validate Facility Number/Type and Sequence      *
      *                                                               *
      *  Function:  This module receives a paramater containing the   *
      *             facility number, facility type, sequence and      *
      *             confirms whether it has a valid value.            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4646            Date 25Oct04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4646- Completion of SIRS api                              *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(G_)
     F                                     INCLUDE(DEALSDGF)

     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)

     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D_)

     FSDPLINL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(P_)

     FLEFCLTLG  IF   E           K DISK    INFSR(*PSSR)

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
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** Key to files - for DB error report
     D WKFKEY          DS
     D  F_BRCA                 1      3
     D**F_CNUM**               4      9  0                                                    CSD027
     D  F_CNUM                 4      9                                                       CSD027
     D  F_FTYP                10     12  0
     D  F_FSEQ                13     14  0

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ***  Work Allowable currencies array
     D WCY             S              3    DIM(12)
     D ARELIG          S              6    DIM(133)

      ** Array of Fields in error
     D FldNamXAr       S             10A   DIM(ArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(ArrayMax) LIKE(#MsgId)

      ** Array of error message data
     D MsgDtaXAr       S                   DIM(ArrayMax) LIKE(#MsgData)

      ** Array of Fields in error
     D WFldNamXAr      S             10A   DIM(ArrayMax)

      ** Array of error message IDs
     D WMsgIDXAr       S                   DIM(ArrayMax) LIKE(#MsgId)

      ** Array of error message data
     D WMsgDtaXAr      S                   DIM(ArrayMax) LIKE(#MsgData)

      ** Valid Deals layout
     D ValidXDeal    E DS                  EXTNAME(IRVXSIRPD)

      ** External data structure for customer details via access programs
     D  SDCUST       E DS                  EXTNAME(SDCUSTPD)

      **External dummy data structure
     D  DSSDY        E DS                  EXTNAME(DSSDY)

      **External dummy data structure
     D  DSLDY        E DS                  EXTNAME(DSLDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
     D BJRDNB          S                   LIKE(G_ORED)
     D SFCCU6          S                   LIKE(ROFCC)
     D SFACT3          S                   LIKE(ROFAC)
     D SFCNO2          S                   LIKE(ROFCN)

      ** Facility Customer, type and number
     D  SFCCU          S             10
     D  SFACT          S              3
     D  SFCNO          S              2

     D PRTCD           S              7
     D POPTN           S              7
     D PCNUM           S             10
     D PKYST           S              7

     D Module          S              4
     D SACCD           S              1
     D*SCNUM***********S              6                                         BUG4646
     D SCNUM           S             10                                         BUG4646
     D SBRCA           S              3
     D SDTYP           S              2
     D SDLST           S              2
     D SCLAS           S              4                                                       CDL038
     D SUCUCY          S              3
     D STCUCY          S              3
     D DealDate        S              5  0
     D SMDAT           S              6
     D Maturity        S              5  0
     D SCNUMOK         S              1
     D SBRCAOK         S              1
     D SDLSTOK         S              1
     D SCLASOK         S              1                                                       CDL038
     D SDDATOK         S              1
     D SMDATOK         S              1
     D SUCUCYOK        S              1
     D STCUCYOK        S              1
     D SFCCUOK         S              1
     D SFACTOK         S              1
     D SFCNOOK         S              1
     D SCNUM6A         S              6
     D SDLNO6          S              6  0

     D*WFCNUM***       S              6  0                                                    CSD027
     D WFCNUM          S              6                                                       CSD027
     D WFFACT          S              3  0
     D WFFCNO          S              2  0
     D WFRCTP          S              1
     D WFDTYP          S              2
     D WFDLST          S              2
     D WFCLAS          S              4                                                       CDL038
     D WCPRTR          S              1
     D WAGENT          S              6
     D WCPMFC          S              6  0
     D WCPMFT          S              3  0
     D WCPMFN          S              2  0
     D WKMAND          S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Reset the error flag to prevent problems on subsequent calls

     C                   RESET                   Errorfound
     C                   RESET                   Idx

     C                   EXSR      SRDEAL

      ** Facility Customer, Type and Sequence are mandatory

     C     SFCCU         IFEQ      *BLANKS
     C     SFACT         ANDEQ     *BLANKS
     C     SFCNO         ANDEQ     *BLANKS

     C     WKMAND        IFEQ      'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2001'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Facility cannot be changed if maturity date is today or earlier

     C     SACCD         IFEQ      'A'
     C     Maturity      ANDNE     0
     C     SMDATOK       ANDNE     'N'
     C     Maturity      ANDLE     BJRDNB
     C*****RFCCU         ANDNE     0                                                          CSD027
     C     RFCCU         ANDNE     *BLANKS                                                    CSD027
     C     RFACT         ANDNE     0
     C     RFCNO         ANDNE     0
     C                   MOVEL     RFCCU         SFCCU
     C                   MOVE      RFACT         SFACT
     C                   MOVE      RFCNO         SFCNO
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2019'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   ELSE

      ** Facility cannot be entered if maturity date is today or earlier

     C     SACCD         IFEQ      'I'
     C     Maturity      ANDNE     0
     C     SMDATOK       ANDNE     'N'
     C     Maturity      ANDLE     BJRDNB
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2018'     MsgIDXAr(Idx)

     C                   ELSE
     C     SACCD         IFEQ      'A'
     C     Maturity      ANDNE     0
     C     SMDATOK       ANDNE     'N'
     C     Maturity      ANDLE     BJRDNB
     C*****RFCCU         ANDEQ     0                                                          CSD027
     C     RFCCU         ANDEQ     *BLANKS                                                    CSD027
     C     RFACT         ANDEQ     0
     C     RFCNO         ANDEQ     0
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2018'     MsgIDXAr(Idx)
     C                   ELSE
     C                   EXSR      SRFACT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        Idx <> 0
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
     C                   EVAL      RFCCU = SFCCU6
     C                   EVAL      RFACT = SFACT3
     C                   EVAL      RFCNO = SFCNO2
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDEAL - Check whether Facility details are mandatory        *
      *                                                               *
      *****************************************************************
     C     SRDEAL        BEGSR

      ** Deal type and subtype must be valid

     C     SDLSTOK       IFNE      'N'
     C     SCLASOK       ANDNE     'N'                                                        CDL038

      ** Get the instrument type from the FD Deal type/subtype file

     C                   MOVE      SDTYP         WFDTYP
     C                   MOVE      SDLST         WFDLST
     C                   MOVE      SCLAS         WFCLAS                                       CDL038

     C     WKDEAL        CHAIN     FDDTSTL0                           53
     C     *IN53         IFEQ      '0'
     C                   MOVE      *BLANKS       WKMAND

      ** Get the instrument type

     C     D_INNR        CHAIN     SDPLINL0                           54
     C     *IN54         IFEQ      '0'
     C                   MOVE      P_PDFCMF      WKMAND

      ** Call access program to determine whether facility customer or
      ** shortname entered is valid.

     C                   IF        WKMAND = 'C'
     C                   EVAL      PCNUM = SCNUM

     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY      '  POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSLDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      WKMAND = BBFCMF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       WKMAND
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFACT - Validate Facility details                           *
      *                                                               *
      *****************************************************************
     C     SRFACT        BEGSR

      ** Reset work fields

     C                   MOVE      *BLANK        WCPRTR
     C                   MOVE      *BLANK        WAGENT
     C                   Z-ADD     0             WCPMFC
     C                   Z-ADD     0             WCPMFT
     C                   Z-ADD     0             WCPMFN

      ** Validate facility

      ** If one of the facility fields is entered and the facility customer
      ** is not entered, default it to the transaction customer

     C     SFCCU         IFEQ      *BLANKS
     C     SFCNO         ANDNE     *BLANKS
     C     SFCCU         OREQ      *BLANKS
     C     SFACT         ANDNE     *BLANKS
     C     SCNUMOK       ANDEQ     'Y'
     C                   MOVEL     SCNUM         SFCCU
     C                   ENDIF

      ** Call access program to determine whether facility customer or
      ** shortname entered is valid.

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY      '  POPTN
     C                   PARM      SFCCU         PCNUM
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Facility customer must be a number or shortname which exists on file

     C     PRTCD         IFNE      *BLANK
     C                   MOVE      'N'           SFCCUOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2011'     MsgIDXAr(Idx)
     C                   ELSE

     C                   MOVE      *BLANKS       SFCCU
     C                   MOVEL     BBCUST        SFCCU

      ** Facility must exist on facility file (both A and B recs)

     C                   MOVEL     SFCCU         WFCNUM
     C                   MOVEL     SFACT         WFFACT
     C                   MOVEL     SFCNO         WFFCNO

     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              51

     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              52

      ** Facility must refer to a live facility

     C     *IN51         IFEQ      '1'
     C     *IN52         OREQ      '1'
     C     *IN51         OREQ      '0'
     C     F_RECI        ANDNE     'D'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2008'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   MOVEL     SFCCU         SFCCU6
     C                   MOVE      SFACT         SFACT3
     C                   MOVE      SFCNO         SFCNO2

      ** Facility cannot be amended if maturity date is today or earlier

     C     SFCCUOK       IFNE      'N'
     C     SACCD         ANDEQ     'A'
     C     Maturity      ANDNE     0
     C     SMDATOK       ANDNE     'N'
     C     Maturity      ANDLE     BJRDNB
     C     SFCCU6        IFNE      RFCCU
     C     SFACT3        ORNE      RFACT
     C     SFCNO2        ORNE      RFCNO
     C                   MOVEL     RFCCU         SFCCU
     C                   MOVE      RFACT         SFACT
     C                   MOVE      RFCNO         SFCNO
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2019'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

      ** If Amend, the facility entered can only be equal to the Original
      ** Facility in extension file DLDLDGQD.

     C     SFCCUOK       IFNE      'N'
     C     SACCD         ANDEQ     'A'
     C     SFCCU         ANDNE     *BLANKS
     C     SFACT         ANDNE     *BLANKS
     C     SFCNO         ANDNE     *BLANKS
     C*****ROFCC         ANDNE     *ZERO                                                      CSD027
     C     ROFCC         ANDNE     *BLANKS                                                    CSD027
     C     ROFAC         ANDNE     *ZERO
     C     ROFCN         ANDNE     *ZERO
     C                   MOVE      RDLNO         SDLNO6

     C     SDLNO6        CHAIN     DEALS                              57
     C     *IN57         IFEQ      '0'
     C     G_ORED        ANDNE     BJRDNB

     C     SFCCU6        IFNE      ROFCC
     C     SFACT3        ORNE      ROFAC
     C     SFCNO2        ORNE      ROFCN
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2010'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Must be revolving facility

     C     SFCCUOK       IFNE      'N'
     C     F_RVCR        ANDNE     'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2002'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Must not be a Credit Agreement

     C     SFCCUOK       IFNE      'N'
     C     F_TRCA        ANDEQ     'CA'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2012'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Facility's start date must not be later than the deal date

     C     SFCCUOK       IFNE      'N'
     C     SDDATOK       ANDNE     'N'
     C     F_DTAP        ANDGT     DealDate
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2013'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Facility's last availability date must not be earlier than the deal date

     C     SFCCUOK       IFNE      'N'
     C     SDDATOK       ANDNE     'N'
     C     F_AVLD        ANDLT     DealDate
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2014'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Facility's expiry date must not be earlier than the deal's maturity date

     C     SFCCUOK       IFNE      'N'
     C     SMDATOK       ANDNE     'N'
     C     F_DTEX        ANDLT     Maturity
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2015'     MsgIDXAr(Idx)
     C                   ENDIF

      ** For Cross-currency transactions, facility must be multi-currency

     C     SFCCUOK       IFNE      'N'
     C     Module        ANDEQ     'CIRS'
     C     F_MCCY        ANDNE     'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2009'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   MOVEA     F_ALCY        WCY

      ** OUR Detail - Deal currency must match the Facility Currency or one
      ** of the allowable currencies

     C     SFCCUOK       IFNE      'N'
     C     SUCUCYOK      ANDNE     'N'
     C     SUCUCY        ANDNE     *BLANKS
     C     F_FCCY        ANDNE     SUCUCY

      ** Facility not multi-currency, but deal currency
      **   is different from facility currency

     C     F_MCCY        IFNE      'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2003'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Facility has a currency restriction equal to 'Y'

     C     F_MCCY        IFEQ      'Y'
     C     F_CSEL        ANDEQ     'Y'
     C     SUCUCY        LOOKUP    WCY                                    55
     C     *IN55         IFEQ      '0'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C     Module        IFEQ      'SIRS'
     C                   MOVEL     'MMA2004'     MsgIDXAr(Idx)
     C                   ENDIF
     C     Module        IFEQ      'CIRS'
     C                   MOVEL     'MMA2016'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** THEIR Detail - Deal currency must match the Facility Currency or one
      ** of the allowable currencies

     C     SFCCUOK       IFNE      'N'
     C     STCUCYOK      ANDNE     'N'
     C     STCUCY        ANDNE     *BLANKS
     C     F_FCCY        ANDNE     STCUCY

      ** Facility not multi-currency, but deal currency
      **   is different from facility currency

     C     F_MCCY        IFNE      'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2003'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Facility has a currency restriction equal to 'Y'

     C     F_MCCY        IFEQ      'Y'
     C     F_CSEL        ANDEQ     'Y'
     C     STCUCY        LOOKUP    WCY                                    55
     C     *IN55         IFEQ      '0'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2017'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Check if facility is multi-customer

     C     SCNUMOK       IFNE      'N'
     C     SFCCUOK       ANDNE     'N'
     C     SCNUM         ANDNE     SFCCU

      ** Facility is NOT multi-customer

     C     F_MCSI        IFNE      'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2006'     MsgIDXAr(Idx)
     C                   ELSE

      ** Facility is  multi-customer

     C                   MOVE      F_BRCA        FCXBRC
     C                   MOVE      F_CNUM        FCXFCU
     C                   MOVE      F_FACT        FCXFTP
     C                   MOVE      F_FCNO        FCXFNO

      ** Get the customer group from facility extension file LEFCLTQD

     C     WKFCLT        CHAIN     LEFCLTLG                           55

      ** Error if not found

     C     *IN55         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     WKFKEY        DBKEY
     C                   MOVEL     'IRVFACNUM'   DBPGM
     C                   MOVEL     'LEFCLTLG'    DBFILE
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     *IN55         IFEQ      '0'
     C                   CALL      'LE000020'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    FCXCGP
     C                   PARM      *BLANKS       DSSDY

     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     FCXCGP        DBKEY
     C                   MOVEL     'IRVFACNUM'   DBPGM
     C                   MOVEL     'LE000020'    DBFILE
     C                   Z-ADD     011           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEA     *BLANKS       ARELIG
     C                   MOVEA     DSSDY         ARELIG
     C                   MOVEL     SCNUM         SCNUM6A

     C     SCNUM6A       LOOKUP    ARELIG                                 55
     C     *IN55         IFEQ      '0'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2007'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Facility must be multi-branch if facility branch is different from
      ** booking branch

     C     SFCCUOK       IFNE      'N'
     C     SBRCAOK       ANDNE     'N'
     C     SBRCA         ANDNE     F_BRCA

      ** Facility is NOT multi-branch

     C     F_MBFC        IFNE      'Y'
     C                   MOVE      'N'           SFCCUOK
     C                   MOVE      'N'           SFACTOK
     C                   MOVE      'N'           SFCNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'SFCCU'       FldNamXAr(Idx)
     C                   MOVEL     'MMA2005'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUTS
      ** ReturnCode
     C                   PARM                    RetCodeIn

      ** Module
      ** Action Code
      ** Transaction Customer
      ** Branch
      ** Deal Type
      ** Deal Subtype
      ** Deal Class                                                                           CDL038
     C                   PARM                    Module
     C                   PARM                    SACCD
     C                   PARM                    SCNUM
     C                   PARM                    SBRCA
     C                   PARM                    SDTYP
     C                   PARM                    SDLST
     C                   PARM                    SCLAS                                        CDL038

      ** Our Currency
      ** Their Currency
      ** Deal Date (Midas format 5 0)
      ** Deal Maturity Date
      ** Maturity Date (Midas format 5 0)
     C                   PARM                    SUCUCY
     C                   PARM                    STCUCY
     C                   PARM                    DealDate
     C                   PARM                    SMDAT
     C                   PARM                    Maturity

      ** Facility Customer
      ** Facility Type
      ** Facility Number
     C                   PARM                    SFCCU
     C                   PARM                    SFACT
     C                   PARM                    SFCNO

      ** Rundate
      ** Valid Deal Extension file
     C                   PARM                    BJRDNB
     C                   PARM                    ValidXDeal

      ** OK fields INPUT
     C                   PARM                    SCNUMOK
     C                   PARM                    SBRCAOK
     C                   PARM                    SDLSTOK
     C                   PARM                    SCLASOK                                      CDL038
     C                   PARM                    SDDATOK
     C                   PARM                    SMDATOK
     C                   PARM                    SUCUCYOK
     C                   PARM                    STCUCYOK

      ** OUTPUTS
      ** OK fields of facility details
     C                   PARM                    SFCCUOK
     C                   PARM                    SFACTOK
     C                   PARM                    SFCNOOK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    WFldNamXAr
     C                   PARM                    WMsgIDXAr

      ** Key list for Facilities file

     C     WKFAC         KLIST
     C                   KFLD                    WFCNUM
     C                   KFLD                    WFFACT
     C                   KFLD                    WFFCNO
     C                   KFLD                    WFRCTP

      ** Key list for FD Deal type/subtype

     C     WKDEAL        KLIST
     C                   KFLD                    WFDTYP
     C                   KFLD                    WFDLST
     C                   KFLD                    WFCLAS                                       CDL038

      ** Key list for Facilities Extension File

     C     WKFCLT        KLIST
     C                   KFLD                    FCXBRC
     C                   KFLD                    FCXFCU
     C                   KFLD                    FCXFTP
     C                   KFLD                    FCXFNO

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
