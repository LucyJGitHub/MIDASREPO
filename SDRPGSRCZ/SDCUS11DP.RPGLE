     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Extended Details Display')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUS11DP - Midas SD Validate Residenza Code                 *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CSC031             Date 11Apr07               *
      *                 CER008  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CSC031 - Local Time Stamp                                    *
      *  CER008 - Base Italian Features Upgrade to MidasPlus          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCUS11DF CF   E             WORKSTN
      ** Customer Extended Details - Italian Details

     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      ** Table of field numbers and names

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of the
      ** arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      /COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------

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
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access programs

     D CurCuIt1      E DS                  Extname(SDCUS1PD)
     D OkCUSDItl     E DS                  Extname(SDECUIT1PD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              2P 0
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
     D PINKC           S              1A
     D PINKL           S              1A
     D PINKE           S              1A
     D PEINKE          S              1A
     D PEIN20          S              1A
     D ##PGM           S             10
     D PRTCD           S              7A
     D POPTN           S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Main processing

     C                   Exsr      SrMain

      ** Return

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMain - MAIN processing                                     *
      *                                                               *
      *****************************************************************

     C     SrMain        Begsr

     C                   If        DDTA004OK = 'N' Or DDTA004OK = 'W'
     C                   Eval      *IN50 = *ON
     C                   Endif

      ** Process the error messages

     C                   Eval      Idx = 1
     C                   Dow       Idx <= ErrArrMax
     C                             And FldNameArr(Idx) <> *BLANK
     C
     C                   Eval      ZAMSID = MsgIDArr(Idx)
     C                   Eval      ZAMSDA = MsgDtaArr(Idx)
     C                   Exsr      SrSend
     C                   Eval      Idx = Idx + 1
     C                   Enddo

      ** Process the warning messages

     C                   Eval      Idx = 1
     C                   Dow       Idx <= WArrMax
     C                             And WFldNamArr(Idx) <> *BLANK
     C
     C                   Eval      ZAMSID = WMsgIDArr(Idx)
     C                   Eval      ZAMSDA = WMsgDtaArr(Idx)
     C                   Exsr      SrSend
     C                   Eval      Idx = Idx + 1
     C                   Enddo

      ** Check on whether to enable fields and function keys

     C                   If        PEIN20 = 'Y'
     C                   Eval      *IN20 = *ON
     C                   Endif

     C                   If        PEINKE = 'Y'
     C                   Eval      *INKE = *ON
     C                   Endif

      ** Write message subfile, display detail screen, clear message queue

     C                   Write     #MSGCTL
     C                   Exfmt     SDCUSDF0
     C                   Exsr      SrClear

      ** Set screen error indicators off

     C                   Eval      *IN50 = *OFF
     C                   Eval      *IN20 = *OFF

      ** Set return keys

     C                   Eval      PINKC = *INKC
     C                   Eval      PINKE = *INKE
     C                   Eval      PINKL = *INKL

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClear - Clear message queues                               *
      *                                                               *
      *****************************************************************

     C     SrClear       Begsr

     C                   Eval      ZAPGMQ = ##PGM
     C                   Eval      ZAPGRL = '*SAME'

     C                   Call      'Y2CLMSC'
     C                   Parm                    ZAPGMQ
     C                   Parm                    ZAPGRL

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSend - Send messages to program's message queue            *
      *                                                               *
      *****************************************************************

     C     SrSend        Begsr

     C                   If        ZAPGMQ = *BLANKS
     C                   Eval      ZAPGMQ =  ##PGM
     C                   Endif

     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGMQ
     C                   Parm                    ZAPGRL
     C                   Parm                    ZAMSID
     C                   Parm                    ZAMSGF
     C                   Parm                    ZAMSDA
     C                   Parm                    ZAMSTP

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Initial Processing                                  *
      *                                                               *
      *****************************************************************

     C     *INZSR        Begsr

     C     *Entry        PLIST

     C                   Parm                    RetCodeIn
     C                   Parm                    CurCuIt1
     C                   Parm                    OkCUSDItl

     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr

     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr

     C                   Parm                    PEINKE
     C                   Parm                    PEIN20

     C                   Parm                    PINKC
     C                   Parm                    PINKL
     C                   Parm                    PINKE

      ** Initialise program name

     C                   Eval      ##PGM = 'SDCUS11DP'

      ** Move user and workstation ID to screen fields

     C                   Eval      DDWID  = PsJobName
     C                   Eval      DDUSER = PSUser
     C                   Eval      ZAMSGF = 'STUSRMSG'
     C**********         TIME                    DDTIME                                       CSC031
     C* Standard call to ZATIMZ/G to get time in place of TIME opcode                         CSC031
     C                   Z-ADD     9             DDTIME                                       CSC031
     C                   MOVEL     DDTIME        @#TZ@#                                       CSC031
     C                   CALL      'ZATIMZ'                                                   CSC031
     C                   PARM                    @#TZ@#           14                          CSC031
     C                   MOVEL     @#TZ@#        DDTIME                                       CSC031

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
