     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF SR/FFTVCL as a mod: calc total trans val')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFTVCL - Subroutine for calculating total transaction value  *
      *           converted into a module                             *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the FFTVCL        *
      *  subroutine.  The subroutine consists of 2 /COPY members.     *
      *  Note that one of them does not have an FFTVCL* name:         *
      *  FFSRDSZ1.                                                    *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 241147             Date 26Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFF006             Date 28Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  241147 - Correct computation of p/l.                         *
      *  CFF006 - Fractional Ticks Enhancement.                       *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Total transaction value
     D FFTNVL          S             13P 0
 
      ** Number of contracts
     D FFNOC           S              5P 0
 
      ** Price
     D Price           S             15P 8
 
      ** Ticks denominator
     D FFTKDM          S              3P 0
 
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted FFSRDSZ1 starts here --------------------------+
 
     D                 DS
      **  FFPRIC ( FILE  FORMAT OF PRICE )
     D  FFFP                   1     15                                         CFF004
     D  FFPRIC                 1     15  8                                      CFF004
     D  FFINTG                 1      7  0                                      CFF004
     D  FFIN                   1      7                                         CFF004
     D  FFDCN1                 8      8  0                                      CFF004
     D  FFDCN2                 8      9  0                                      CFF004
     D  FFDCN3                 8     10  0                                      CFF004
     D  FFDCN4                 9     11  3                                                    CFF006
     D  FFDCN5                10     12  3                                                    CFF006
     D  FFDCN6                11     13  3                                                    CFF006
     D  FFDECN                 8     10  0                                      CFF004
     D  FFDECD                 8     15  0                                      CFF004
     D  FFDECA                 8     15                                         CFF004
 
      ** +--- The converted FFSRDSZ1 ends here ----------------------------+
                                                                                              CFF006
     D FFNOTK1         S             16P 3                                                    CFF006
 
      ** Pass in price
 
     C                   Z-ADD     Price         FFPRIC
 
      ** Execute the standard subroutine
     C                   EXSR      FFTVCL
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      **********************************************************************
      ** +--- The converted FFTVCLZ2 starts here --------------------------+
 
      ****************************************************************
      **                                                             *
      **  SR:FFTVCL   - CALCULATES TRANSACTION VALUE FOR A           *
      **                GIVEN NUMBER OF CONTRACTS AT A GIVEN         *
      **                PRICE IN UNITS OF THE APPROPRIATE            *
      **                TICKS DENOMINATOR OR MINIMUM PRICE           *
      **                FLUCTUATION ( DEPENDING ON WHETHER THE       *
      **                TICKS DENOMINATOR IS 100 )                   *
      **                                                             *
      **  INPUTS      - FFNOC   (5,0P) NUMBER OF CONTRACTS           *
      **                FFPRIC (15,8P) PRICE                         *    CFF004
      **                FFTKDM  (3,0P) TICKS DENOMINATOR             *
      **                FFMNPF (15,8P) MINIMUM PRICE FLUCTUATION     *    CFF004
      **  OUTPUTS     - FFTNVL (13,0P) TRANSACTION VALUE             *
      **                                                             *
      ****************************************************************
 
     C     FFTVCL        BEGSR
 
     C                   Z-ADD     FFNOC         FFNOC             5 0
     C                   Z-ADD     FFPRIC        FFPRIC           15 8
     C                   Z-ADD     FFTKDM        FFTKDM            3 0
     C                   Z-ADD     FFMNPF        FFMNPF           15 8                         CFF00
 
     C                   Z-ADD     0             FFTNVL           13 0
 
      **  If the Ticks Denominator is equal to 100
 
     C     FFTKDM        IFEQ      100
 
      **  Divide Price by Min Price Fluctuation
 
     C*****FFPRIC        DIV       FFMNPF        FFNOTK           13 0                 CFF006 241147
     C     FFPRIC        DIV       FFMNPF        FFNOTK           21 8                        241147
 
     C                   ELSE
      *****************************************************************                       241147
      ****Multiply*integer*of*Price*by*the*Ticks*Denominator***********                       241147
      *****************************************************************                       241147
     C*****FFINTG        MULT      FFTKDM        FFNOTK                                       241147
      *****************************************************************                       241147
      ****The*remaining*fraction*of*the*Price*should*be*added*to*the***                       241147
      ****result*of*Price*integer*X*Ticks*Denominator******************                       241147
      *****************************************************************                       241147
      ****If*Ticks*Denominator*is*between*1*&*10*use*1st*dec*place*****                       241147
      *****************************************************************                       241147
     C*****FFTKDM        IFLE      10                                                         241147
     C**********         ADD       FFDCN1        FFNOTK                                       241147
      *****************************************************************                CFF006 241147
      ****If*CFF006*enhancement*is*installed*and*the*Minimum*Price*Fluctuation         CFF006 241147
      ****is*not*equal*to*zero,*then*perform*new*processing************                CFF006 241147
      *****************************************************************                CFF006 241147
     C**********         IF        FFMNPF <> 0                                         CFF006 241147
     C**********         EVAL      FFNOTK1 = FFNOTK + FFDCN4                           CFF006 241147
     C**********         EVAL      FFNOTK = FFNOTK1 / FFMNPF                           CFF006 241147
     C**********         ENDIF                                                         CFF006 241147
      *****************************************************************                CFF006 241147
     C**********         ELSE                                                                 241147
      *****************************************************************                       241147
      ****If*Ticks*Denominator*is*between*11*&*99*use*1-2nd*dec*places*                       241147
      *****************************************************************                       241147
     C*****FFTKDM        IFLE      99                                                         241147
     C**********         ADD       FFDCN2        FFNOTK                                       241147
      *****************************************************************                CFF006 241147
      ****If*CFF006*enhancement*is*installed*and*the*Minimum*Price*Fluctuation         CFF006 241147
      ****is*not*equal*to*zero,*then*perform*new*processing************                CFF006 241147
      *****************************************************************                CFF006 241147
     C**********         IF        FFMNPF <> 0                                         CFF006 241147
     C**********         EVAL      FFNOTK1 = FFNOTK + FFDCN5                           CFF006 241147
     C**********         EVAL      FFNOTK = FFNOTK1 / FFMNPF                           CFF006 241147
     C**********         ENDIF                                                         CFF006 241147
      *****************************************************************                CFF006 241147
     C**********         ELSE                                                                 241147
      *****************************************************************                       241147
      ***If*Ticks*Denominator*is*between*101*&*999*use*1-3rd*dec*places                       241147
      *****************************************************************                       241147
     C**********         ADD       FFDCN3        FFNOTK                                       241147
      *****************************************************************                CFF006 241147
      ****If*CFF006*enhancement*is*installed*and*the*Minimum*Price*Fluctuation         CFF006 241147
      ****is*not*equal*to*zero,*then*perform*new*processing************                CFF006 241147
      *****************************************************************                CFF006 241147
     C**********         IF        FFMNPF <> 0                                         CFF006 241147
     C**********         EVAL      FFNOTK1 = FFNOTK + FFDCN6                           CFF006 241147
     C**********         EVAL      FFNOTK = FFNOTK1 / FFMNPF                           CFF006 241147
     C**********         ENDIF                                                         CFF006 241147
      *****************************************************************                CFF006 241147
     C**********         END                                                                  241147
      *****************************************************************                       241147
     C**********         END                                                                  241147
     C     FFTKDM        IFLE      10                                                         241147
     C     FFDECD        DIV       10000000      WPRIC1            8 5                        241147
     C                   ELSE                                                                 241147
     C     FFTKDM        IFLE      100                                                        241147
     C     FFDECD        DIV       1000000       WPRIC1                                       241147
     C                   ELSE                                                                 241147
     C     FFTKDM        IFLE      1000                                                       241147
     C     FFDECD        DIV       100000        WPRIC1                                       241147
     C                   ENDIF                                                                241147
     C                   ENDIF                                                                241147
     C                   ENDIF                                                                241147
     C     WPRIC1        DIV       FFTKDM        WDECM             9 8                        241147
     C     FFINTG        ADD       WDECM         WPRIC2           15 8                        241147
     C     FFMNPF        IFNE      0                                                          241147
     C     WPRIC2        DIV       FFMNPF        FFNOTK                                       241147
     C                   ENDIF                                                                241147
 
     C                   END
 
      ** Multiply the number of ticks by the number of contracts
 
     C     FFNOTK        MULT      FFNOC         FFTNVL
 
     C                   ENDSR
 
      ** +--- The converted FFTVCLZ2 ends here ----------------------------+
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      **                              Total transaction value (13,0P)
     C                   PARM                    FFTNVL
      ** Parameters received from caller
      ** -------------------------------
      **                              Number of contracts (5,0P)
     C                   PARM                    FFNOC
      **                              Price (15,8P)
     C                   PARM                    Price
      **                              Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      **                              Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
     C                   ENDSR
 
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
