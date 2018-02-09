     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax/Non-tax and Branch Indicator')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVBHIN  - Validate Tax/Non-tax and Branch Indicators        *
      *           - Validate Account Holder Type                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 228654             Date 10Jul06               *
      *                 CDL013             Date 10Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CRE026 - Consumer Banking                                    *
      *  228654 - If tax indicator left blank defaulf to 0 for CDL013 *
      *  CDL013 - Tiered withholding tax                              *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
 
     FSDCTRYL1  IF   E           K DISK                                                       CRE007
      * Midas SD Country Codes                                                                CRE007
                                                                                              CRE007
     FSDFRCTL1  IF   E           K DISK                                                       CRE007
      * Midas SD FR Countries File                                                            CRE007
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE007
     D SCA_LCD       E                     EXTFLD(LCD)                                        CRE007
      ** EXTERNAL DS FOR SAR DETAILS                                                          CRE007
                                                                                              CRE007
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE007
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CRE007
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message IDs, etc.                                        CRE007
     D WIx             S              3P 0                                                    CRE007
                                                                                              CRE007
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx                                          CRE007
 
      *
      ** VALIDATION
      *
     C                   EXSR      TNBIV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTAINOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C     DDBSINOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *                                                                                       CDL013
     C     DDCSTYOK      IFEQ      'N'                                                        CDL013
     C                   EVAL      RetCodeIn = 'Error'                                        CDL013
     C                   ENDIF                                                                CDL013
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION Tax/non-tax and branch indicators
      *****************************************************************
     C     TNBIV         BEGSR
 
      * If switchable feature Base Rate Tax is OFF
     C     S01383        IFEQ      'N'
      *                                                                                       CDL013
      ***   If CAR CDL013 is installed                                                        CDL013
     C     CDL013        IFEQ      'Y'                                                        CDL013
      *                                                                                       228654
     C     DDTAIN        IFEQ      ' '                                                        228654
     C                   EVAL      DDTAIN = '0'                                               228654
     C                   ENDIF                                                                228654
      *                                                                                       228654
      *                                                                                       CDL013
      ***   If Customer Type = 'N'                                                            CDL013
     C     DDCSTY        IFEQ      'N'                                                        CDL013
      *                                                                                       CDL013
      ***   If Tax Indicator not 0.                                                           CDL013
     C     DDTAIN        IFNE      '0'                                                        CDL013
     C                   MOVE      'N'           DDTAINOK                                     CDL013
     C                   ADD       1             Idx                                          CDL013
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)                               CDL013
     C                   MOVEL     'XXW0106'     MsgIdXAr(Idx)                                CDL013
     C                   END                                                                  CDL013
     C                   END                                                                  CDL013
      *                                                                                       CDL013
      ***   If Tax Indicator not in range 0-9.                                                CDL013
     C     DDTAIN        IFNE      '0'                                                        CDL013
     C     DDTAIN        ANDNE     '1'                                                        CDL013
     C     DDTAIN        ANDNE     '2'                                                        CDL013
     C     DDTAIN        ANDNE     '3'                                                        CDL013
     C     DDTAIN        ANDNE     '4'                                                        CDL013
     C     DDTAIN        ANDNE     '5'                                                        CDL013
     C     DDTAIN        ANDNE     '6'                                                        CDL013
     C     DDTAIN        ANDNE     '7'                                                        CDL013
     C     DDTAIN        ANDNE     '8'                                                        CDL013
     C     DDTAIN        ANDNE     '9'                                                        CDL013
     C                   MOVE      'N'           DDTAINOK                                     CDL013
     C                   ADD       1             Idx                                          CDL013
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)                               CDL013
     C                   MOVEL     'XXW0101'     MsgIdXAr(Idx)                                CDL013
     C                   END                                                                  CDL013
      *                                                                                       CDL013
      ***   If Customer Type not 'R' or 'C' or 'N'                                            CDL013
     C     DDCSTY        IFNE      'R'                                                        CDL013
     C     DDCSTY        ANDNE     'C'                                                        CDL013
     C     DDCSTY        ANDNE     'N'                                                        CDL013
     C                   MOVE      'N'           DDCSTYOK                                     CDL013
     C                   ADD       1             Idx                                          CDL013
     C                   MOVEL     'DDCSTY'      FldNamXAr(Idx)                               CDL013
     C                   MOVEL     'XXW0107'     MsgIdXAr(Idx)                                CDL013
     C                   END                                                                  CDL013
      *                                                                                       CDL013
     C                   ELSE                                                                 CDL013
 
      * Taxable indicator must be Y or N (in case of blank defaults to N)
     C     DDTAIN        IFEQ      'Y'
     C     DDTAIN        OREQ      'N'
     C     DDTAIN        OREQ      *BLANK
 
     C     DDTAIN        IFEQ      *BLANK
     C                   MOVE      'N'           DDTAIN
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      'N'           DDTAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR0998'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                                CDL013
 
      * Otherwise (i.e. Base Rate Tax is ON)
     C                   ELSE
 
      * From here DDTAIN refers Account Holder Type
 
      **Account*holder*type*must*be*B,*C,*N,*O,*I*or*J*************                           CRE007
      * Account holder type must be B, C, N, O, I, J or R                                     CRE007
     C     DDTAIN        IFEQ      'B'
     C     DDTAIN        OREQ      'C'
     C     DDTAIN        OREQ      'N'
     C     DDTAIN        OREQ      'O'
     C     DDTAIN        OREQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'                                                        CRE007
     C     CRE007        ANDEQ     'Y'                                                        CRE007
 
      * If account holder type is N, I or J
     C     DDTAIN        IFEQ      'N'
     C     DDTAIN        OREQ      'I'
     C     DDTAIN        OREQ      'J'
 
      * If bank/non-bank indicator is N
     C     DDBNBI        IFEQ      'N'
 
      * Branch indicator must be blank
     C     DDBSIN        IFNE      *BLANK
     C                   MOVE      'N'           DDBSINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBSIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1795'     MsgIdXAr(Idx)
     C                   ENDIF
 
      * Otherwise error (i.e. bank/non-bank indicator is not N)
     C                   ELSE
     C                   MOVE      'N'           DDTAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1793'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
      * If account holder type is B
     C     DDTAIN        IFEQ      'B'
 
      * Bank/non-bank indicator must be Y
     C     DDBNBI        IFNE      'Y'
     C                   MOVE      'N'           DDTAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1792'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
      * If account holder type is C
     C     DDTAIN        IFEQ      'C'
 
      * Bank/non-bank indicator must be N
     C     DDBNBI        IFNE      'N'
     C                   MOVE      'N'           DDTAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1793'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
 
      * If account holder type is R                                                           CRE007
     C     CRE007        IFEQ      'Y'                                                        CRE007
      *                                                                                       CRE007
      * CHAIN to FR Country codes file with ISO code to ascertain                             CRE007
      * if Customer country of domicile is an FR Country.                                     CRE007
     C     DDCOLC        CHAIN     SDCTRYL1                           88                      CRE007
      *                                                                                       CRE007
     C     A4ISOC        CHAIN     SDFRCTD0                           89                      CRE007
      *                                                                                       CRE007
     C     DDTAIN        IFEQ      'R'                                                        CRE007
                                                                                              CRE007
      * If Bank Non-Bank indicator is Y or Country of domicile is                             CRE007
      * not an FR country.                                                                    CRE007
     C     DDBNBI        IFEQ      'Y'                                                        CRE007
     C     *IN89         OREQ      *ON                                                        CRE007
      *                                                                                       CRE007
      * Send message 'Account Holder cannot be R if customer is a Bank                        CRE007
      * or Country of domicile is not an FR country'.                                         CRE007
     C                   MOVE      'N'           DDTAINOK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4609'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CRE007
      * If the Account holder type is not R, but the customer's country                       CRE007
      * of domicile is defined as an FR country and the Bank Indicator                        CRE007
      * is N display Warning message.                                                         CRE007
      *                                                                                       CRE007
     C     DDTAIN        IFNE      'R'                                                        CRE007
     C     DDBNBI        ANDEQ     'N'                                                        CRE007
     C     *IN89         ANDEQ     *OFF                                                       CRE007
      *                                                                                       CRE007
     C                   ADD       1             WIx                                          CRE007
     C                   MOVEL     'DDBNBI'      WFldNmXAr(WIx)                               CRE007
     C                   MOVEL     'USR4601'     WMsgIdXAr(WIx)                               CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CRE007
     C                   ENDIF                                                                CRE007
 
      **Otherwise*(i.e.*account*holder*type*is*not**B,*C,*N,*O,*I*or****J)**                  CRE007
      * Otherwise (i.e. account holder type is not  B, C, N, O, I, J or R)                    CRE007
     C                   ELSE
     C                   MOVE      'N'           DDTAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAIN'      FldNamXAr(Idx)
                                                                                              CRE007
     C     CRE007        IFEQ      'N'                                                        CRE007
     C                   MOVEL     'USR1789'     MsgIdXAr(Idx)
     C                   ELSE                                                                 CRE007
     C                   MOVEL     'USR4602'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
     C                   ENDIF
      *
     C                   ENDIF
 
      * Branch indicator must be H, B, P, W or blank
     C     DDBSIN        IFNE      'H'
     C     DDBSIN        ANDNE     'B'
     C     DDBSIN        ANDNE     'P'
     C     DDBSIN        ANDNE     'W'
     C     DDBSIN        ANDNE     *BLANK
     C                   MOVE      'N'           DDBSINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBSIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR0999'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      *
      ** Base Rate Tax Indicator, Switchable Feature S01383 (1A)
      ** Tax/Non-tax Indicator (1A)
      ** Branch Indicator (1A)
      ** Bank/Non-bank Indicator (1A)
      ** Country of Location (2A)                                                             CRE007
      ** Customer Type (1A)                                                                   CDL013
      *
     C                   PARM                    S01383            1
     C                   PARM                    DDTAIN            1
     C                   PARM                    DDBSIN            1
     C                   PARM                    DDBNBI            1
     C                   PARM                    DDCOLC            2                          CRE007
     C                   PARM                    DDCSTY            1                          CDL013
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      *                                                                                       CRE007
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE007
                                                                                              CRE007
     C                   PARM                    WFldNmXAr                                    CRE007
     C                   PARM                    WMsgIDXAr                                    CRE007
     C                   PARM                    WMsgDtXAr                                    CRE007
      *                                                                                       CRE007
      *
      ** Tax/non-tax indicator - OK
     C                   PARM                    DDTAINOK          1
      *
      ** Branch Indicator - OK
     C                   PARM                    DDBSINOK          1
      *                                                                                       CDL013
      ** Customer Type  - OK                                                                  CDL013
     C                   PARM                    DDCSTYOK          1                          CDL013
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
      *                                                                                       CRE007
      ** Access SAR details file to determine if CRE007                                       CRE007
      ** (Base Rate Tax 2001) is on.                                                          CRE007
      *                                                                                       CRE007
     C                   CALLB     'AOSARDR0'                                                 CRE007
     C                   PARM      *BLANKS       @RTCD             7                          CRE007
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE007
     C                   PARM      'CRE007'      @SARD             6                          CRE007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE007
      *                                                                                       CRE007
     C     @RTCD         IFEQ      *BLANKS                                                    CRE007
     C                   MOVE      'Y'           CRE007            1                          CRE007
     C                   ELSE                                                                 CRE007
     C                   MOVE      'N'           CRE007                                       CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CDL013
      ** Access SAR details file to determine if CDL013                                       CDL013
      ** Tiered withholding tax is on.                                                        CDL013
      *                                                                                       CDL013
     C                   CALLB     'AOSARDR0'                                                 CDL013
     C                   PARM      *BLANKS       @RTCD             7                          CDL013
     C                   PARM      '*VERIFY'     @OPTN             7                          CDL013
     C                   PARM      'CDL013'      @SARD             6                          CDL013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL013
      *                                                                                       CDL013
     C     @RTCD         IFEQ      *BLANKS                                                    CDL013
     C                   MOVE      'Y'           CDL013            1                          CDL013
     C                   ELSE                                                                 CDL013
     C                   MOVE      'N'           CDL013                                       CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
