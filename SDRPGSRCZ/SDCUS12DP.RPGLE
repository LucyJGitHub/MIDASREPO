     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer PUMA II Display - Italian')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUS12DP - Midas SD Customer PUMA II Dtl Display - Italian  *
      *                                                               *
      *  Function:  This module displays the Customer PUMA II         *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCUS12DF CF   E             WORKSTN
      ** Midas Customer PUMA II Details Display - Italian

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
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

     D @EI             S              1    DIM(60)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access programs

     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      ** Customer Base Transaction Details in file format

     D*NwCuScnFmt    E DS                  EXTNAME(SDCURXPD)                            LUC139
     D NwCuScnFmt    E DS                  EXTNAME(SDCUS2PD)                            LUC139
      ** Customer PUMA 2 Transaction Details in screen format
     D NwCuScnFmt1   E DS                  EXTNAME(SDCUS1PD)                            LUC139

     D OKFlags       E DS                  EXTNAME(SDECUIT2PD)
      ** Customer PUMA 2 Transaction Details OK indicators

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PEINKE          S              1A
     D PEIN20          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
      ** Function key parms

     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
      ** Parameters for Y2SNMGC

     D ZAPGM           S             10A
      ** Parameters for Y2CLMSC

     D PRTCD           S              7A
     D POPTN           S              7A
      ** Parameters for AOBANKR0

     D C               S              2  0
     D E               S              2  0
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

     C                   EXSR      SRMAIN

      ** Return

     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      ** Input Parameters
      ** Return code

     C                   PARM                    RetCodeIn

      ** Transaction Details in file format

     C                   PARM                    NwCuFilFmt

      ** Transaction Details in screen format

     C                   PARM                    NwCuScnFmt1                           LUC139
     C                   PARM                    NwCuScnFmt

      ** Transaction Details OK indicators

     C                   PARM                    OKFlags

      ** Errors / Warning messages

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Enabled Function Keys

     C                   PARM                    PEINKE
     C                   PARM                    PEIN20

      ** Output parameter
      ** Function Keys

     C                   PARM                    PINKC
     C                   PARM                    PINKL
     C                   PARM                    PINKE

      ** Initialise program name

     C                   EVAL      ##PGM = 'SDCUS12DP'

      ** Move user and workstation ID to screen fields

     C                   EVAL      ##USR = PsUser
     C                   EVAL      ##JOB = PsJobName

     C                   EVAL      ZAMSGF = 'SDUSRMSG'

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

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - MAIN processing                                     *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR

      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKFlags       @EI

      ** Set screen error indicators according to status of 'OK' flags

     C                   EVAL      C = 1

     C                   IF        DDTA004 = '1' AND
     C                             CUBNBI  = 'Y'
     C                   EVAL      *IN29 = *OFF
     C                   ELSE
     C                   EVAL      *IN29 = *ON
     C                   ENDIF

     C                   EVAL      E = 31

     C                   DOU       C > %Len(OKFlags)
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVE      *ON           *IN(E)
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   EVAL      E = E + 1
     C                   ENDDO

      ** Process for error messages

     C                   EVAL      C = 1
     C                   DOW       C <= ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   EVAL      ZAMSID = MsgIdArr(C)
     C                   EVAL      ZAMSDA = MsgDtaArr(C)
     C                   EXSR      SRSEND
     C                   EVAL      C = C + 1
     C                   ENDDO

      ** Process for warning messages

     C                   EVAL      C = 1
     C                   DOW       C <= ArrayMax AND
     C                             WFldNamArr(C) <> *BLANKS
     C                   EVAL      ZAMSID = WMsgIdArr(C)
     C                   EVAL      ZAMSDA = WMsgDtaArr(C)
     C                   EXSR      SRSEND
     C                   EVAL      C = C + 1
     C                   ENDDO

      ** Check on whether to enable fields and function keys

     C                   IF        PEIN20 = 'Y'
     C                   EVAL      *IN20 = *OFF
     C                   ENDIF

      ** Enable F5 key

     C                   IF        PEINKE = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF

     C                   WRITE     #MSGCTL
     C                   EXFMT     SDCUSDF0
     C                   EXSR      SRCLEAR

      ** Set screen error indicators off

     C                   MOVEA     '0000000000'  *IN(31)
     C                   MOVEA     '0000000000'  *IN(41)
     C                   MOVEA     '00'          *IN(51)
     C                   MOVEA     '00'          *IN(53)                                LUC139

      ** Set return keys

     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKE = *INKE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLEAR - Clear the message queue                            *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR

     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM
     C                   PARM      '*SAME'       ZAPGRL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSEND - Send message to the message queue                   *
      *                                                               *
      *****************************************************************
     C     SRSEND        BEGSR

     C                   IF        ZAPGMQ = *BLANKS
     C                   EVAL      ZAPGMQ = ##PGM
     C                   ENDIF

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
