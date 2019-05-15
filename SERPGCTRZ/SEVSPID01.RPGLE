     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Sec Price MDF indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVSPID01 - Validate Sec Price ID                            *
      *                                                               *
      *    This optional, free format text uniquely identifies        *
      *    the sec price as used by the data source for requests      *
      *    sent to the Market data feed application                   *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 12Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP060 - Midas APIs, Security Prices Full API                *
      *                                                               *
      *****************************************************************
 
     FSECTYL5   IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Switchable features description                                                      CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** Dummy data structure                                                                 CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Entry Parameters for AOSARDR0                                                        CSC011
     D PRetCode        S              7A                                                      CSC011
     D POption         S              7A                                                      CSC011
     D PKey            S              6A                                                      CSC011
 
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
      *
      * Initialise output fields
 
     C                   MOVEL     *BLANK        SPID
 
      * Validate Sec Price Id
      * =====================
 
      * Validate only if entered (not mandatory)
      ** This field will be mandatory if CSC011 is installed                                  CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   EXSR      SRValSPID                                                  CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        DDSPID <> *BLANKS
     C                   EXSR      SPIDval
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDSPIDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      * RETURN
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SPIDval  - Sec Price Id validation
      *****************************************************************
     C     SPIDval       BEGSR
      *
      * If action code is insert the ID must not already exist of file SECTYD
      *
     C                   IF        DDACTN = 'I'
     C     DDSPID        CHAIN     SECTYL5
     C                   IF        %FOUND(SECTYL5)
     C                   MOVE      'N'           DDSPIDOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDSPID'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0445'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
      *
      * If action code is amend the ID must not already exist in file SECTYD for another security
      *
     C                   IF        DDACTN = 'A'
     C     DDSPID        CHAIN     SECTYL5
     C                   IF        %FOUND(SECTYL5) AND DDSESN <> SESN
     C                   MOVE      'N'           DDSPIDOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDSPID'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0445'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDSPIDOK = 'Y'
     C                   EVAL      SPID = DDSPID
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      *  SRValSPID - Validate Security Price ID                       *                       CSC011
      *                                                               *                       CSC011
      *  Called by: Main Processing                                   *                       CSC011
      *                                                               *                       CSC011
      *  Calls:     None                                              *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
     C     SRValSPID     BEGSR                                                                CSC011
                                                                                              CSC011
     C                   IF        DDSPID = *Blanks                                           CSC011
     C                   MOVE      'N'           DDSPIDOk                                     CSC011
     C                   ADD       1             Idx                                          CSC011
     C                   MOVEL     'DDSPID'      FldNamXAr(Idx)                               CSC011
     C                   MOVEL     'SEA0447'     MsgIDXAr(Idx)                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Security Shortname
     C                   PARM                    DDSESN           10
      ** Security Price Id
     C                   PARM                    DDSPID           20
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Security Price ID
     C                   PARM                    SPID             20
      ** Security Price Id OK flag
     C                   PARM                    DDSPIDOK          1
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRetCode                                     CSC011
     C                   PARM      '*VERIFY'     POption                                      CSC011
     C                   PARM      'CSC011'      PKey                                         CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRetCode = *Blanks                                         CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        PRetCode <> '*NRF   '                                      CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 1                                                 CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
