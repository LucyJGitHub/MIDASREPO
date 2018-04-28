     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Validate physical file to be replicated')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCVPHYF - Validate Physical File to be Replicated            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC018             Date 10Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC018 - Recompile over extended SCNJRNL0 file.              *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Replication File (Retrieval Index)
     FSCFDTLL1  IF   E           K DISK    USROPN
 
      ** Midas Not to be journalled files
     FSCNJRNL0  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data Replication Error Indicator File
     D OKFlags       E DS                  EXTNAME(SCERPCNPD)
 
      ** New Data Replication in File Format
     D NwRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
     D                                     PREFIX(NW:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indexes for Error and Warning arrays
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D P_PhyFile       S             10A
     D P_ActCode       S              1A
     D W_RtnCd3A       S              3A
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANKS       RetCodeIn
     C                   MOVE      *BLANKS       FldNamXAr
     C                   MOVE      *BLANKS       MsgIDXAr
     C                   MOVE      *BLANKS       MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   EVAL      NWPHYF = *BLANKS
 
      ** Validate Physical File to be Replicated field
 
     C                   EXSR      SR_PhyFile
 
      ** If an error has occurred, set return code
 
     C                   IF        OKPHYF = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   EVAL      NWPHYF = P_PhyFile
 
      ** Return to calling program
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR_PhyFile - Validate Physical File to be Replicated field   *
      *                                                               *
      *****************************************************************
     C     SR_PhyFile    BEGSR
 
      ** For Inserts, PF should not already exist in the main file
 
     C                   IF        P_ActCode = 'I'
     C                   OPEN      SCFDTLL1
     C     P_PhyFile     CHAIN     SCFDTLL1                           80
     C                   IF        *IN80 = *OFF
     C                   EVAL      OKPHYF = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1PHYF'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0008'
     C                   ENDIF
     C                   CLOSE     SCFDTLL1
     C                   ENDIF
 
      ** For Inserts and Amends,
 
     C                   IF        P_ActCode = 'I' OR P_ActCode = 'A'
     C                   CALL      'SCC000920'
     C                   PARM                    P_PhyFile
     C                   PARM                    W_RtnCd3A
 
      ** Error: File does not exist in the 'main' system
 
     C                   IF        W_RtnCd3A = 'EOF'
     C                   EVAL      OKPHYF = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1PHYF'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0015'
     C                   ENDIF
 
      ** Error: File is not in DMLIB
 
     C                   IF        W_RtnCd3A = 'LIB'
     C                   EVAL      OKPHYF = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1PHYF'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0017'
     C                   ENDIF
 
      ** Error: File type is not Physical
 
     C                   IF        W_RtnCd3A = 'TYP'
     C                   EVAL      OKPHYF = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1PHYF'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0016'
     C                   ENDIF
 
      ** Error
 
     C                   IF        W_RtnCd3A = 'ERR'
     C                   EVAL      DBFILE = 'SCFDBRPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = P_PhyFile
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Physical file name must not exist in LF/SCNJRNL0
 
     C     P_Phyfile     CHAIN     SCNJRNL0                           01
     C                   IF        *IN01 = *Off
     C                   EVAL      OKPHYF = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1PHYF'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0017'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** ------
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Field requiring validation: Physical File to be Replicated
 
     C                   PARM                    P_PhyFile
 
      ** Action Code
 
     C                   PARM                    P_ActCode
 
      ** OUTPUTS
      ** -------
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** OK Flag: Physical File to be Replicated
 
     C                   PARM                    OKFlags
 
      ** Output: Data Replication Details in File Format
 
     C                   PARM                    NwRepFilFmt
 
      ** Program, module and procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
