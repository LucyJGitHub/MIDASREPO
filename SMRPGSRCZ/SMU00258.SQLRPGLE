     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*OVR *  OVRDBF FILE(CLOANTEMP) TOFILE(CLOANCL) SHARE(*NO)            *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update LASQ of CLOANCL for PDCL Loan Fee')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SMU00258 - Midas SM Update LASQ of CLOANCL for PDCL Loan Fee *
      *                                                               *
      *  Called By: SMUC00258                                         *
      *                                                               *
      *  Function:  This program will correct LASQ field in CLOANCL   *
      *             file for PDCL Loan Fees                           *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 CLE141             Date 08Feb16               *
      *                 MD025112 *CREATE   Date 20Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  MD025112 - Incorrect LASQ field of PDCL loan fees in         *
      *             CLOANCL file                                      *
      *                                                               *
      *****************************************************************
      *
     FCLOANTEMP IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLF0)
     F                                     PREFIX(C0)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLF1)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(C1)
     FLECLIPL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLF2)
     F                                     IGNORE(CLOANCKF)
     F                                     PREFIX(C2)
      *
     DCLON           E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(A1)
     D LOANFee         S              6A
     D LOANSeq         S              2S 0
     D COUNT           S              5  0
     D W0LASQ          S              2  0 INZ(0)
     D Recursive       S              1A
      *
      ** System Value Parameter
     D @RTCD           S              7A
     D SeqFlg          S              1A
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
      *
      ** +--- Start of Main processing -----------------------------------+
      **                                                                  *
      **   Initial processing is performed automatically: the *INZSR is   *
      **   executed at program activation.                                *
      **                                                                  *
      ** +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              1
     C
      *
      ** Get PDCL Loan Fee records
      *
     C                   EXSR      SRGetLoanF
      *
      ** Generate driving file
      *
     C                   EXSR      SRGenDFile
     C                   IF        MODE = 'U'
      ** Update CLOANCL
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetLoanF -  Get PDCL Loan Fees to be updated               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *****************************************************************
     C     SRGetLoanF    BEGSR

     C/EXEC SQL
     C+ declare Pcursor cursor for
     C+ Select distinct a.*
     C+ From CLOANCL a, lepdufpd b, lefeed c
     C+ Where a.ltyp like 'Z%'
     C+ And b.yplon  = a.lnrf
     C+ And b.yefacl = c.fefacl
     C+ And b.yporg  <> ' '
     C+ And b.yecnum = c.fecnum
     C+ And b.yeseq  = c.fefseq
     C+ And b.yporg  = a.OFLN
     C/End-Exec

     C/EXEC SQL
     C+ Open Pcursor
     C/End-Exec
     C/EXEC SQL
     C+ Fetch NEXT from Pcursor into :CLON
     C/End-Exec
     C                   Z-ADD     0             COUNT
     C                   DOW       SQLCODE = 0
     C                   ADD       1             COUNT
     C                   EXSR      SrGetOLFee
     C/EXEC SQL
     C+ Fetch NEXT from Pcursor into :CLON
     C/End-Exec
     C                   ENDDO

     C/EXEC SQL
     C+ Close Pcursor
     C/End-Exec
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetOLFee - Get PDCL Loan Fees and Store to Temp File       *
      *                                                               *
      *  Called by: SRGetLoanF                                        *
      *                                                               *
      *****************************************************************
     C     SrGetOLFee    BEGSR
     C/EXEC SQL
     C+       Insert into CLOANTMP
     C+        Values (:CLON)
     C/End-Exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGenDFile - Generate Driving File for CLOANCL Update        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *****************************************************************
     C     SrGenDFile    BEGSR

     C/EXEC SQL
     C+ declare Pcursor2 cursor for
     C+ Select distinct a.*
     C+ From CLOANTMP a, CLOANCL b
     C+ Where a.ofln = b.lnrf
     C+ And a.lasq <> b.fseq
     C/End-Exec

     C/EXEC SQL
     C+ Open Pcursor2
     C/End-Exec
     C/EXEC SQL
     C+ Fetch NEXT from Pcursor2 into :CLON
     C/End-Exec
     C                   Z-ADD     0             COUNT
     C                   DOW       SQLCODE = 0
     C                   ADD       1             COUNT
     C                   EXSR      SrInsDFile
     C/EXEC SQL
     C+ Fetch NEXT from Pcursor2 into :CLON
     C/End-Exec
     C                   ENDDO

     C/EXEC SQL
     C+ Close Pcursor2
     C/End-Exec
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsDFile - Insert Data to Driving File                     *
      *                                                               *
      *  Called by: SrGenDFile                                        *
      *                                                               *
      *****************************************************************
     C     SrInsDFile    BEGSR
     C/EXEC SQL
     C+       Insert into CLOANTEMP
     C+        Values (:CLON)
     C/End-Exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Updates LASQ field when mode is 'U'               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR
      *
     C     1             SETLL     CLOANTEMP
     C                   READ      CLOANCLF0                              99
     C                   DOW       *IN99 = *OFF
     C     C0OFLN        CHAIN     CLOAN                              89
     C                   IF        *IN89 = *OFF
      *
     C                   IF        SeqFlg = 'Y'
     C                   MOVE      C1FSEQ        W0LASQ
     C                   ELSE
     C                   MOVE      C1LASQ        W0LASQ
     C                   ENDIF
      *
     C     C0LNRF        CHAIN     LECLIPL2                           88
     C                   IF        *IN89 = *OFF
     C                   MOVE      W0LASQ        C2LASQ
     C                   UPDATE    CLOANCLF2
     C                   ENDIF
      *
     C                   ENDIF
     C                   READ      CLOANCLF0                              99
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Check if Window Maintenance is activated

     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      POP01 = 'PDCLAccSeqNo'
     C                   EVAL      PVL01 = *BLANKS

     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10

     C                   EVAL      SeqFlg = *BLANKS
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     PVL01         SeqFlg
     C                   ENDIF
     C                   ENDSR
