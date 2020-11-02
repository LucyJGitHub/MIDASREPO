     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL - Projections for 5th and 6th day')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL005801 - GL - Projections for 5th and 6th day              *
      *                                                               *
      *  Function:  This program retieves Movement Amount and Debit/  *
      *             Credit indicator from zone file RSACMTL8 to be    *
      *             used by global program GPNOSBGEN and GPNOSBUPD.   *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2012            *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Pret Amend No. MD046248           Date 27Oct17               *
      *                 AR987769 *CREATE   Date 28Jun12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR987769 - Discrepancies on the Projected Nostro Balances    *
      *             enquiry. Updated projections for 6th & 7th day in *
      *             GPNOSBPD based from RSACMTPD.                     *
      *                                                               *
      *****************************************************************
      *
      ** GL Acc movts by Branch Code - Alpha, Customer Number, Currency
      ** Code, Account code, Account Sequence, Value Date
      *
     FRSACMTL8  IF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D WBrchCd         S              3A
     D WCust           S              6A
     D WCyCd           S              3A
     D WAcCd           S             10S 0
     D WAcSeqN         S              2S 0
     D NbDat6          S              5S 0
     D NbDat7          S              5S 0
     D TmpAmt          S             17S 0
     D X_Fctr          S              7S 0
     D NbBal5          S             17S 0
     D NbBal6          S             17S 0
     D NbBal7          S             17S 0
      *
     D WValDt          S              5S 0
     D WMvAm           S             17S 0
      *****************************************************************
      /EJECT
      *****************************************************************
      *   START PROGRAM : MAINLINE
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    WBrchCd
     C                   PARM                    WCust
     C                   PARM                    WCyCd
     C                   PARM                    WAcCd
     C                   PARM                    WAcSeqN
     C                   PARM                    NbDat6
     C                   PARM                    NbDat7
     C                   PARM                    X_Fctr
     C                   PARM                    NbBal5
     C                   PARM                    NbBal6
     C                   PARM                    NbBal7
     C
      *
     C     RSAcmtK       KLIST
     C                   KFLD                    WBrchCd
     C                   KFLD                    WCust
     C                   KFLD                    WCycd
     C                   KFLD                    WAcCd
     C                   KFLD                    WAcSeqN
     C                   KFLD                    WValDt
      *
      ** 5th day
      *
     C                   EVAL      WValDt = NbDat6
     C     RSAcmtK       SETLL     RSACMTL8
     C     RSAcmtK       READE (N) RSACMTL8
     C                   EVAL      TmpAmt = NbBal5
     C                   DOW       NOT %EOF
     C                   IF        X_Fctr <> 0
     C                   EVAL(H)   WMvAm = MVAM / X_Fctr
     C                   ENDIF
     C                   IF        DORC = 0
     C                   EVAL      TmpAmt = TmpAmt + WMvAm
     C                   ELSE
     C                   EVAL      TmpAmt = TmpAmt - WMvAm
     C                   ENDIF
      *
     C     RSAcmtK       READE (N) RSACMTL8
     C                   ENDDO
     C                   EVAL      NbBal6 = TmpAmt
      *
      ** 6th day
      *
     C                   EVAL      WValDt = NbDat7
     C     RSAcmtK       SETLL     RSACMTL8
     C     RSAcmtK       READE (N) RSACMTL8
     C                   EVAL      TmpAmt = NbBal6
     C                   DOW       NOT %EOF
     C                   IF        X_Fctr <> 0
     C                   EVAL(H)   WMvAm = MVAM / X_Fctr
     C                   ENDIF
     C                   IF        DORC = 0
     C                   EVAL      TmpAmt = TmpAmt + WMvAm
     C                   ELSE
     C                   EVAL      TmpAmt = TmpAmt - WMvAm
     C                   ENDIF
      *
     C     RSAcmtK       READE (N) RSACMTL8
     C                   ENDDO
     C                   EVAL      NbBal7 = TmpAmt
      *
      ** End of processing
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
