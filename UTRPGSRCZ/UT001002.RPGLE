     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Exceptions File - duplicate error codes')     *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT001002 - Midas UT Exceptions File - duplicate error codes  *
      *                                                               *
      *  Function:  This program will identify all records whose      *
      *             error ID is used in multiple message files and    *
      *             write it UTEREXPD (Input Cycle)                   *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Error Messages Usage Stack Generation Exceptions File
     FUTEREXPD  UF A E           K DISK    PREFIX(EX_)
 
      ** Midas UT Error Codes/Messages Files List - keyed by DMMIDR
     FUTERCDL0  IF   E           K DISK    PREFIX(ER_)
 
      ** UTERCDPD - ordered by DMMIDR (message ID)
     FV_UTERCF0 IF   E           K DISK    RENAME(V_UTERCF0:UTERCF0)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Dummy data structure - short DS     DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WFLG            S              1A
     D wMSGID          S              7A
     D w2MSGID         S              7A
 
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
 
      ** Read all records in file
 
     C                   EXSR      SRPROC
 
      ** Return to calling program
 
     C                   EXSR      SREXIT
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROC - checks for error code that is being used by multiple *
      *          message files                                        *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      WFLG = ' '
 
     C                   READ      UTERCF0                                87
     C                   DOW       *IN87 = *OFF
 
     C                   IF        wMSGID = DMMIDR
 
     C                   IF        W2MSGID <> DMMIDR
     C                   EVAL      WFLG = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   EVAL      wMSGID = DMMIDR
 
     C                   IF        WFLG = 'Y'
     C                   EXSR      SRWRITE
     C                   EVAL      WFLG = ' '
     C                   EVAL      W2MSGID = WMSGID
     C                   ENDIF
 
     C                   READ      UTERCF0                                87
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      * SRWRITE - logs error codes with multiple occurance to excption*
      *           file UTEREXPD                                       *
      *****************************************************************
     C     SRWRITE       BEGSR
 
     C     WMSGID        SETLL     UTERCDL0
     C     WMSGID        READE     UTERCDL0                               88
 
     C                   DOW       *IN88 = *OFF
 
     C                   IF        ER_DMMIDR = WMSGID
     C                   EVAL      EX_EXERRC = ER_DMMIDR
     C                   EVAL      EX_EXMSGF = ER_DMFILE
     C                   EVAL      EX_EXEXCP = ER_DMMSGT
     C                   WRITE     UTEREXF
     C                   ENDIF
 
     C     WMSGID        READE     UTERCDL0                               88
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREXIT - return to calling program                            *
      *****************************************************************
     C     SREXIT        BEGSR
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'UT01002'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Clear variables
 
     C                   EVAL      WMSGID = ' '
     C                   EVAL      W2MSGID = ' '
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
