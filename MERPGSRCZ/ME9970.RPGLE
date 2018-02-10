     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Midas Msg Mgr Control Info')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/ME9970  - Midas Message Manager Control Info           *
      *                                                               *
      *  Function:  This module configures the static data that       *
      *              described the Midas / Midas Message Manager.     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG7413  *CREATE   Date 02Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG7413 - ICD Midas Message Manager ends in error            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      *    21         Meridian link database name field               *
      *    22         Meridian server name field                      *
      *    23         Managing midas system field                     *
      *    24         Display indicator for S/W library and           *
      *                 CAS library fields                            *
      *    25         S/W library field                               *
      *    26         CAS library field                               *
      *    35         Message subfile                                 *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRREFR        -  Refresh fields                              *
      *  SRVALD        -  Validate field entries                      *
      *  SREXIT        -  Exit from the module                        *
      *  SRUPARM       -  Update MESTAT data area                     *
      *  SRERROR       -  Handles error messages                      *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
 
     FME9970DF  CF   E             WORKSTN INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
      ** Midas ME Message Management attributes layout
     D MESTAT        E DS           256    EXTNAME(MESTAT) DTAARA(MESTAT)
 
      ** Array Message IDs
     D ArrMsgIds       S              7    DIM(25)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Parameters for AOCREPT
     D PMsgID          S              7
     D PMsgFile        S             10
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
 
      **  Parameters for MEC2110
     D PMldbName       S             10
     D PMdnSvrNam      S             10
     D PMgnSys         S              1
     D PMeridLib       S             10
     D PMdl2CasLib     S             10
 
     D WRun            S              1
     D WValid          S              1
     D WCtr            S              2S 0
     D WExtFlg         S              1
 
      ** Index of errors
     D Idx             S              2S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
     C                   Dow       *INKC = *Off  and WVALID = 'N'
 
     C                   WRITE     #MSGCTL
     C                   WRITE     ME9970F0
     C                   WRITE     ME9970H0
     C                   EXFMT     ME9970D0
 
     C                   CALL      'ZA0250'
     C                   EVAL      Idx = 0
     C                   RESET                   ArrMsgIds
     C                   MOVEA     '000'         *IN(21)
     C                   MOVEA     '00'          *IN(25)
 
      ** If F5(Refresh) is pressed
 
     C                   IF        *INKE = *ON
     C                   EXSR      SRREFR
     C                   ITER
     C                   ENDIF
 
      ** Validate entry fields
 
     C                   EXSR      SRVALD
 
     C                   ENDDO
 
      ** End of module
 
     C                   EXSR      SREXIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREFR  - Refresh Fields                                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRREFR        BEGSR
 
      ** Retrieve details of data area MESTAT and update display fields
 
     C                   IN        MESTAT
     C                   EVAL      #0LKDB      = MDNLNKDB
     C                   EVAL      #0SVNM      = MRDSVRNAME
     C                   EVAL      #0MSYS      = MNGMIDSYS
     C                   EVAL      #0MLIB      = MERIDLIB
     C                   EVAL      #0MCAS      = MDL2CASLIB
 
     C                   If        MNGMIDSYS = 'Y'
     C                   EVAL      #0MSYS = '*YES'
     C                   Else
     C                   EVAL      #0MSYS = '*NO '
     C                   Endif
     C                   EVAL      *IN24 = *Off
     C                   EVAL      WVALID= 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD  - Validate Fields                                    *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : SRERROR, SRUPARM                                  *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
     C                   EVAL      WExtFlg= 'Y'
 
      ** Meridian Link Database Name must not be blanks
 
     C                   If        #0LKDB = *Blanks
     C                   EVAL      *IN21 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'MEC2301'
     C                   Endif
 
      ** Meridian Server Name must not be blanks
 
     C                   If        #0SVNM = *Blanks
     C                   EVAL      *IN22 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'MEC2302'
     C                   Endif
 
     C                   Select
 
      ** If Managing Midas system = blanks, change its' value to '*YES'
 
     C                   When      #0MSYS = '    '
     C                   EVAL      #0MSYS = '*YES'
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WExtFlg = 'N'
 
      ** Valid value for Managing Midas system is either '*YES' or '*NO '
 
     C                   When      #0MSYS <> '*YES' AND #0MSYS <> '*NO '
     C                   EVAL      *IN23 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'MEC2303'
 
      ** If Managing Midas sytem = '*NO ', managing s/w library & link to CAS library WON'T
      ** be displayed
 
     C                   When      #0MSYS =  '*NO '
     C                   If        *IN24 = *ON
     C                   EVAL      WExtFlg = 'N'
     C                   Endif
     C                   EVAL      *IN24 = *Off
 
      ** If Managing Midas sytem = '*YES', managing s/w library & link to CAS
      ** library fields SHOULD be displayed
 
     C                   When      #0MSYS = '*YES'
     C                   If        *IN24 = *ON
     C                   EVAL      WExtFlg = 'Y'
     C                   Else
     C                   EVAL      WExtFlg = 'N'
     C                   Endif
     C                   If        #0MLIB = *BLANKS  or #0MCAS = *BLANKS
     C                   EVAL      WExtFlg = 'N'
     C                   Endif
     C                   EVAL      *IN24 = *ON
 
     C                   Endsl
 
      ** If Managing s/w library = blanks, default = 'MERIDIAN  '
 
     C                   If        #0MLIB  = *BLANKS
     C                   EVAL      #0MLIB  = 'MERIDIAN  '
     C                   Endif
 
      ** If Link to CAS library = blanks, default = 'MDL2CAS   '
 
     C                   If        #0MCAS  = *BLANKS
     C                   EVAL      #0MCAS  = 'MDL2CAS   '
     C                   Endif
 
     C                   If        ArrMsgIds(1) <> *BLANKS
     C                   EXSR      SRERROR
 
     C                   Else
 
     C                   If        WExtFlg = 'N'
 
      ** To display Meridian managing s/w library & Link to CAS library fields
      ** and not exit from the module
 
     C                   EVAL      WValid = 'N'
     C                   Else
     C                   EVAL      WValid = 'Y'
     C                   Endif
 
     C                   If        *INKC = *Off
     C                   EXSR      SRUPARM
     C                   Endif
     C                   Endif
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREXIT  - Exit from the module                               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SREXIT        BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPARM - Update MESTAT data area                            *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : MEC2110                                           *
      *                                                               *
      *****************************************************************
 
     C     SRUPARM       BEGSR
 
      **  Call MEC2110 - Update MESTAT data area
 
     C                   If        #0MSYS = '*YES'
     C                   EVAL      PMgnSys = 'Y'
     C                   Else
     C                   EVAL      PMgnSys = 'N'
     C                   Endif
 
     C                   CALL      'MEC2110'
     C                   PARM      #0LKDB        PMldbName
     C                   PARM      #0SVNM        PMdnSvrNam
     C                   PARM                    PMgnSys
     C                   PARM      #0MLIB        PMeridLib
     C                   PARM      #0MCAS        PMdl2CasLib
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERROR - Handles error messages                             *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : AOCREPT                                           *
      *                                                               *
      *****************************************************************
 
     C     SRERROR       BEGSR
 
     C                   EVAL      WValid = 'N'
     C                   EVAL      WCtr = 1
 
     C                   DOW       ArrMsgIds(WCtr) <> *BLANKS
     C                   EVAL      PMsgID = ArrMsgIds(WCtr)
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR   : Init Processing                                   *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0                                          *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = *BLANKS
     C                   EVAL      DBPGM  = 'ME9970'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBASE  = *ZERO
     C                   OUT       LDA
 
      ** Retrieve details of data area MESTAT and update display fields
 
     C                   IN        MESTAT
     C                   EVAL      #0LKDB      = MDNLNKDB
     C                   EVAL      #0SVNM      = MRDSVRNAME
     C                   EVAL      #0MSYS      = MNGMIDSYS
     C                   EVAL      #0MLIB      = MERIDLIB
     C                   EVAL      #0MCAS      = MDL2CASLIB
     C
 
      ** Move user and workstation ID to screen fields.
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WID  = PsJobName
     C                   EVAL      #0PGM  = PsProcName
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      **Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   If        MNGMIDSYS = 'Y'
     C                   EVAL      #0MSYS = '*YES'
     C                   Else
     C                   EVAL      #0MSYS = '*NO '
     C                   Endif
 
     C                   EVAL      *IN24 = *Off
 
      ** If Managing s/w library = blanks, default = 'MERIDIAN  '
 
     C                   If        #0MLIB  = *BLANKS
     C                   EVAL      #0MLIB  = 'MERIDIAN  '
     C                   Endif
 
      ** If Link to CAS library = blanks, default = 'MDL2CAS   '
 
     C                   If        #0MCAS  = *BLANKS
     C                   EVAL      #0MCAS  = 'MDL2CAS   '
     C                   Endif
 
     C                   EVAL      PMsgFile = 'GBMEMSG'
     C                   EVAL      WValid = 'N'
 
     C                   EVAL      #0PGM = PsProcName
 
      ** Initialize error indicators
 
     C                   MOVEA     '000'         *IN(21)
     C                   MOVEA     '00'          *IN(25)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls    : DBERRCTL                                          *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
