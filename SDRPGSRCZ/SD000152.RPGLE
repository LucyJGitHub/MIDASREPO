     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Check if Nostro is used by deals')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000152 - Midas SD Check if Nostro is used by deals.        *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a transaction.                                    *
      *                                                               *
      *  Called By: SD0151R                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD036510           Date 10Jul17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR571692 *CREATE   Date 05Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036510 - Possibility to close Nostro Account with live     *
      *             Fees linked to it                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR571692 - COB: FTC0240, FTC0250, FTC0510, FTC0520, GLC0802C *
      *             Fails. Nostro attached to Midas transactions can  *
      *             be deleted causing components to fail.            *
      *             Check Nostro before deletion against MM, FX, LE   *
      *             and SE transactions. Also against RSACMTPD.       *
      *             (Child: AR571693)                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALSC    IF   E           K DISK
 
     FDEALALL   IF   E           K DISK
     F                                     IGNORE(DEALSDAF:DEALSDCF:DEALSDDF)
     F                                     IGNORE(DEALSDEF:DEALSDFF:DEALSDGF)
 
     FDEAMS     IF   E           K DISK
     F                                     IGNORE(DEAMSDHF:DEAMSDJF)
 
     FDLDLDGLE  IF   E           K DISK
 
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
 
     FLELOAML3  IF   E           K DISK
 
     FACCNTL0   IF   E           K DISK
 
     FTRADSDLJ  IF   E           K DISK
     F                                     RENAME(TRADSDF:TRDCCYF)
 
     FSOBTRDL2  IF   E           K DISK
     F                                     RENAME(TRADSDF:SOBCCYF)
 
     FINPAYL1   IF   E           K DISK
 
     FOTPAYL1   IF   E           K DISK
 
     FTRANS     IF   E           K DISK
 
     FTRSET     IF   E           K DISK
 
     FLEFEEDL0  IF   E           K DISK                                                     MD036510
     F                                     PREFIX(A)                                        MD036510
                                                                                            MD036510
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D***@Txt***       S             25A   DIM(8) CTDATA PERRCD(1)                          MD036510
     D @Txt            S             25A   DIM(9) CTDATA PERRCD(1)                          MD036510
 
     D  AccOne         DS
     D  ##Brca                 1      3
     D  ##Cnum                 4      9
     D  XxCcy                 10     12
     D  ##Acod                13     22  0
     D  ##Acsq                23     24  0
 
     D  AccTwo         DS
     D  @@Brca                 1      3
     D  @@Cnum                 4      9
     D  @@Ccy                 10     12
     D  @@Acod                13     22  0
     D  @@Acsq                23     24  0
 
     D  OSDA           DS
     D  RCnum                  1      6  0
     D  RAcod                  7     10  0
     D  RAcsq                 11     12  0
 
     D  OMDA           DS
     D  PCnum                  1      6  0
     D  PAcod                  7     10  0
     D  PAcsq                 11     12  0
 
     D  WMsgD          DS
     D  MsgD1                  1     25
     D  MsgD2                 26     45
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D YyBrca          S              3A
     D YyCnum          S              6A
     D YyCcy           S              3A
     D YyAcod          S             10A
     D YyAcsq          S              2A
     D XxNost          S              2A
     D XxRtn           S              1A
 
     D Nostro          S              2S 0
 
     D ##Acno          S             10A
 
     D @Nost           S              2A
     D @Ccy            S              3A
 
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
     IACCNTABF
     I              BRCA                        BrcaXX
     I              CNUM                        CnumXX
     I              CCY                         CcyXX
 
     ITRDCCYF
     I              CRSK                        CrsKX
 
     ISOBCCYF
     I              CRSK                        CrsKXX
 
      ** +--------------------------------------+
      ** ¦ End of I-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   EVAL      ##Cnum = YyCnum
     C                   EVAL      ##Acod = %DEC(YyAcod:10:0)
     C                   EVAL      ##Acsq = %DEC(YyAcsq:2:0)
     C                   EVAL      Nostro = %DEC(XxNost:2:0)
     C                   EVAL      XxRtn  = 'N'
      *
      ** Retrieve Account Details
      *
     C                   EXSR      RTVACC
      *
      ** Money Market Loans/Deposits
      *
     C                   READ      DEALSC                                 01
     C                   DOW       *IN01 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(1)
     C                   EVAL      MsgD2 = %CHAR(DLNO)
      *
     C                   IF        RSTM = 1 OR RSTM = 2 OR RSTM = 7
     C                             OR RSTM = 8 OR RSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND RONS = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        PSTM = 1 OR PSTM = 2 OR PSTM = 7
     C                             OR PSTM = 8 OR PSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND PONS = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        IMET = '01' OR IMET = '02'
     C                             OR IMET = '07' OR IMET = '08'
     C                             OR IMET = '12'
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND INSA = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 5 AND XxRtn = 'N'
     C                   EVAL      @@Brca = ROBR
      *
      ** Loan
      *
     C                   IF        RCDC = 15
     C                   EVAL      @@Brca = POBR
     C                   ENDIF
      *
     C                   EVAL      @@Cnum = %CHAR(RCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = RAcod
     C                   EVAL      @@Acsq = RAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PSTM = 5 AND XxRtn = 'N'
     C                   EVAL      @@Brca = POBR
      *
     C                   IF        RCDC = 15
     C                   EVAL      @@Brca = ROBR
     C                   ENDIF
      *
     C                   EVAL      @@Cnum = %CHAR(PCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = PAcod
     C                   EVAL      @@Acsq = PAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 14 AND XxRtn = 'N'
     C                             AND ##Acno = RONS
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
      *
     C                   IF        PSTM = 14 AND XxRtn = 'N'
     C                             AND ##Acno = PONS
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
      *
     C                   READ      DEALSC                                 01
     C                   ENDDO
      *
      ** Foreign Exchange Deals
      *
     C                   IF        XxRtn = 'N'
     C                   READ      DEALALL                                02
      *
     C                   DOW       *IN02 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(2)
     C                   EVAL      MsgD2 = %CHAR(DLNO)
      *
     C                   IF        PCST = 1 OR PCST = 2 OR PCST = 7
     C                             OR PCST = 8 OR PCST = 12
      *
     C                   IF        RECI = 'D' AND PUCY = XxCcy
     C                             AND OPCA = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        SCST = 1 OR SCST = 2 OR SCST = 7
     C                             OR SCST = 8  OR SCST = 12
     C                   IF        RECI = 'D' AND SLCY = XxCcy
     C                             AND OSCA = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PCST = 5 AND XxRtn = 'N'
     C                   EVAL      OSDA   = OPCA
     C                   EVAL      @@Brca = ROBR
     C                   EVAL      @@Cnum = %CHAR(RCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = RAcod
     C                   EVAL      @@Acsq = RAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        SCST = 5 AND XxRtn = 'N'
     C                   EVAL      OMDA   = OSCA
     C                   EVAL      @@Brca = POBR
     C                   EVAL      @@Cnum = %CHAR(PCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = PAcod
     C                   EVAL      @@Acsq = PAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PCST = 14 AND XxRtn = 'N'
     C                             AND OPCA = ##Acno
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
      *
     C                   IF        SCST = 14 AND XxRtn = 'N'
     C                             AND OSCA = ##Acno
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
      *
     C                   READ      DEALALL                                02
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Deal Amendments
      *
     C                   IF        XxRtn = 'N'
     C                   READ      DEAMS                                  03
      *
     C                   DOW       *IN03 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(1)
     C                   EVAL      MsgD2 = %CHAR(DLNO)
      *
     C                   IF        RSTM = 1 OR RSTM = 2 OR RSTM = 7
     C                             OR RSTM = 8 OR RSTM = 12
      *
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND RONS = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        PSTM = 1 OR PSTM = 2 OR PSTM = 7
     C                             OR PSTM = 8 OR PSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND PONS = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 5 AND XxRtn = 'N'
     C                   EVAL      OSDA   = RONS
     C                   EVAL      @@Brca = OSBR
     C                   EVAL      @@Cnum = %CHAR(RCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = RAcod
     C                   EVAL      @@Acsq = RAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PSTM = 5 AND XxRtn = 'N'
     C                   EVAL      OMDA   = PONS
     C                   EVAL      @@Brca = OSBR
     C                   EVAL      @@Cnum = %CHAR(PCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = PAcod
     C                   EVAL      @@Acsq = PAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 14 AND XxRtn = 'N'
     C                             AND RONS = ##Acno
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
      *
     C                   IF        PSTM = 14 AND XxRtn = 'N'
     C                             AND PONS = ##Acno
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
      *
     C                   READ      DEAMS                                  03
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** FRA/IRS Deals
      *
     C                   IF        XxRtn = 'N'
     C                   READ      DLDLDGLE                               04
      *
     C                   DOW       *IN04 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(4)
     C                   EVAL      MsgD2 = %CHAR(DLNO)
      *
     C                   IF        RSETM = 1 OR RSETM = 2 OR RSETM = 7
     C                             OR RSETM = 8 OR RSETM = 12
     C                   IF        RECI = 'D' AND TCUCY = XxCcy
     C                             AND URACC = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        PSETM = 1 OR PSETM = 2 OR PSETM = 7
     C                             OR PSETM = 8 OR PSETM = 12
     C                   IF        RECI = 'D' AND UCUCY = XxCcy
     C                             AND UPACC = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSETM = 5 AND XxRtn = 'N'
      *
     C                   EVAL      OSDA   =   URACC
     C                   EVAL      @@Brca = ROBR
     C                   EVAL      @@Cnum = %CHAR(RCnum)
     C                   EVAL      @@Ccy  = TCUCY
     C                   EVAL      @@Acod = RAcod
     C                   EVAL      @@Acsq = RAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PSETM = 5 AND  XxRtn = 'N'
     C                   EVAL      OMDA   =   UPACC
     C                   EVAL      @@Brca = POBR
     C                   EVAL      @@Cnum = %CHAR(PCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = PAcod
     C                   EVAL      @@Acsq = PAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSETM = 14 AND XxRtn = 'N'
     C                             AND URACC = ##Acno
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
      *
     C                   IF        PSETM = 14 AND XxRtn = 'N'
     C                             AND UPACC = ##Acno
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
      *
     C                   READ      DLDLDGLE                               04
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Customer Loans
      *
     C                   IF        XxRtn = 'N'
     C                   READ      CLOAN                                  05
      *
     C                   DOW       *IN05 = '0' AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(3)
     C                   EVAL      MsgD2 = LNRF
      *
     C                   IF        RSTM = 1 OR RSTM = 2 OR RSTM = 7
     C                             OR RSTM = 8 OR RSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND RONS = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        PSTM = 1 OR PSTM = 2 OR PSTM = 7
     C                             OR PSTM = 8 OR PSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND PONS = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 5 AND XxRtn = 'N'
     C                   EVAL      @@Brca = POBR
     C                   EVAL      @@Cnum = %CHAR(RCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = RAcod
     C                   EVAL      @@Acsq = RAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PSTM = 5 AND XxRtn = 'N'
     C                   EVAL      @@Brca = ROBR
     C                   EVAL      @@Cnum = %CHAR(PCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = PAcod
     C                   EVAL      @@Acsq = PAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 14 AND XxRtn = 'N'
     C                             AND RONS = ##Acno
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
      *
     C                   IF        PSTM = 14 AND XxRtn = 'N'
     C                             AND PONS = ##Acno
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
      *
     C                   READ      CLOAN                                  05
     C                   ENDDO
      *
     C                   ENDIF                                                              MD036510
      *                                                                                     MD036510
      *                                                                                     MD036510
      ** Fees                                                                               MD036510
      *                                                                                     MD036510
     C                   IF        XxRtn = 'N'                                              MD036510
      *                                                                                     MD036510
     C                   EVAL      WMsgD = *BLANKS                                          MD036510
     C                   EVAL      MsgD1 = @Txt(9)                                          MD036510
      *                                                                                     MD036510
     C     *LOVAL        SETLL     LEFEEDL0                                                 MD036510
     C                   READ      LEFEEDL0                               20                MD036510
      *                                                                                     MD036510
     C                   DOW       *IN20 = '0' AND XxRtn = 'N'                              MD036510
      *                                                                                     MD036510
     C                   IF        AFESTTL = 1 OR AFESTTL = 2 OR AFESTTL = 7                MD036510
     C                             OR AFESTTL = 8 OR AFESTTL = 12                           MD036510
     C                   IF        AFERECI = 'D' AND AFEFCCY = XxCcy                        MD036510
     C                             AND ARONS = XxNost                                       MD036510
     C                   EVAL      XxRtn = 'R'                                              MD036510
     C                   MOVEL(P)  AFECNUM       MsgD2                                      MD036510
     C                   LEAVE                                                              MD036510
     C                   ENDIF                                                              MD036510
     C                   ENDIF                                                              MD036510
      *                                                                                     MD036510
     C                   IF        XxRtn = 'N'                                              MD036510
     C                   IF        AFESTTL = 1 OR AFESTTL = 2 OR AFESTTL = 7                MD036510
     C                             OR AFESTTL = 8 OR AFESTTL = 12                           MD036510
     C                   IF        AFERECI = 'D' AND AFEFCCY = XxCcy                        MD036510
     C                             AND APONS = XxNost                                       MD036510
     C                   EVAL      XxRtn = 'P'                                              MD036510
     C                   MOVEL(P)  AFECNUM       MsgD2                                      MD036510
     C                   LEAVE                                                              MD036510
     C                   ENDIF                                                              MD036510
     C                   ENDIF                                                              MD036510
     C                   ENDIF                                                              MD036510
      *                                                                                     MD036510
     C                   READ      LEFEEDL0                               20                MD036510
     C                   ENDDO                                                              MD036510
      *                                                                                     MD036510
     C                   ENDIF                                                              MD036510
      *                                                                                     MD036510
      *
      ** Loan Amendments
      *
     C                   IF        XxRtn = 'N'
     C                   READ      LELOAML3                               06
      *
     C                   DOW       *IN06 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(3)
     C                   EVAL      MsgD2 = LNRF
      *
     C                   IF        RSTM = 1 OR RSTM = 2 OR RSTM = 7
     C                             OR RSTM = 8 OR RSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND RONS = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        XxRtn = 'N'
     C                   IF        PSTM = 1 OR PSTM = 2 OR PSTM = 7
     C                             OR PSTM = 8 OR PSTM = 12
     C                   IF        RECI = 'D' AND CCY = XxCcy
     C                             AND PONS = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 5 AND XxRtn = 'N'
     C                   EVAL      OSDA = RONS
     C                   EVAL      @@Brca = OSBR
     C                   EVAL      @@Cnum = %CHAR(RCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = RAcod
     C                   EVAL      @@Acsq = RAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PSTM = 5 AND XxRtn = 'N'
     C                   EVAL      OMDA   = PONS
     C                   EVAL      @@Brca = OSBR
     C                   EVAL      @@Cnum = %CHAR(PCnum)
     C                   EVAL      @@Ccy  = CCY
     C                   EVAL      @@Acod = PAcod
     C                   EVAL      @@Acsq = PAcsq
      *
     C                   IF        AccOne = AccTwo
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSTM = 14 AND XxRtn = 'N'
     C                             AND RONS = ##Acno
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
      *
     C                   IF        PSTM = 14 AND XxRtn = 'N'
     C                             AND PONS = ##Acno
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
      *
     C                   READ      LELOAML3                               06
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Security Trades
      *
     C                   IF        XxRtn = 'N'
     C                   READ      TRDCCYF                                07
      *
     C                   DOW       *IN07 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(5)
     C                   EVAL      MsgD2 = TDRF
      *
     C                   IF        SMTH = 1 OR SMTH = 2 OR SMTH = 7
     C                             OR SMTH = 8 OR SMTH = 12
     C                   IF        RECI <> '*' AND SETC = XxCcy
     C                             AND PYFM = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ELSE
     C                   IF        RECI <> '*' AND SETC = XxCcy
     C                             AND PAYT = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      TRDCCYF                                07
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Security Start of Business Trades
      *
     C                   IF        XxRtn = 'N'
     C                   READ      SOBCCYF                                08
      *
     C                   DOW       *IN08 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(5)
     C                   EVAL      MsgD2 = TDRF
      *
     C                   IF        SMTH = 1 OR SMTH = 2 OR SMTH = 7
     C                             OR SMTH = 8 OR SMTH = 12
     C                   IF        RECI <> '*' AND SETC = XxCcy
     C                             AND PYFM = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ELSE
     C                   IF        RECI <> '*'  AND SETC = XxCcy
     C                             AND PAYT = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SOBCCYF                                08
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Incoming Payments
      *
     C                   IF        XxRtn = 'N'
     C                   READ      INPAYL1                                09
      *
     C                   DOW       *IN09 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(6)
     C                   EVAL      MsgD2 = PREF
      *
     C                   IF        SNTP = 'F'
     C                   EVAL      @Ccy = %SUBST(SND1:1:3)
     C                   EVAL      @Nost = %SUBST(SND1:4:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        SNTP = 'N' AND XxRtn = 'N'
     C                   EVAL      @Ccy = %SUBST(SND1:3:3)
     C                   EVAL      @Nost = %SUBST(SND1:1:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BNCT = 'F' AND XxRtn = 'N'
     C                   EVAL      @Ccy = %SUBST(BNC1:1:3)
     C                   EVAL      @Nost = %SUBST(BNC1:4:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BNCT = 'N' AND XxRtn = 'N'
     C                   EVAL      @Ccy = %SUBST(BNC1:3:3)
     C                   EVAL      @Nost = %SUBST(BNC1:1:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn ='R'
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      INPAYL1                                09
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Outgoing Payments
      *
     C                   IF        XxRtn = 'N'
     C                   READ      OTPAYL1                                10
      *
     C                   DOW       *IN10 = '0' AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(7)
     C                   EVAL      MsgD2 = PREF
      *
     C                   IF        DSTT = 'F'
     C                   EVAL      @Ccy  = %SUBST(DST1:1:3)
     C                   EVAL      @Nost = %SUBST(DST1:4:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DSTT = 'N' AND XxRtn = 'N'
     C                   EVAL      @Ccy  = %SUBST(DST1:3:3)
     C                   EVAL      @Nost = %SUBST(DST1:1:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BNCT = 'F' AND XxRtn = 'N'
     C                   EVAL      @Ccy  = %SUBST(BNC1:1:3)
     C                   EVAL      @Nost = %SUBST(BNC1:4:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BNCT = 'N' AND XxRtn = 'N'
     C                   EVAL      @Ccy  = %SUBST(BNC1:3:3)
     C                   EVAL      @Nost = %SUBST(BNC1:1:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ODMT <> *BLANKS AND XxRtn = 'N'
     C                   IF        ODMTT = 'F'
     C                   EVAL      @Ccy  = %SUBST(ODMT:1:3)
     C                   EVAL      @Nost = %SUBST(ODMT:4:2)
     C                   IF        @Ccy = XxCcy AND @Nost = XxNost
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      OTPAYL1                                10
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Future and Options
      *
     C                   IF        XxRtn = 'N'
     C                   READ      TRANS                                  11
      *
     C                   DOW       *IN11 = *OFF AND XxRtn = 'N'
     C                   EVAL      WMsgD = *BLANKS
     C                   EVAL      MsgD1 = @Txt(8)
     C                   EVAL      MsgD2 = %CHAR(TNBR)
      *
     C     TNBR          CHAIN     TRSET
      *
     C                   IF        %FOUND AND RECI = 'D'
      *
     C                   IF        CUSC <> *BLANK AND CSLA <> *BLANK
     C                   IF        CSLT = 1 OR CSLT = 2 OR CSLT = 7
     C                             OR CSLT = 8 OR CSLT = 12
     C                   EVAL      @Nost = %SUBST(CSLA:1:2)
     C                   EVAL      @Ccy  = ISCY
     C                   IF        @Nost = XxNost AND @Ccy = XxCcy
     C                   EVAL      XxRtn = 'R'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BOCO <> *BLANK AND BSLA <> *BLANK
     C                             AND XxRtn = 'N'
     C                   IF        BSLT = 1 OR BSLT = 2 OR BSLT = 7
     C                             OR BSLT = 8 OR BSLT = 12
     C                   EVAL      @Nost = %SUBST(BSLA:1:2)
     C                   EVAL      @Ccy = ISCY
     C                   IF        @Nost = XxNost AND @Ccy = XxCcy
     C                   EVAL      XxRtn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      TRANS                                  11
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  RTVACC - Retrieve Account Details                            *
      *                                                               *
      *****************************************************************
     C     RTVACC        BEGSR
      *
     C     KACCNT        KLIST
     C                   KFLD                    ##Cnum
     C                   KFLD                    XxCcy
     C                   KFLD                    ##Acod
     C                   KFLD                    ##Acsq
     C                   KFLD                    ##Brca
      *
     C                   EVAL      ##Acno = *BLANKS
      *
     C     *LOVAL        SETLL     ACCNTL0
     C     KACCNT        CHAIN     ACCNTL0
     C                   IF        %FOUND
     C                   EVAL      ##Acno = %CHAR(ACNO)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C     ##Brca        PARM                    YyBrca
     C                   PARM                    YyCnum
     C     XxCcy         PARM                    YyCcy
     C                   PARM                    YyAcod
     C                   PARM                    YyAcsq
     C                   PARM                    XxNost
     C                   PARM                    XxRtn
     C                   PARM                    WMsgD
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**  Message ID Text
MM deal
FX deal
Loan
FRA/IRS deal
Security Trade
FT Incoming Payment
FT Outgoing Payment
FF Trade
Fee - Customer Number
