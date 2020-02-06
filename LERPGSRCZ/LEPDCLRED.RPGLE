     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Read')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEPDCLR - Past Due Call Loan Conversion: retrieve a record   *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUED0:TrnPDUE)
 
      ** Past Due & Original Loan Link File Format
 
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUFD0:TrnPDUF)
 
      ** Past Due & Original Fees Link File Format
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
 
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the standard API declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for bank details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DDACTN          S              1A
 
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D @ERRMS          S              7A
 
     D @KYRED          DS
     D  @ORLN                         6
     D  @FECU                         6
     D  @FFAC                         5  0
     D  @FSEQ                         2  0
     D  @FLNO                         6
 
     D @FTRED          S             20A
 
     D ZACTN           S              1A
     D @@ERR           S              1P 0
 
      ** Additional Field Definitions
     D DDORLN          S              6
     D DDFECU          S              6
     D DDFFAC          S              5
     D DDFSEQ          S              2
     D DDFLNO          S              6
     D DDORLNn         S              6
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
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
 
      ** Initial processing is performed automatically: *INZSR is
      ** executed at program activation.
 
      ** Initialise outputs
 
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @KYRED = *BLANK
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      ** Read forwards
 
     C                   IF        @RDFWD = 'Y'
 
     C                   IF        DDFECU = *BLANKS
     C                             and DDFFAC = *BLANKS
     C                             and DDFSEQ = *BLANKS
     C                             and DDFLNO = *BLANKS
 
     C                   EXSR      RDFWD_F
 
     C                   ELSE
 
     C                   EXSR      RDFWD_E
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        @RDBCK = 'Y'
 
     C                   IF        DDFECU = *BLANKS
     C                             and DDFFAC = *BLANKS
     C                             and DDFSEQ = *BLANKS
     C                             and DDFLNO = *BLANKS
 
     C                   EXSR      RDBCK_F
 
     C                   ELSE
 
     C                   EXSR      RDBCK_E
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input parameters :
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Action code
 
     C                   PARM                    DDACTN
 
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
 
      ** Read forwards
 
     C                   PARM                    @RDFWD
 
      ** Read backwards
 
     C                   PARM                    @RDBCK
 
      ** Output Parameters :
      ** Error meassage
 
     C                   PARM                    @ERRMS
 
 
     C                   PARM                    @KYRED
 
      ** Front Office ID READ
 
     C                   PARM                    @FTRED
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'LEPDCLRED'
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key Lists
 
     C     KPDUE         KLIST
     C                   KFLD                    DDORLNn
 
     C     KPDUF         KLIST
     C                   KFLD                    DDORLNn
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RDFWD_F - Read forwards thru transaction details file LEPDUFPD*
      *****************************************************************
     C     RDFWD_F       BEGSR
 
      ** Position after current record on file
 
     C                   MOVE      DDORLN        DDORLNn
     C     KPDUF         SETGT     TrnPDUF
 
      ** Read until a valid record is found or end of file
 
     C                   DOU           %eof
     C                             OR  (YPLON <> *BLANK
     C                                 and YRECI  = 'D'
     C                                 and @@ERR = *ZERO   )
 
      ** Read next transaction
 
     C                   READ      TrnPDUF
     C                   ENDDO
 
      ** If end of file was encountered, report
 
     C                   IF        %eof
     C                   EVAL      @ERRMS = 'MMM1002'
 
      ** Else, return the Interest Type/sub-type read
 
     C                   ELSE
     C                   MOVE      YPLON         @KYRED
     C                   MOVE      YPFRNT        @FTRED
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *RDBCK_F - Read backwards thru transaction details file LEPDUFPD*
      *****************************************************************
     C     RDBCK_F       BEGSR
 
      ** Position to current record on file
 
     C                   MOVE      DDORLN        DDORLNn
     C     KPDUF         SETLL     TrnPDUF
 
      ** Read until a valid record is found or beginning of file
 
     C                   DOU           %eof
     C                             OR  (YPLON <> *BLANK
     C                                 and YRECI  = 'D'
     C                                 and @@ERR = *ZERO   )
 
      ** Read prior transaction
 
     C                   READP     TrnPDUF
     C                   ENDDO
 
      ** If beginning of file encountered, report
 
     C                   IF        %eof
     C                   EVAL      @ERRMS = 'MMM1003'
 
      ** Else, return the Interest Type/sub-type read
 
     C                   ELSE
     C                   MOVE      YPLON         @KYRED
     C                   MOVE      YPFRNT        @FTRED
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *RDFWD_E - Read forwards thru transaction details file LEPDUEPD *
      *****************************************************************
     C     RDFWD_E       BEGSR
 
      ** Position after current record on file
 
     C                   MOVE      DDORLN        DDORLNn
     C     KPDUE         SETGT     TrnPDUE
 
      ** Read until a valid record is found or end of file
 
     C                   DOU           %eof
     C                             OR  (YPLON <> *BLANK
     C                                 and YRECI  = 'D'
     C                                 and @@ERR = *ZERO   )
 
      ** Read next transaction
 
     C                   READ      TrnPDUE
     C                   ENDDO
 
      ** If end of file was encountered, report
 
     C                   IF        %eof
     C                   EVAL      @ERRMS = 'MMM1002'
 
      ** Else, return the Interest Type/sub-type read
 
     C                   ELSE
     C                   MOVE      YPLON         @KYRED
     C                   MOVE      YPFRNT        @FTRED
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *RDBCK_E - Read backwards thru transaction details file LEPDUEPD*
      *****************************************************************
     C     RDBCK_E       BEGSR
 
      ** Position to current record on file
 
     C                   MOVE      DDORLN        DDORLNn
     C     KPDUE         SETLL     TrnPDUE
 
      ** Read until a valid record is found or beginning of file
 
     C                   DOU           %eof
     C                             OR  (YPLON <> *BLANK
     C                                 and YRECI  = 'D'
     C                                 and @@ERR = *ZERO   )
 
      ** Read prior transaction
 
     C                   READP     TrnPDUE
     C                   ENDDO
 
      ** If beginning of file encountered, report
 
     C                   IF        %eof
     C                   EVAL      @ERRMS = 'MMM1003'
 
      ** Else, return the Interest Type/sub-type read
 
     C                   ELSE
     C                   MOVE      YPLON         @KYRED
     C                   MOVE      YPFRNT        @FTRED
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching      *
      *****************************************************************
     C     CHAUTN        BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    @@ERR
 
      ** Return error message
 
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
