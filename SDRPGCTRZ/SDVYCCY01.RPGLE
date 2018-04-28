     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Currency Validation Module')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVYLDC01 - Currency Validation Module                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 219331             Date 20Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001   *CREATE   Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  219331 - Currency should be mandatory                        *
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
      *  80  - Scan field indicator                                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation                                  *
      *  SRINIT     - Initialisation Processing                       *
      *  SRVCURR    - Validate Yield Currency                         *
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
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Currency input field
     D P#0YCCY         S              3
 
      ** Yield Curve error indicator
     D PYCCYOK         S              1
 
      ** Access object parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PCURR           S              3
 
      ** Mode of operation
     D PModeOfOp       S              6
 
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
 
      ** Validate Currency Code
 
     C                   EXSR      SRVCURR
 
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
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCURR - Validate Currency Code                              *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * AOCURRR0    - Currency Details Access Object                  *
      *                                                               *
      *****************************************************************
 
     C     SRVCURR       BEGSR
 
      ** Check for '?'
 
     C     '?'           SCAN      P#0YCCY                                80
 
      ** Check if currency code entered is existing
 
     C**********         IF        (P#0YCCY <> *BLANK) AND                                    219331
     C**********                   (PModeOfOp <> '*FRONT') OR                                 219331
     C                   IF        (PModeOfOp <> '*FRONT') OR                                 219331
     C                             (PModeOfOp = '*FRONT') AND (*IN80 = *OFF)
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      P#0YCCY       PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Not found or error accessing AOCURRR0
 
     C                   IF        (PRTCD <> *BLANK) OR (A6DLCI <> 'Y')
     C                   EVAL      PYCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr2(Idx) = '#0YCCY    '
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9201'
     C                   ELSE
     C                   EVAL      P#0YCCY = PCURR
     C                   ENDIF
     C                   ENDIF
 
      ** '?' not allowed for *FRONT mode
 
     C                   IF        (PModeOfOp = '*FRONT') AND (*IN80 = *ON)
     C                   EVAL      PYCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr2(Idx) = '#0YCCY    '
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9201'
     C                   ENDIF
 
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
     C                   PARM                    PModeOfOp
     C                   PARM                    P#0YCCY
     C                   PARM                    FldNamXar2
     C                   PARM                    MsgIdXar2
     C                   PARM                    MsgDtaXar2
     C                   PARM                    SDCURR
     C                   PARM                    PYCCYOK
 
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
