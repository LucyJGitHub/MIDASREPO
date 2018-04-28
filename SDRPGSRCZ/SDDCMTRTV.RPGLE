     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - Retreive')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTRTV - SD Document Management Retrieve                  *
      *                                                               *
      *  Function:  This module retrieves a Document Management from  *
      *             the database. As it does so, it validates the     *
      *             action code and Document Code.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093 *CREATE     Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Document Management keyed by Customer and Code
     FSDDCMTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDCMTD0:SDDCMTXX)
 
      ** Document Management keyed by Front Office ID
     FSDDCMTL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDCMTD0:SDDCMTFO)
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS For Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS For Currency Details
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** External DS For Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS For Document Management
     D SDDCMT        E DS                  EXTNAME(SDDCMTPD)
     D                                     PREFIX(A)
 
      ** First DS For Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
      ** Document Management in File Format
     D CrDcFilFmt    E DS                  EXTNAME(SDDCMTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Transaction Id
     D DDTRNN          DS
     D   DDTRCUST                          LIKE(DDREFN)
     D   DDTRCODE                          LIKE(DDCODE)
 
     D DDSEQN          S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * Initialization
      *
     C                   EXSR      INIT
 
      ** If the mode is 'Front office transaction interface'
      ** do validation for front office transaction interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        DDACTNOK = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code
 
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N'
     C                             OR DDCODEOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   IF        SubForTRNN = 0
     C                             OR ModeofOp <> '*FRONT'
     C                   EXSR      VALACA
     C                   ENDIF
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   IF        SubForTRNN = 0
     C                             OR ModeofOp <> '*FRONT'
     C                   EXSR      VALACD
     C                   ENDIF
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'E'
     C                   IF        SubForTRNN = 0
     C                             OR ModeofOp <> '*FRONT'
     C                   EXSR      VALACE
     C                   ENDIF
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C                   IF        DDACTNOK = 'N'
     C                             OR DDCODEOK = 'N'
     C                             OR DDREFNOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C                   IF        RespMode = 'S'
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C                   IF        BJSBRC = *BLANK
     C                   EXSR      ACSSEM
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VFRNT - Validation for Front Office Transaction Interface     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ** Error if Action Code is not 'I', 'A or 'E'
      *
     C                   IF        DDACTN <> 'I'
     C                             AND DDACTN <> 'A'
     C                             AND DDACTN <> 'D'
     C                             AND DDACTN <> 'E'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIdArr(Ix)   = 'USR9357'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Error if front office transaction id is blank
 
     C                   IF        FOTRID = *BLANK
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIdArr(Ix)   = 'USR4430'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access Document Management with Front Office Transaction ID
 
     C     FOTRID        CHAIN     SDDCMTL5                           99
 
      ** If INSERT
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be present already
 
     C                   IF        *IN99 = '0'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIdArr(Ix)   = 'USR4431'
     C                   EVAL      MsgDtaArr(Ix)  = FOTRID
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not INSERT, Front Office Transaction ID must be present
 
     C                   IF        *IN99 = '1'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIdArr(Ix)   = 'USR4432'
     C                   EVAL      MsgDtaArr(Ix)  = FOTRID
     C                   GOTO      EVFRNT
     C                   END
 
     C                   ENDIF
 
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL - Validation of Action Code                              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Check action code is valid.
      *
     C                   IF        INMODE = 'E'
     C                             OR INMODE = 'D'
     C                   IF        DDACTN <> 'E'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN    '
     C                   EVAL      MsgIDArr(Ix) = 'USS0400'
     C                   END
     C                   ELSE
     C                   IF        DDACTN <> 'I'
     C                             AND DDACTN <> 'A'
     C                             AND DDACTN <> 'D'
     C                             AND DDACTN <> 'E'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN    '
     C                   EVAL      MsgIDArr(Ix) = 'USR9357'
     C                   END
     C                   END
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACI - Validation of Action Code 'I'                       *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALACI        BEGSR
 
     C                   IF        DDCODE = *BLANKS
     C                   EVAL      DDCODEOK  = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDCODE'
     C                   EVAL      MsgIDArr(Ix) = 'USS0401'
     C                   EVAL      MsgDtaArr(Ix) = DDCODE
     C                   GOTO      EVALAI
     C                   ENDIF
 
     C                   CALL      'AODOCMR2'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDCODE        PDCCD             2
     C     SDDOCM        PARM      SDDOCM        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDCODE'
     C                   EVAL      MsgIDArr(Ix) = 'USS0402'
     C                   EVAL      DDCODEOK  = 'N'
     C                   GOTO      EVALAI
     C                   ELSE
     C                   EVAL      DDCODE = ATDCCD
     C                   EVAL      DDNARR = ATDCNA
     C                   ENDIF
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACA - Validation of Action Code 'A'                       *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALACA        BEGSR
 
      ** Check that the record exists
 
     C     KDCMT         CHAIN     SDDCMTXX                           99
     C                   IF        NOT %FOUND(SDDCMTL1)
     C                   EVAL      DDCODEOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDCODE    '
     C                   EVAL      MsgIDArr(Ix) = 'USS0403'
     C                   EVAL      MsgDtaArr(Ix) = DDCODE
     C                   ENDIF
      *
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALACD - Validation of Action Code 'D'                        *
      *                                                               *
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Document code must exist
      *
     C     KDCMT         CHAIN     SDDCMTXX                           99
     C                   IF        NOT %FOUND(SDDCMTL1)
     C                   EVAL      DDCODEOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDCODE    '
     C                   EVAL      MsgIDArr(Ix) = 'USS0403'
     C                   EVAL      MsgDtaArr(Ix) = DDCODE
     C                   END
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALACE - Validation of Action Code 'E'                        *
      *                                                               *
      *****************************************************************
     C     VALACE        BEGSR
      *
      ** Document code must exist
      *
     C     KDCMT         CHAIN     SDDCMTXX                           99
     C                   IF        NOT %FOUND(SDDCMTL1)
     C                   EVAL      DDCODEOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDCODE    '
     C                   EVAL      MsgIdArr(Ix)   = 'USS0403'
     C                   EVAL      MsgDtaArr(Ix)  = DDCODE
     C                   ENDIF
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ACSSES - Access Security Checking - Single Branching         *
      *                                                               *
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      * This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   EVAL      DDACTNOK = 'N'
     C                   EVAL      DDCODEOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIdArr(Ix)   = 'USR4436'
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * ACSSEM - Access Security Checking - Multi-Branching           *
      *                                                               *
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      BRC           ZBR               3
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIdArr(Ix)   = 'RE71070'
     C                   ELSE
     C                   IF        ERR = 2
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   SELECT
     C                   WHEN      DDACTN='I'
     C                   EVAL      MsgIdArr(Ix) = 'USR4438'
     C                   WHEN      DDACTN='A'
     C                   EVAL      MsgIdArr(Ix) = 'USR4439'
     C                   WHEN      DDACTN='D'
     C                   EVAL      MsgIdArr(Ix) = 'USR4440'
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT - Initialization                                         *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   CrDcFilFmt
     C                   EVAL      DDACTNOK = 'Y'
     C                   EVAL      DDREFNOK = 'Y'
     C                   EVAL      DDCODEOK = 'Y'
     C                   EVAL      DDTRCUST = DDREFN
     C                   EVAL      DDTRCODE = DDCODE
 
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
     C                   IF        DDACTN = 'A'
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      DDTRNN        SubForTRNN        2 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ** Response mode
     C                   PARM                    RespMode          1
      *
      ** Entry Mode
     C                   PARM                    INMODE            1
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** (Midas) Customer and Currency Code
     C                   PARM                    DDREFN           10
     C                   PARM                    DDRTYP            1
     C                   PARM                    DDCODE            2
     C                   PARM                    DDSEQN
      *
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ** OUTPUTS
      *
      ** (Current) Document Code in file format
     C                   PARM                    CrDcFilFmt
      *
      ** OK - Action code
     C                   PARM                    DDACTNOK          1
      *
      ** OK - Customer
     C                   PARM                    DDREFNOK          1
      *
      ** OK - Document Code
     C                   PARM                    DDCODEOK          1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      ** Document Narrative
     C                   PARM                    DDNARR           30
 
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SDDCMTRTV'
      *
      ** Key Lists
      *
     C     KCODE         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    DDRTYP
     C                   KFLD                    DDCODE
      *
     C     KDCMT         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    DDRTYP
     C                   KFLD                    DDCODE
     C                   KFLD                    DDSEQN
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 101
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   END
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      **  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
