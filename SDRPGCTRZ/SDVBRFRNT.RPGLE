     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Base Rate Front Office Id')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVBRFRNT - Validate Base Rate Front Office Id               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP038             Date 15May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP038 - Conversion of BASE Rates into Modular APIs          *
      *                                                               *
      *****************************************************************
      ** Base Rate by front office id
     FSDBSRFL0  IF   E           K DISK    INFSR(*PSSR)
 
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
 
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
 
     C                   MOVEL     *BLANK        BVFRNT
     C                   EXSR      VFRNT
 
      *
      ** If an error was found, set the return code appropriately
      *
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Base Rate Front Office Id
      *****************************************************************
     C     VFRNT         BEGSR
     C                   IF        DDFRNT <> *BLANK
     C     DDFRNT        CHAIN     SDBSRFL0
     C                   IF        %FOUND
     C                   IF        DDCYCD <> BACYCD OR
     C                             DDBSRC <> BABSRC
     C                   EVAL      DDFRNTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFRNT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR4452'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   MOVEL     DDFRNT        BVFRNT
     C                   ENDIF
 
     C                   ELSE                                                                 CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   EVAL      DDFRNTOK = 'N'                                             CSC011
     C                   EVAL      Idx = Idx + 1                                              CSC011
     C                   EVAL      FldNamXAr(Idx) = 'DDFRNT    '                              CSC011
     C                   EVAL      MsgIdXAr(Idx) = 'USR4455'                                  CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
 
     C                   ENDSR
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
      ** Front Office Id (MDF id)
     C                   PARM                    DDFRNT           20
      ** Currency code
     C                   PARM                    DDCYCD            3
      ** Base rate code
     C                   PARM                    DDBSRC            2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Front Office Id (MDF id)
     C                   PARM                    BVFRNT           20
      ** Front Office Id (MDF Id)
     C                   PARM                    DDFRNTOK          1
     C                   PARM                    CSC011                                       CSC011
 
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
