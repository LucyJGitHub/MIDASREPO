     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF SR/FFPMCL as a mod: calc prem payable')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFPMCL - Subroutine for calculating premium payable on a     *
      *           given number of contracts at a given contract       *
      *           price, converted into a module.                     *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the FFPMCL        *
      *  subroutine.  The subroutine consists of ???? /COPY members.  *
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
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247517             Date 09May07               *
      *                 245129B            Date 12Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 241147A            Date 07Nov06               *
      *                 241147             Date 26Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 215528             Date 21Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFF006             Date 28Nov00               *
      *                 186449             Date 03Jan01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247517 - Reversed fix 241147.                                *
      *  245129B - Wrong premium amount.                              *
      *  241147A - Use old processing of computation of p/l.          *
      *  241147 - Correct the computation of p/l.                     *
      *  215528 - System is associating a wrong premium amount.       *
      *           Applied fixes 136056, 140017 and 140455 from        *
      *           OPM counterpart /copy-FFPMCLZ1.                     *
      *  CFF006 - Fractional Ticks Enhancement.                       *
      *  186449 - Half adjust premium amount if processing type is    *
      *           less than or equal to 6.                            *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Number of contracts
     D FFNOC           S              5P 0
 
      ** Price
     D FFPRIC          S             15P 8
 
      ** Ticks denominator
     D FFTKDM          S              3P 0
 
      ** Minimum price fluctuation
     D FFMNPF          S             15P 8
 
      ** Total transaction value
     D FFTNVL          S             13P 0
 
      ** Instrument type
     D ISPT            S              1S 0
 
      ** Tick value
     D FFTKVL          S             14P 5
 
      ** Yield
     D FFYLD           S             15P 8
 
      ** Contract type
     D FFCNTT          S              1S 0
 
      ** Contingent amount
     D FFCTAM          S             13P 0
                                                                                              215528
      ** Strike Price                                                                         215528
     D FFSTRP          S             15P 8                                                    215528
 
      ** Work variable for computing new Premium Payable                                      CFF006
     D FFTKV2          S             15P 8                                                    CFF006
                                                                                              CFF006
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZYLDZ1 starts here ----------------------------+
 
     D ZPARMS          DS
     D  PRCYLD                 1      1
     D  METHOD                 2      3
     D  SEMANN                 4      4
     D  ERRIND                 5      5
     D  PRICEC                 6     13P 9                                      E15823
     D  YIELDC                14     21P 9                                      E15823
     D  CPRTE                 22     27P 7                                      E15823
     D  NMAT                  28     29P 0                                      E15823
     D  FMAT                  30     35P 9                                      E15823
     D  KPRICE                36     43P 9                                      E15823
     D  YISVAL                44     50P 9                                      E17303
     D  ACCRCY                51     51P 0                                      E15823
     D  CPYEAR                52     53P 0                                      E15823
     D  DYLSTC                54     55P 0                                      E15823
     D  PERIOD                56     57P 0                                      E15823
     D  PAYYRS                58     64P 9                                      E15823
     D  PAYDYS                65     67P 0                                      E15823
     D  VALDTE                68     70P 0                                      E15823
     D  NCPDTE                71     73P 0                                      E15823
     D  MATDTE                74     76P 0                                      E15823
     D  CPTOMT                77     78P 0                                      S01231
     D  PURINT                79     86P 9                                      S01231
     D  DSFCTM                87     88P 0                                      S01231
     D  DYSTNC                89     90P 0                                      S01231
     D  CUMEXF                91     91                                         S01231
     D  COMFRQ                92     93P 0                                      S01397
     D  DSCBSS                94     94                                         S01397
     D  DLCOUP                95     95                                         S01397
 
 
      **  OBTAIN DATE IN YYYYMMDD FORMAT
     D                 DS
     D  ZCENT                  1      2  0
     D  ZYEAR                  3      4  0
     D  ZMTH                   5      6  0
     D  ZDAY                   7      8  0
     D  WRKYMD                 1      8  0
 
      **  NEXT COUPON DATE AS MMDD
     D                 DS
     D  NCMM                   1      2  0
     D  NCDD                   3      4  0
     D  NCMDD                  1      4  0
 
      *   MATURITY DATE AS MMDD
     D                 DS
     D  MTMM                   1      2  0
     D  MTDD                   3      4  0
     D  MATMD                  1      4  0
 
      ** +--- The converted ZYLDZ1 ends here ------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Execute the standard subroutine
     C                   EXSR      FFPMCL
 
     C                   RETURN
 
      /EJECT
      ** +--- The converted FFPMCLZ1 starts here --------------------------+
 
      ****************************************************************
      *                                                              *
      * FFPMCLZ1 - Subroutine to calculate premium payable on a      *
      *            given number of contracts at a given contract     *
      *            price.                                            *
      *                                                              *
      ****************************************************************
 
     C     FFPMCL        BEGSR
 
     C                   Z-ADD     *ZERO         YIELDX           15 8
     C                   Z-ADD     *ZERO         YIELDY           15 8
     C                   Z-ADD     *ZERO         PRICEX           15 9
     C                   Z-ADD     *ZERO         PRICEY           15 9
     C                   Z-ADD     *ZERO         FFPREM           13 0
      *
      * If processing type is in range 1 through 6
      *
     C     ISPT          IFLE      6
      *
      * Calculate the transaction value
      *
     C                   EXSR      FFTVCL
      *****************************************************************               CFF006 241147A
      ***If*enhancement*CFF006*is*installed,*the*Ticks*Denominator*is*not*equal*to*100CFF006 241147A
      ***and*the*Minimum*Price*Fluctuation*is*not*equal*to*blanks,*then*perform*new   CFF006 241147A
      ** processing.***************************************************               CFF006 241147A
     C**********         IF        FFTKDM <> 100                                      CFF006 241147A
     C**********                   AND FFMNPF <> 0                                    CFF006 241147A
     C*****FFTKVL        MULT      FFMNPF        FFTKV2                                CFF006 241147
     C*****FFTKVL        DIV(H)    FFMNPF        FFTKV2                               241147 241147A
     C**********         DIV(H)    100           FFMNPF                               241147 241147A
     C*****FFTNVL        MULT(H)   FFTKV2        FFPREM                               CFF006 241147A
      *                                                                                       CFF006
      ** Otherwise, use old processing.                                                       CFF006
     C**********         ELSE                                                         CFF006 241147A
      *                                                                                       247517
      ** If enhancement CFF006 is installed, the Ticks Denominator is not equal to 100,       247517
      ** and the Minimum Price Fluctuation is not equal to blanks, then perform new           247517
      ** processing.                                                                          247517
     C                   IF        FFTKDM <> 100                                              247517
     C                             AND FFMNPF <> 0                                            247517
     C     FFTKVL        MULT      FFMNPF        FFTKV2                                       247517
     C     FFTNVL        MULT(H)   FFTKV2        FFPREM                                       247517
      *                                                                                       247517
      ** Otherwise, use old processing.                                                       247517
     C                   ELSE                                                                 247517
      *
      * Calculate premium payable by multiplying the transaction value
      * by the tick value
      *
     C*****FFTNVL        MULT      FFTKVL        FFPREM                         186449
     C     FFTNVL        MULT(H)   FFTKVL        FFPREM                         186449
     C     ISPT          IFEQ      5                                                         245129B
     C     FFPREM        DIV(H)    100           FFPREM                                      245129B
     C                   ENDIF                                                               245129B
                                                                                              CFF006
     C**********         ENDIF                                                        CFF006 241147A
     C                   ENDIF                                                                247517
      *
      * If processing type is in range 7 through 8
      *
     C                   ELSE
      *
      * Calculate YieldX and YieldY
      * That is, YieldX = 100 - FFPRIC, and
      *          YieldY = (100 - FFPRIC) + (FFMNPF / 100)
      *
     C*****100**         SUB       FFPRIC        YIELDX                                       215528
     C*****100**         SUB       FFPRIC        W158             15 8                        215528
     C*****FFMNPF        ADD       W158          YIELDY                                       215528
     C     100           SUB       FFSTRP        YIELDX                                       215528
     C     YIELDX        ADD       .01           YIELDY                                       215528
      *
      * Calculate PriceX and PriceY by executing subroutine FFYTOP with
      * YieldX and YieldY.
      *
     C                   Z-ADD     YIELDX        FFYLD
     C                   EXSR      FFYTOP
     C                   Z-ADD     PRICEC        PRICEX
      *
     C                   Z-ADD     YIELDY        FFYLD
     C                   EXSR      FFYTOP
     C                   Z-ADD     PRICEC        PRICEY
      *
      * Calculate premium.
      * That is, Premium = (PriceX - PriceY) x FFCTAM x FFNOC
      *
     C*****PRICEX        SUB       PRICEY        W309             30 9                        215528
     C**********         MULT      FFCTAM        W309                                         215528
     C*****W309*         MULT(H)   FFNOC         FFPREM                                       215528
                                                                                              215528
      ** Convert % price to fraction                                                          215528
                                                                                              215528
     C     FFCNTT        IFEQ      1                                                          215528
                                                                                              215528
     C                   DIV       100           PRICEX                                       215528
     C                   DIV       100           PRICEY                                       215528
                                                                                              215528
      ** Calculate premium for price X                                                        215528
     C     PRICEX        MULT(H)   FFCTAM        W300             30 0                        215528
     C     W300          MULT(H)   FFNOC         FFPREM                                       215528
     C                   MULT(H)   FFPRIC        FFPREM                                       215528
     C                   MULT      100           FFPREM                                       215528
                                                                                              215528
      ** Calculate premium for price Y                                                        215528
     C     PRICEY        MULT(H)   FFCTAM        W300                                         215528
     C     W300          MULT(H)   FFNOC         WW130            13 0                        215528
     C                   MULT(H)   FFPRIC        WW130                                        215528
     C                   MULT      100           WW130                                        215528
                                                                                              215528
      ** Final premium is the difference between the two                                      215528
     C                   SUB       WW130         FFPREM                                       215528
                                                                                              215528
     C                   ELSE                                                                 215528
                                                                                              215528
     C     PRICEX        SUB       PRICEY        W309             30 9                        215528
     C                   MULT      FFCTAM        W309                                         215528
     C     W309          MULT(H)   FFPRIC        WW130                                        215528
     C     WW130         MULT(H)   FFNOC         FFPREM                                       215528
                                                                                              215528
     C                   ENDIF                                                                215528
      *
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
 
      ** +--- The converted FFPMCLZ1 ends here ----------------------------+
 
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *  FFPMCL in this module executes another standard subroutine,       *
      *  FFTVCL, which has also been converted to a module.                *
      *  This subroutine is also called FFTVCL and simply does a CALLB to  *
      *  the module that contains subroutine FFTVCL                        *
      **********************************************************************
 
     C     FFTVCL        BEGSR
 
     C                   CALLB     'FFTVCL'
      ** Outputs
      ** -------
      **                              Total transaction value (13,0P)
     C                   PARM                    FFTNVL
      ** Inputs
      ** ------
      **                              Number of contracts (5,0P)
     C                   PARM                    FFNOC
      **                              Price (15,8P)
     C                   PARM                    FFPRIC
      **                              Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      **                              Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *  FFPMCL in this module executes another standard subroutine,       *
      *  FFYTOP, which has also been converted to a module.                *
      *  This subroutine is also called FFYTOP and simply does a CALLB to  *
      *  the module that contains subroutine FFYTOP                        *
      **********************************************************************
 
     C     FFYTOP        BEGSR
 
     C                   CALLB     'FFYTOP'
      ** Output
      ** ------
      **                              Price (15,9P)
     C                   PARM                    PRICEC
      ** Inputs
      ** ------
      **                              Yield (11,7P)
     C                   PARM                    FFYLD
      **                              Contract type (1,0S, from INTYPD)
     C                   PARM                    FFCNTT
 
     C                   ENDSR
 
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
      ** Outputs
      ** -------
      **                              Premium (13,0P)
     C                   PARM                    FFPREM
      ** Inputs
      ** ------
      **                              Number of contracts (5,0P)
     C                   PARM                    FFNOC
      **                              Price (15,8P)
     C                   PARM                    FFPRIC
      **                              Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      **                              Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
      **                              Tick Value (14,5P)
     C                   PARM                    FFTKVL
      **                              Instrument type (1,0S)
     C                   PARM                    ISPT
      **                              Contract type (1,0S, from INTYPD)
     C                   PARM                    FFCNTT
      **                              Contingent amount (13,0P), from INTYPD)
     C                   PARM                    FFCTAM
      **                              Strike Price (15,8P)                                    215528
     C                   PARM                    FFSTRP                                       215528
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
