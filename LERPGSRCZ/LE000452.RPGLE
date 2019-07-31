     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Transaction Log File sent to MQ Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000452 - Midas LE Transaction Log File sent to MQ Report   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD045071           Date 06Apr17               *
      *                 MD025590           Date 19Aug14               *
      *                 MD023181           Date 22Apr14               *
      *                 MD022465           Date 24Sep13               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD020343           Date 18May13               *
      *                 AR1096974          Date 21Mar13               *
      *                 AR1094242          Date 03Mar13               *
      *                 AR1091213          Date 26Feb13               *
      *                 AR1084872*CREATE   Date 04Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045071 - Receiver value too small to hold result.          *
      *  MD025590 - Make sure that only processed record is on        *
      *             LE000452P1.                                       *
      *  MD023181 - System error message was not shown in the report. *
      *  MD022465 - Warning message introduced by MD021423E is        *
      *             printed multiple times                            *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD020343 - Erroneous original loan reference in report       *
      *  AR1096974 - Missing date on generated reports                *
      *  AR1094242 - Event code not found                             *
      *  AR1091213 - Additional fixes needed for Recovery Processing  *
      *              of PDCL components                               *
      *  AR1084872 - The reasons or cause why PDCL went to Repair     *
      *              Queue Tab should be described in a report        *
      *                                                               *
      *****************************************************************
     FLEMQLGL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FLE000452P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     OFLIND(P1OVERFLOW)
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D DSFDY         E DS
                                                                                           MD021423E
     D WarnMessage     C                   'Warning: Original Loan Receipt -               MD021423E
     D                                      Account has block all credit, -                MD021423E
     D                                      PDCL Pay settlement type will be -             MD021423E
     D                                      defaulted to  00'                              MD021423E
     D                                                                                     MD021423E
 
      ** Additional Field Definitions
     D P@SEQ           S              5
     D P@LEVEL         S              1
     D P@ENTITY        S              3
     D @NUMB           S             15  0
     D @DECS           S              1  0
     D @EDTC           S              1
     D @CHAR           S             21
     D @DATIN          S              5  0
     D @DATFM          S              1
     D @DATE6          S              6  0
     D @DATE7          S              7
     D @BRCD           S              3
     D @CURR           S              3
     D ZSSEQ           S              5
     D ZSENTITY        S              3
     D ZSFILE          S             10
     D ZSNUM           S              6  0
     D ZSERR           S              1
 
      ** Work Fields
     D WAPIN           S              8
     D WEROR           S            120
     D WBRAC           S            120
     D Wevtcode        S              9
     D Xevtcode        S              8
     D BracPos         S              3S 0
     D MSGLEN          S              3S 0
     D SystmErr        S             14                                                     MD023181
 
      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data structure for AO objects
     D DSSDY         E DS                  EXTNAME(DSSDY   )
 
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
 
     D Pos             S              3S 0
     D Ctr             S              3S 0
     D Finish          S              1N
     D Ind             S              5S 0
 
     D ArrayCtr        S              4S 0 DIM(50)
     D ArrayMsg        S            110A   DIM(50)
 
     C/EJECT
 
      ** +--- Start of Main processing -----------------------------------*
      **                                                                  *
      **   Initial processing is performed automatically: the *INZSR is   *
      **  executed at program activation.                                 *
      **                                                                  *
      ** +----------------------------------------------------------------*
 
     C                   EXSR      OPENPRTF
 
     C                   EXSR      EXTRACT
 
     C                   EXSR      CLOSEDOWN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXTRACT - Extract Subroutine                                  *
      *****************************************************************
     C     EXTRACT       BEGSR
      *
     C     *LOVAL        SETLL     LEMQLGL0                                                AR1094242
     C                   READ      LEMQLGL0
     C                   DOW       NOT %EOF(LEMQLGL0)
     C                   IF        ProgramName  = LGPGNM
     C                   EXSR      REPORT
     C                   ENDIF
     C                   READ      LEMQLGL0
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  REPORT - Write Report                                        *
      *****************************************************************
     C     REPORT        BEGSR
      *
      ** Set up report fields
      *
     C                   EVAL      #LGFRNT  = LGFRNT
     C                   EVAL      WAPIN = %SUBST(LGAPIN:13)
     C                   EVAL      #LGAPIN = WAPIN
      *
     C                   EVAL      #LGORLN = *BLANKS                                        MD020343
     C                   IF        LGORLN <> ' '
     C                   EVAL      #LGORLN  = LGORLN
     C**********         ELSE                                                              AR1091213
     C**********         EVAL      #LGORLN  = LGLOAN                                       AR1091213
     C                   ENDIF
      *
     C                   EVAL      #LGCUST  = LGCNUM
     C                   EVAL      #LGCCY   = LGCURR
      *
     C                   EVAL      @CURR = LGCURR
     C                   IF        @CURR <> *BLANKS                                        AR1094242
     C                   EXSR      SrChkCurr
     C                   ENDIF                                                             AR1094242
      *
     C                   IF        LGPDPR <> 0
     C                   MOVE      LGPDPR        ZFLD15
     C                   ELSE
     C                   MOVE      LGAMNT        ZFLD15
     C                   ENDIF
     C                   EXSR      SrConvAmt
     C                   MOVE      ZOUT21        #LGPRAM
      *
     C                   MOVE      LGPDIN        ZFLD15
     C                   EXSR      SrConvAmt
     C                   MOVE      ZOUT21        #LGINTA
      *
     C                   EVAL      #LGLTYP  = LGLTYP
     C                   EVAL      #LGSTYP  = LGSTYP
      *
     C                   SELECT
     C                   WHEN      LGSTAT = 'S'
     C                   EVAL      #LGSTAT  = 'SENT'
     C                   WHEN      LGSTAT = 'P'
     C                   EVAL      #LGSTAT  = 'PROCESSED'
     C                   WHEN      LGSTAT = 'E'
     C                   EVAL      #LGSTAT  = 'REPAIR'
     C                   ENDSL
      *
     C**********         EVAL      #LGPGNM  = LGPGNM                                       AR1091213
     C                   EVAL      #LGLOAN  = LGLOAN                                       AR1091213
 
     C                   EXSR      CHKHEADS
     C**********         IF        (Status = 'P' AND LGSTAT <> 'E') OR            AR1094242 MD025590
     C                   IF        (Status = 'P' AND LGSTAT = 'P') OR                       MD025590
     C                             (Status = 'A')                                          AR1094242
     C                   WRITE     LE000452D1
     C                   IF        LGACTN = 'W' AND LGSTAT = 'P'                            MD022465
     C                   EVAL      #ERROR= WarnMessage                                      MD022465
     C                   EXSR      CHKHEADS                                                 MD022465
     C                   WRITE     LE000452D2                                               MD022465
     C                   ENDIF                                                              MD022465
     C                   ENDIF                                                             AR1094242
 
     C                   IF        Status = 'E'  OR Status = 'A'                           AR1094242
     C                   IF        LGSTAT = 'E'
     C                   WRITE     LE000452D1                                              AR1094242
     C                   EXSR      SRProcError
     C                   ENDIF
     C                   ENDIF                                                             AR1094242
                                                                                           MD021423E
     C**********         IF        LGACTN = 'W' AND LGSTAT = 'P'                  MD021423E MD022465
     C**********         EVAL      #ERROR= WarnMessage                            MD021423E MD022465
     C**********         EXSR      CHKHEADS                                       MD021423E MD022465
     C**********         WRITE     LE000452D2                                     MD021423E MD022465
     C**********         ENDIF                                                    MD021423E MD022465
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrChkCurr - Check currency code                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOCURRR0                                               *
      *                                                               *
      *****************************************************************
     C     SrChkCurr     BEGSR
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZDECS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrConvAmt - Convert Amount to Alphanumeric                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZSEDIT                                                 *
      *                                                               *
      *****************************************************************
     C     SrConvAmt     BEGSR
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcError - Process Error Details                          *
      *****************************************************************
     C     SRProcError   BEGSR
      *
     C                   EVAL      MSGLEN = 0
     C                   EVAL      Pos = 0
     C                   EVAL      Finish = *ON
     C                   EVAL      Wevtcode = *BLANKS
     C                   EVAL      Xevtcode = *BLANKS
     C                   EVAL      WEROR = *BLANKS
     C                   EVAL      Ctr = 0
     C                   EVAL      ArrayCtr = 0                                             MD045071
     C                   EVAL      WPOS = *BLANKS                                           MD023181
      *
     C     LGFRNT        CHAIN     ZATRNERRL0
     C                   IF        %FOUND(ZATRNERRL0)
      *
     C                   EVAL      MSGLEN = %LEN(%TRIM(ABMSGTEXT))
     C                   IF        MSGLEN > 0
     C                   EVAL      Finish = *OFF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        NOT Finish
      *
     C                   DOU       Pos = 0
     C                   EVAL      Pos = %SCAN(':':ABMSGTEXT:Pos + 1)
     C                   IF        Pos <> 0
     C                   EVAL      Wevtcode = %SUBST(ABMSGTEXT:Pos - 9)
      *                                                                                     MD023181
     C                   EVAL      SystmErr = %SUBST(ABMSGTEXT:Pos - 14)                    MD023181
     C                   If        %CHECK('0123456789':SystmErr:14) = 0                     MD023181
     C                   EVAL      SystmErr = %SUBST(ABMSGTEXT:Pos - 15)                    MD023181
     C                   IF        SystmErr = 'MidasHostError'                              MD023181
     C                   MOVE      'Y'           WPOS              1                        MD023181
     C                   ENDIF                                                              MD023181
     C                   ENDIF                                                              MD023181
      *                                                                                     MD023181
     C                   IF        %CHECK('0123456789':Wevtcode:2) = 0
     C                   EVAL      Xevtcode = %SUBST(Wevtcode:1:1)
     C                   IF        %CHECK('0123456789':Xevtcode:1) > 0
     C                   EVAL      Ctr += 1
     C                   MOVEL     Pos           ArrayCtr(Ctr)
     C                   EVAL      ArrayCtr(Ctr) = Pos - 8
     C                   ENDIF
      *                                                                                     MD023181
     C                   ELSEIF    SystmErr = 'MidasHostError'                              MD023181
     C                   EVAL      Ctr += 1                                                 MD023181
     C                   MOVEL     Pos           ArrayCtr(Ctr)                              MD023181
     C                   IF        WPOS = 'Y'                                               MD023181
     C                   EVAL      ArrayCtr(Ctr) = Pos - 15                                 MD023181
     C                   ELSE                                                               MD023181
     C                   EVAL      ArrayCtr(Ctr) = Pos - 14                                 MD023181
     C                   ENDIF                                                              MD023181
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   FOR       Ind = 1 to Ctr
      *
     C                   IF        Ind + 1 <= %ELEM(ArrayCtr)
     C                   IF        ArrayCtr(Ind + 1) <> 0
     C                   EVAL      ArrayMsg(Ind) = %SUBST(ABMSGTEXT:
     C                             ArrayCtr(Ind):ArrayCtr(Ind + 1) -
     C                             ArrayCtr(Ind))
     C                   ELSE
     C                   EVAL      ArrayMsg(Ind) = %SUBST(ABMSGTEXT:
     C                             ArrayCtr(Ind))
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      BracPos = %SCAN('],':ArrayMsg(Ind))
     C                   IF        BracPos > 0
     C                   EVAL      WBRAC = %SUBST(ArrayMsg(Ind):BracPos)
     C                   EVAL      WEROR = %TRIM(ArrayMsg(Ind):WBRAC)
     C                   EVAL      ArrayMsg(Ind) = WEROR
     C                   ENDIF
      *
     C                   ENDFOR
      *
     C                   ENDIF
      *
     C                   FOR       Ind = 1 to Ctr
     C                   MOVE      Ind           #SEQUEN
     C                   EVAL      #ERROR= %TRIM(ArrayMsg(Ind):'[ ] { } ,')
     C                   EXSR      CHKHEADS
     C                   WRITE     LE000452D2
     C                   ENDFOR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CHKHEADS - Check OverFlow                                    *
      *****************************************************************
     C     CHKHEADS      BEGSR
 
     C                   IF        P1OVERFLOW
     C                   WRITE     LE000452H1
     C                   WRITE     LE000452H2
     C                   EVAL      P1OVERFLOW = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  OPENPRTF - Open Printerfile                                  *
      *****************************************************************
     C     OPENPRTF      BEGSR
 
     C                   OPEN      LEMQLGL0
     C                   OPEN      ZATRNERRL0
     C                   OPEN      LE000452P1
 
      ** Record spooled file details in RCF
 
     C                   EVAL      ZSENTITY = *BLANKS
 
     C                   CALL      'ZSFILE'
     C                   PARM      P@SEQ         ZSSEQ
     C                   PARM                    ZSENTITY
     C                   PARM      SFILE1        ZSFILE
     C                   PARM      SFNUM1        ZSNUM
     C                   PARM      *BLANK        ZSERR
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      P1OVERFLOW = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CLOSEDOWN - Close Down Program                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   IF        NOT %OPEN(LE000452P1)
     C                             AND P@ENTITY <> 'ALL'
     C                   EXSR      OPENPRTF
 
     C                   ENDIF
 
     C                   IF        %OPEN(LE000452P1)
     C                   EXSR      CHKHEADS
     C                   IF        P@LEVEL = 'B'
     C                   WRITE     LE000452T1
     C                   ELSE
     C                   WRITE     LE000452T1
     C                   ENDIF
     C                   ENDIF
 
     C                   CLOSE     LEMQLGL0
     C                   CLOSE     ZATRNERRL0
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Default Initialisation Subroutine                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ProgramName      10
     C                   PARM                    Status            1                       AR1094242
 
     C                   CALL      'AOBANKR0'                                              AR1096974
     C                   PARM      '*DBERR '     @RTCD                                     AR1096974
     C                   PARM      '*FIRST '     @OPTN                                     AR1096974
     C     SDBANK        PARM      SDBANK        DSFDY                                     AR1096974
                                                                                           AR1096974
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Handling Subroutine                    *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RUNBEFORE = *BLANK
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
