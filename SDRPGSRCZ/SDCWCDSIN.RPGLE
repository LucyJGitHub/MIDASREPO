     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance Watch Configuration Input')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCWCDSIN - Compliance Watch Configuration Input             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD019             Date 02Jun03               *
      *                 CSD017             Date 08Nov02               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
     D CWCDDets      E DS                  EXTNAME(SDCWCMPD)
      ** Compliance Watch Configuration Data Definition File
 
     D ValidCWCD     E DS                  EXTNAME(SDCWCMPD)
     D                                     PREFIX(V)
      ** Validated Compliance Watch Configuration Data Definition File
 
     D OKCWCDDets    E DS                  EXTNAME(SDECWCMPD)
      ** Compliance Watch Configuration Data Error File
 
     D CWCDFilFmt    E DS                  EXTNAME(SDCWCDPD)
      ** Watch List Configuration Data in File Format
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD017
      ** Data Structure for Switchable Feature Details                                        CSD017
                                                                                              CSD017
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD017
      ** First DS for Access Programs, Short Data Structure                                   CSD017
                                                                                              CSD017
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index of errors
     D Idx             S              3P 0
 
     D PINKC           S              1A
     D PRTCD           S              7A
     D POption         S              7A                                                      CSD017
     D PSard           S              6A                                                      CSD017
     D CSD017          S              1A                                                      CSD017
     D CSD019          S              1A                                                      CSD019
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRRetrieve
     C                   EXSR      SRConvert
 
     C                   DOW       *INKC = *OFF
 
      ** Do while screen: Transaction Detail Screen
 
     C                   EXSR      SRDisplay
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDisplay - Process Detail Screen                             *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   CALLB     'SDCWCDDSP'
 
      ** Input Parameters :
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      ** Compliance Watch Configuration Data Definition File
     C                   PARM                    CWCDDets
      ** Compliance Watch Configuration Data Error File
     C                   PARM                    OKCWCDDets
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
      ** Entry Level WLC Indicator                                                            CSD019
     C                   PARM                    CSD019                                       CSD019
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters :
      ** Function Keys
     C                   PARM      *OFF          PINKC
 
      ** Reset errors
 
     C                   MOVE      *ALL'Y'       OKCWCDDets
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
 
      ** F3 - End program
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INKC = *ON
     C                   ELSE
 
      ** Validate input to Details Screen
 
     C                   EXSR      SRValidate
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Input to Details Screen                 *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** Validate Transaction Detail
 
     C                   EVAL      Idx  = *ZEROS
     C                   MOVE      *ALL'Y'       OKCWCDDets
 
     C                   CALLB     'SDCWCDVAL'
 
      ** Inputs
      ** Compliance Watch List Configuration Data Definition File
     C                   PARM                    CWCDDets
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
 
      ** Outputs
      ** Compliance Watch Configuration Data Error File
     C                   PARM                    OKCWCDDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Validated Compliance Watch Configuration Data Definition File
     C                   PARM                    ValidCWCD
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Clear any error messages
 
     C                   MOVE      *ALL'Y'       OKCWCDDets
 
     C                   EXSR      SRUpdate
 
     C     EndVAL@P      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve - Retrieve Transaction Details                     *
      *                                                               *
      *****************************************************************
 
     C     SRRetrieve    BEGSR
 
      ** Retrieve Transaction Details
 
     C                   CALLB     'SDCWCDRTV'
 
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
 
      ** OUTPUTS
      ** Compliance Watch Configuration Data in File Format
     C                   PARM      *BLANKS       CWCDFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Put a Transaction Detail on Screen                *
      *                                                               *
      *****************************************************************
 
     C     SRConvert     BEGSR
 
     C                   CALLB     'SDCWCDCVT'
 
      ** Input Parameters
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
      ** Compliance Watch Configuration Data in File Format
     C                   PARM                    CWCDFilFmt
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
 
      ** Output Parameters
      ** Compliance Watch Configuration Data Definition File
     C                   PARM                    CWCDDets
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update File                                        *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   CALLB     'SDCWCDUPD'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    ValidCWCD
     C                   PARM                    CSD017                                       CSD017
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates and
      ** go back to Browse screen.
 
     C                   IF        PRTCD <> *BLANKS
     C                   ROLBK
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   COMMIT
     C                   EVAL      *INKC = *ON
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen
     C
     C                   IF        PRTCD = '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'SDCWCDSIN'   DBPGM
 
      ** Clear DS parameter arrays
 
     C                   CLEAR                   CWCDFilFmt
     C                   CLEAR                   ValidCWCD
     C                   CLEAR                   CWCDDets
     C                   MOVE      *ALL'Y'       OKCWCDDets
 
      ** Check if CSD017 is installed                                                         CSD017
                                                                                              CSD017
     C                   CALLB     'AOSARDR0'                                                 CSD017
     C                   PARM      *BLANKS       PRTCD                                        CSD017
     C                   PARM      '*VERIFY'     POption                                      CSD017
     C                   PARM      'CSD017'      PSard                                        CSD017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD017
                                                                                              CSD017
      ** Database error                                                                       CSD017
                                                                                              CSD017
     C                   IF        PRTCD <> *BLANKS AND                                       CSD017
     C                             PRTCD <> '*NRF   '                                         CSD017
     C     *LOCK         IN        LDA                                                        CSD017
     C                   EVAL      DBKEY = 'CSD017'                                           CSD017
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD017
     C                   EVAL      DBASE = 900                                                CSD017
     C                   OUT       LDA                                                        CSD017
     C                   EXSR      *PSSR                                                      CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   IF        PRTCD = *BLANKS                                            CSD017
     C                   EVAL      CSD017 = 'Y'                                               CSD017
     C                   ELSE                                                                 CSD017
     C                   EVAL      CSD017 = 'N'                                               CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
      ** Check if CSD019 is installed                                                         CSD019
                                                                                              CSD019
     C                   CALLB     'AOSARDR0'                                                 CSD019
     C                   PARM      *BLANKS       PRTCD                                        CSD019
     C                   PARM      '*VERIFY'     POption                                      CSD019
     C                   PARM      'CSD019'      PSard                                        CSD019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD019
                                                                                              CSD019
      ** Database error                                                                       CSD019
                                                                                              CSD019
     C                   IF        PRTCD <> *BLANKS AND                                       CSD019
     C                             PRTCD <> '*NRF   '                                         CSD019
     C     *LOCK         IN        LDA                                                        CSD019
     C                   EVAL      DBKEY = 'CSD019'                                           CSD019
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD019
     C                   EVAL      DBASE = 901                                                CSD019
     C                   OUT       LDA                                                        CSD019
     C                   EXSR      *PSSR                                                      CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   IF        PRTCD = *BLANKS                                            CSD019
     C                   EVAL      CSD019 = 'Y'                                               CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      CSD019 = 'N'                                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
