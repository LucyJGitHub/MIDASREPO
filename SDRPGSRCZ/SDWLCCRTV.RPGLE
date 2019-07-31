     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list configuration retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWLCCRTV - Watch List Configuration Retrieve                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCWCDPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDWLCCL0  IF   E           K DISK    INFSR(*PSSR)
     FSDWLMTL0  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D MTYPARR         S              3A   DIM(20)
     D INEXARR         S              1A   DIM(20)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details ICD Retrieval
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D WLCCFilFmt    E DS                  EXTNAME(SDWLCCPD)
      ** Watch List Configuration in File Format
 
     D CWCDFilFmt    E DS                  EXTNAME(SDCWCDPD)
      ** Watch List Configuration Data in File Format
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
     D OKACTN          S              1A
     D OKFUNC          S              1A
     D PACTN           S              1A
     D ZACTN           S              1A
     D RespMode        S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PFUNC           S              8A
     D PINKH           S              1A
     D ZBR             S              3A
     D PERR            S              1  0
     D A               S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
     C                   IF        PINKH = *ON
     C     1             SETLL     SDCWCDPD
     C                   READ(N)   SDCWCDPD                               75
     C                   ELSE
 
      ** Validate Action Code
 
     C                   EXSR      SRVALACT
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** *-----------------------------------------------*
      ** * Access Security Checking                      *
      ** *-----------------------------------------------*
 
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN = PACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *BLANK and RespMode = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *BLANK AND PACTN <> 'I'
     C                             and RespMode = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
 
     C                   ENDIF
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   IF        PACTN = 'A'
     C                   EXSR      SRRETRIEVE
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ACSSES - Access Security Checking - Single Branching          *
      *                                                               *
      *****************************************************************
 
     C     ACSSES        BEGSR
 
      ** Check user's authority for the action
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    PERR
 
      ** If action invalid for user
 
     C                   IF        PERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     '#1ACTN'      FldNameArr(Ix)
 
     C                   IF        PACTN = 'A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ACSSEM - Access Security Checking - Multi-Branching           *
      *                                                               *
      *****************************************************************
 
     C     ACSSEM        BEGSR
 
      ** Check user's authority for the action & Booking Branch
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      BRC           ZBR
     C                   PARM                    PERR
 
      ** If action invalid for user
 
     C                   IF        PERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     '#1ACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        PERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     '#1ACTN'      FldNameArr(Ix)
     C                   IF        PACTN = 'A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRETRIEVE - Retrieve Watch List Configuration Details        *
      *                                                               *
      *****************************************************************
 
     C     SRRETRIEVE    BEGSR
 
     C     PFUNC         CHAIN     SDWLCCL0                           75
 
      ** Function Code not found
 
     C                   IF        *IN75 = *ON
     C                   MOVEL     'N'           OKFUNC
     C                   ADD       1             Ix
     C                   MOVEL     '#1FUNC'      FldNameArr(Ix)
     C                   MOVEL     'USR9610'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     *LOVAL        SETLL     SDWLMTL0
     C                   READ      SDWLMTL0                               75
 
     C                   EVAL      A = 1
 
     C                   DOW       *IN75 = *OFF
     C                   EVAL      MTYPARR(A) = W2MTYP
     C                   EVAL      INEXARR(A) = W2INEX
     C                   EVAL      A = A + 1
     C                   READ      SDWLMTL0                               75
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALACT - Validation of Action Code                          *
      *                                                               *
      *****************************************************************
 
     C     SRVALACT      BEGSR
 
      ** Action Code must be 'A'
 
     C                   IF        PACTN <> 'A'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     '#1ACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR9640'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Clear outputs
 
     C                   CLEAR                   WLCCFilFmt
     C                   CLEAR                   CWCDFilFmt
     C                   EVAL      OKACTN = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Response Mode
     C                   PARM                    RespMode
      ** Action Code
     C                   PARM                    PACTN
      ** Function Code
     C                   PARM                    PFUNC
      ** F8 Key
     C                   PARM                    PINKH
 
      ** Outputs
      ** Watch List Configuration in File Format
     C                   PARM                    WLCCFilFmt
      ** Watch List Configuration Data in File Format
     C                   PARM                    CWCDFilFmt
      ** Message Type
     C                   PARM                    MTYPARR
      ** Include/Exclude Indicator
     C                   PARM                    INEXARR
      ** OK - Action Code
     C                   PARM                    OKACTN
      ** OK - Function Code
     C                   PARM                    OKFUNC
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDWLCCRTV'
 
      ** Get ZMUSER to access default branch
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
