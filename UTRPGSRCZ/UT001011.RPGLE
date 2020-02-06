     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Service Program References')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT001011 - Midas UT Service Program References               *
      *                                                               *
      *  Function:  This program will merge module/bound program      *
      *             references to the prgram references file          *
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
 
      ** UTMREFPD Module References File
     FV_UTMREF1 IF   E             DISK    RENAME(V_UTMREF1:UTMREF1)
 
      ** Program References File
     FUTPREFPD  UF A E             DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      ** Dummy data structure - short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      *  | End of D-specs                       |
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
      ** SRPROC - write all record with WHPNAM = *VARIABLE to         *
      **          exceptions file UTEREXPD                            *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C     1             SETLL     UTMREF1
     C                   READ      UTMREF1                                97
     C                   DOW       *IN97 = *OFF
 
     C                   MOVE      *BLANKS       WHPNAM
     C                   MOVE      *BLANKS       WHFNAM
     C                   MOVE      *BLANKS       WHOBJT
     C                   MOVE      *BLANKS       WHOTYP
     C                   MOVE      *BLANKS       WHSPKG
 
     C                   EVAL      WHPNAM = IMMONM
     C                   EVAL      WHFNAM = %SUBST(IMSYNM:1:10)
     C                   EVAL      WHOBJT = 'P'
     C                   EVAL      WHOTYP = '*PGM'
     C                   EVAL      WHSPKG = 'M'
 
     C                   WRITE     QWHDRPPR
 
     C                   READ      UTMREF1                                97
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SREXIT - return to calling program
      *****************************************************************
     C     SREXIT        BEGSR
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'UT001011'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
