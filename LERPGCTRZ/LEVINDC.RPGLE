     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Indicators')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVINDC - Validate Indicators                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. 263415             Date 01Aug12               *
      *  Prev Amend No. CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  263415 - Impossible to manually create PDCL for Interest only*
      *         - Separate Indicator should be blank for Fee PDCLs    *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others)
      ** the LDA layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **
 
      **
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **
 
      ** The following /COPY line includes all the defined fields
      ** in the  Program Status Data Structures.
      ** They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant
      ** giving the size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ** Parameters
     D DDCAPI          S              1
     D DDDEPI          S              1
     D DDSEIN          S              1
     D DDORLN          S              6
     D AUTO            S              1
     D NCAPI           S              1
     D NDEPI           S              1
     D NSEIN           S              1
     D DDCAPIOK        S              1
     D DDDEPIOK        S              1
     D DDSEINOK        S              1
      *
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
 
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
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANKS       NCAPI
     C                   MOVE      *BLANKS       NDEPI
     C                   MOVE      *BLANKS       NSEIN
      *
      ** VALIDATION
      *
      ** Indicator: Capitalised Interest Indicator
      *
      ** Can only be entered if a Loan PDCL
      *
     C                   IF        RecordType = Loan
      *
      ** Default to N if not entered
      *
     C                   IF        DDCAPI = *BLANKS
     C                   EVAL      DDCAPI = 'N'
     C                   ENDIF
      *
      ** Can only be Y or N
      *
     C                   IF        DDCAPI <> 'Y'
     C                             AND DDCAPI <> 'N'
     C                   EVAL      DDCAPIOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045605'
     C                   ENDIF
      *
      ** If OK, move value into position
      *
     C                   IF        DDCAPIOK = 'Y'
     C                   EVAL      NCAPI = DDCAPI
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Should be empty if not a Loan
      *
     C                   IF        DDCAPI <> *BLANKS
     C                   EVAL      DDCAPIOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045606'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Indicator: Decreased Principal Indicator
      *
      ** Can only be entered if a Loan PDCL
      *
     C                   IF        RecordType = Loan
     C
      *
      ** Default to Y if not entered
      *
     C                   IF        COBMode <> 'Y'
     C                   IF        DDDEPI = *BLANKS
     C                   EVAL      DDDEPI = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDDEPI = 'N'
     C                   ENDIF
      *
      ** Can only be Y or N
      *
     C                   IF        DDDEPI <> 'Y'
     C                             AND DDDEPI <> 'N'
     C                   EVAL      DDDEPIOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDEPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045607'
     C                   ENDIF
      *
      ** If original loan is AUTO = Y, DEPI must be N
      *
     C                   IF        DDDEPI <> 'N'
     C                             AND AUTO = 'Y'
     C                   EVAL      DDDEPIOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDEPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045608'
     C                   ENDIF
      *
      ** If original loan is AUTO = N, DEPI must be Y
      *
     C                   IF        DDDEPI = 'N'
     C                             AND AUTO = 'N'
     C                   EVAL      DDDEPIOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDEPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045638'
     C                   ENDIF
      *
      ** If OK, move value into position
      *
     C                   IF        DDDEPIOK = 'Y'
     C                   EVAL      NDEPI = DDDEPI
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDDEPI <> *BLANKS
      *
     C                   EVAL      DDDEPIOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDEPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045625'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Indicator: Separate Indicator
      *
      ** Can only be entered if a Loan PDCL                                                   263415
      *
     C                   IF        RecordType = Loan                                          263415
      *                                                                                       263415
     C                   IF        DDSEIN = *BLANKS
     C                   EVAL      DDSEIN = 'N'
     C                   ENDIF
      *
     C                   IF        DDSEIN <> 'Y'
     C                             AND DDSEIN <> 'N'
     C                   EVAL      DDSEINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSEIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045609'
     C                   ELSE
     C                   EVAL      NSEIN = DDSEIN
     C                   ENDIF
      *                                                                                       263415
     C                   ELSE                                                                 263415
      *                                                                                       263415
     C                   IF        DDSEIN <> *BLANKS                                          263415
      *                                                                                       263415
     C                   EVAL      DDSEINOK = 'N'                                             263415
     C                   EVAL      Idx += 1                                                   263415
     C                   EVAL      FldNamXAr(Idx) = 'DDSEIN'                                  263415
     C                   EVAL      MsgIdXAr(Idx) = '5045652'                                  263415
      *                                                                                       263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
     C                   ENDIF                                                                263415
      *
     C     EMAIN         TAG
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
     C                   PARM                    DDCAPI
     C                   PARM                    DDDEPI
     C                   PARM                    DDSEIN
     C                   PARM                    DDORLN
     C                   PARM                    AUTO
     C                   PARM                    RecordType
     C                   PARM                    COBMode           1
      *
      ** OUTPUTS
      *
     C                   PARM                    NCAPI
     C                   PARM                    NDEPI
     C                   PARM                    NSEIN
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK values
      *
     C                   PARM                    DDCAPIOK
     C                   PARM                    DDDEPIOK
     C                   PARM                    DDSEINOK
      *
      ** Program, module and procedure names for DB Error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
