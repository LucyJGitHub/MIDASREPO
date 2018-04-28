     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Period from Spot Days Validation Module')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVPDDY01 - Period from Spot Days Validation Module          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  None                                                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation                                  *
      *  SRINIT     - Initialisation Processing                       *
      *  SRVPDDY    - Validate Period Days                            *
      *  *PSSR      - DB Error Processing                             *
      *                                                               *
      *****************************************************************
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARR1
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Period Days
     D PerDay          S              2
 
      ** Period Days (Numeric)
     D PerNDay         S              2  0
 
      ** OK Flag of Period Days
     D PDyOK           S              1
 
      ** Other work fields/index/parameters
     D A               S              4  0
     D WElementN       S              2
     D WErrFld         S             10
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
     D PZFIELD         S             16
     D PZALIGNOK       S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation Processing
 
     C                   EXSR      SRINIT
 
      ** Validate Period Days
 
     C                   EXSR      SRVPDDY
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT  - Initialisation Processing                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialize error work fields and arrays
 
     C                   EVAL      RetCodeIn =  *BLANK
     C                   EVAL      FldNamXar2 =  *BLANK
     C                   EVAL      MsgIdXar2 =  *BLANK
     C                   EVAL      MsgDtaXar2 =  *BLANK
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
 
     C                   EVAL      PerNDay = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVPDDY   - Validate Period Days                              *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SRSETERRFLD - Setup Error Field                               *
      * ZALIGN      - Align Numeric Screen Field                      *
      *                                                               *
      *****************************************************************
 
     C     SRVPDDY       BEGSR
 
      ** Validate Spot Days
 
     C                   EVAL      PZFIELD = *BLANK
 
   71C                   CALLB     'ZALIGN'
   71C                   PARM      *BLANK        PZALIGNOK
   71C                   PARM      PerDay        PZFIELD
   71C                   PARM      0             PZADEC
   71C                   PARM      2             PZADIG
   71
   72 ** Valid entry
   72
   72C                   IF        (PZALIGNOK = 'Y') AND (PerDay <> '. ')
   72C                             AND (PerDay <> ' .')
   72C                   MOVE      PZFIELD       PerNDay
   72C                   MOVE      PZFIELD       PerDay
   72
   72 ** Negative entry not valid
   72
   72C                   IF        PerNDay < 0
   73C                   EVAL      PDyOK = 'N'
   73C                   EVAL      Idx = Idx + 1
   73C                   EVAL      WErrFld = '#0PDDY    '
   73C                   EXSR      SRSETERRFLD
   73C                   EVAL      FldNamXAr2(Idx) = WErrFld
   73C                   EVAL      MsgIdXAr2(Idx) = 'USR9210'
   73C                   ENDIF
   73C                   ELSE
   73
   73 ** Error calling ZALIGN or invalid Days
   74
   74C                   EVAL      PDyOK = 'N'
   74C                   EVAL      Idx = Idx + 1
   74C                   EVAL      WErrFld = '#0PDDY    '
   74C                   EXSR      SRSETERRFLD
   74C                   EVAL      FldNamXAr2(Idx) = WErrFld
   74C                   EVAL      MsgIdXAr2(Idx) = 'USR9210'
   74C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETERRFLD - Set up error field                              *
      *                                                               *
      * Called By : SRVPDDY subroutine                                *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETERRFLD   BEGSR
 
      ** Add Element number
 
     C                   MOVE      A             WElementN
     C                   EVAL      WErrFld = %Trim(WErrFld) + WElementN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By : Called automatically upon module execution        *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    A
     C                   PARM                    PerDay
     C                   PARM                    PerNDay
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIDXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    PDyOK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
