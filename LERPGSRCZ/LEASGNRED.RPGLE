     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignments read')
      *****************************************************************
      *                                                               *
      *  Midas - Lending module                                       *
      *                                                               *
      *  LEASGNRED - LE Assignments details read                      *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Assignments details file              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP084  *CREATE    Date 15Apr03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Transaction details file - by transaction number
     FLEPARTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPARTD0:LEPARTD2)
 
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT
      **********************************************************************
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D @@TRNN          DS
      ** First DS for access programs, short data structure
     D  KBRCA                  1      3
     D**KCNUM***               4      9  0                                                    CSD027
     D  KCNUM                  4      9A                                                      CSD027
     D  KFACT                 10     12  0
     D  KFCNO                 13     14  0
     D**KMNUM***              15     20  0                                                    CSD027
     D**KINUM***              21     26  0                                                    CSD027
     D  KMNUM                 15     20A                                                      CSD027
     D  KINUM                 21     26A                                                      CSD027
     D  KVDTC                 27     29P 0
 
     D PARKEY          DS
      ** DS of all key fields read from LEPARTL2
     D  BRCA                   1      3
     D**CNUM****               4      9  0                                                    CSD027
     D  CNUM                   4      9A                                                      CSD027
     D  FACT                  10     12  0
     D  FCNO                  13     14  0
     D**MNUM****              15     20  0                                                    CSD027
     D**INUM****              21     26  0                                                    CSD027
     D  MNUM                  15     20A                                                      CSD027
     D  INUM                  21     26A                                                      CSD027
     D  VDTC                  27     29P 0
 
     D DDTRNN          DS
      ** DS of all key fields incoming from *PLIST
     D  DDBRCA_IN              1      3
     D**DDCNUM_IN              4      9  0                                                    CSD027
     D  DDCNUM_IN              4      9A                                                      CSD027
     D  DDFACT_IN             10     12  0
     D  DDFCNO_IN             13     14  0
     D**DDMNUM_IN             15     20  0                                                    CSD027
     D**DDINUM_IN             21     26  0                                                    CSD027
     D  DDMNUM_IN             15     20A                                                      CSD027
     D  DDINUM_IN             21     26A                                                      CSD027
     D  DDVDTC_IN             27     29P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **********************************************************************
      /EJECT
      **********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Initialise outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @TRRED = *BLANK
      *
      * LEPARTL2 key list
     C     KTRNN         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
     C                   KFLD                    KMNUM
     C                   KFLD                    KINUM
     C                   KFLD                    KVDTC
      *
      * Check for user authority to browse if not multi-branching
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate transaction reference
     C                   EXSR      VALTRN
      *
      * Read forwards
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * Read backwards
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
      *
      * Return
     C                   RETURN
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      * *INZSR - Initial processing
      **********************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      * Input parameters :
      * Return code
     C                   PARM                    RetCodeIn
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * Transaction reference
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
     C                   PARM                    DDMNUM            6
     C                   PARM                    DDINUM            6
     C                   PARM                    DDVDTC            5
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM                    @ERRMS            7
 
      * Transaction read
     C                   PARM                    @TRRED           29
 
      * Front Office ID READ
     C                   PARM                    @FTRED           20
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'LEASGNRED'
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      * RDFWD - Read forwards through transaction details file
      **********************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
     C     KTRNN         SETGT     LEPARTD2
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             BRCA <> *BLANKS
      *
      * Read next transaction
     C                   READ      LEPARTD2                               99
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'LEV9001'
      *
      * Else, return the transaction reference read
     C                   ELSE
     C                   MOVE      PARKEY        @TRRED
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * RDBCK - Read backwards through transaction details file
      **********************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
     C     KTRNN         SETLL     LEPARTD2
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             BRCA <> *BLANKS
      *
      * Read previous transaction
     C                   READP     LEPARTD2                               99
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'LEV9002'
      *
      * Else, return the transaction reference read
     C                   ELSE
      *
     C                   MOVE      PARKEY        @TRRED
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      **********************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * Return error message
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'LEV9003'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * VALTRN - validate transaction reference
      **********************************************************************
     C     VALTRN        BEGSR
      *
      * Check that the transaction reference is blank.
      *
     C**********         IF        DDCNUM = *ZEROS                                            CSD027
     C                   IF        DDCNUM = *BLANKS                                           CSD027
     C                   EVAL      @ERRMS = 'LEV9011'
     C                   EVAL      @@ERR = 1
     C                   RETURN
     C                   ENDIF
      *
     C**********         IF        DDMNUM = *ZEROS                                            CSD027
     C                   IF        DDMNUM = *BLANKS                                           CSD027
     C                   EVAL      @ERRMS = 'LEV9011'
     C                   EVAL      @@ERR = 1
     C                   RETURN
     C                   ENDIF
      *
     C**********         IF        DDINUM = *ZEROS                                            CSD027
     C                   IF        DDINUM = *BLANKS                                           CSD027
     C                   EVAL      @ERRMS = 'LEV9011'
     C                   EVAL      @@ERR = 1
     C                   RETURN
     C                   ENDIF
      *
      * Return error message
     C                   IF        @@ERR <> 1
     C                   MOVEL     DDCNUM        DDCNUM_IN
     C                   MOVEL     DDFACT        DDFACT_IN
     C                   MOVEL     DDFCNO        DDFCNO_IN
     C                   MOVEL     DDMNUM        DDMNUM_IN
     C                   MOVEL     DDINUM        DDINUM_IN
     C                   MOVEL     DDBRCA        DDBRCA_IN
     C                   MOVEL     DDVDTC        VDTCNUM           5 0
     C                   Z-ADD     VDTCNUM       DDVDTC_IN
     C                   MOVE      DDTRNN        @TRRED
     C                   MOVE      DDTRNN        @@TRNN
     C                   ELSE
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2002
