     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNRTV - Data Replication Configurator Retrieve           *
      *                                                               *
      *  Function:  This module retrieves a record from the database. *
      *             As it does so, it validates the action code and   *
      *             Physical File Name.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data Replication File Definiton Retrieval Index
     FSCFDTLL1  IF   E           K DISK    INFSR(*PSSR) USROPN
 
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
 
      ** Transaction Details in File Format
     D RepFilFmt     E DS                  EXTNAME(SCFDTLPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
     D #1ACTN          S              1
     D #1PHYF          S             10
 
     D OKACTN          S              1
     D OKPHYF          S              1
 
     D PRetCode        S              7
     D POption         S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Validate Action Code & Physical File Name
 
     C                   EXSR      SRValidate
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' OR
     C                             OKPHYF = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Validation for Action Code 'I'
 
     C                   IF        #1ACTN = 'I'
     C                   EXSR      SRValIns
     C                   ENDIF
 
      ** Validation for Action Code 'A' or 'D'
 
     C                   IF        #1ACTN = 'A' or #1ACTN = 'D' or #1ACTN = 'E'
     C                   EXSR      SRRetrieve
     C                   ENDIF
 
      **  Carry out no further validation if errors occurred.
 
     C                   IF        OKACTN = 'N' OR
     C                             OKPHYF = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetrieve - Retrieve Data Replication Details               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C                   OPEN      SCFDTLL1
 
      ** Check if physical file exists on the system
 
     C                   IF        #1PhyF <> *Blanks
     C     #1PhyF        CHAIN     SCFDTLL1                           01
 
      ** Replication details not found
 
     C                   IF        *IN01 = *ON
     C                   EVAL      OKPhyF = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1PHYF'
     C                   EVAL      MsgIdArr(Ix) = 'DRC0005'
     C                   ENDIF
     C                   ENDIF
 
     C                   CLOSE     SCFDTLL1
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validation of Action Code                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Action Code must be 'A', 'D', 'E' or 'I'
 
     C                   IF        #1ACTN <> 'A' and #1ACTN <> 'D' and
     C                             #1ACTN <> 'I' and #1ACTN <> 'E'
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'DRC0006'
 
     C                   ELSE
 
      ** Physical File Name required
 
     C                   IF        #1PHYF = *Blanks and #1ACTN <> *Blanks
     C                   EVAL      OKPhyF = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1PHYF'
     C                   EVAL      MsgIdArr(Ix) = 'DRC0007'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValIns - Validation for Action code 'I'                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRValIns      BEGSR
 
     C                   OPEN      SCFDTLL1
 
      ** Access Data Replication file
 
     C     #1PHYF        CHAIN     SCFDTLL1                           01
 
      ** Error if present already
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      OKPHYF = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     '#1PHYF'      FldNameArr(Ix)
     C                   MOVEL     'DRC0008'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   CLOSE     SCFDTLL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInit - Initialization                                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   RepFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKPHYF = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Action Code
 
     C                   PARM                    #1ACTN
 
      ** Physical File Name
 
     C                   PARM                    #1PHYF
 
      ** OUTPUTS
      ** Replication Details in File Format
 
     C                   PARM                    RepFilFmt
 
      ** OK - Action code
 
     C                   PARM                    OKACTN
 
      ** OK - Physical File
 
     C                   PARM                    OKPHYF
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SCRPCNRTV'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
