     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Outgoing Messages Trace Purge.')              *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1485 - Outgoing Messages Trace Purge.                      *
      *                                                               *
      *  Function: This module deletes, from trace, all outgoing      *
      *            messages, date of which is older than retention    *
      *            period that was specified for each type of message.*
      *                                                               *
      *  Component of: RPC1485 - Clear Trace outgoing messages.       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. 249867  *CREATE    Date 22Jun12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249867 - EOD component RPC1400 runs for so long.             *
      *           Applied fix 238431.                                 *
      *           Applied for AR995838 (Child: AR996874)              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **  Midas PB Meridian copy queues control file by message type.
     FRPTRAQL1  IF   E           K Disk
     F                                     Infsr(*Pssr)

      **  Midas PB outgoing message trace file by message type and date desc.
     FRPTRACL3  UF   E           K Disk
     F                                     RENAME(RPTRACD0:RPTRACD3)
     F                                     Infsr(*Pssr)

      **  Midas PB Outgoing Messages Trace Purge - Report.
     FRP1485P1  O    E             Printer Infds(Spool1)
     F                                     Infsr(*Pssr)
     F                                     Usropn

      **  Midas PB Outgoing Messages Trace Purge - Audit Report.
     FRP1485AU  O    E             PRINTER Infds(SpoolU)
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  End of file RPTRAQL1.                                 *
      *  82  -  End of file RPTRACL3.                                 *
      *  99  -  Error while printer files opening.                    *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   xx *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   xx      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Report - Subroutine to print details of processed record.   *
      *  #Rcfp1  - Subroutine to register the P1 Printer File via RCF *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *  #Audit  - Subroutine to Output Audit report.                 *
      *  *Pssr   - Program exception error routine                    *
      *  *inzsr  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      /Eject
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)

      **  File Information Data Structure for printer file RP1485P1.
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0

      **  File Information Data Structure for printer file RP1485AU.
     D Spoolu          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0

      **  External Data structure for Local data area (database error details).
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)

      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)

      **  Data structure for access programs, short data structure.
     D Dsfdy         E DS                  Extname(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      ** ---------- End of fields used by access programs -----------**

      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off

      **  Fields used to check that sufficient lines remain for the
      **  printer file record format.
     D Difln1          S              2  0
     D Rqdln1          S              2  0

      **  Work Field used to open P1 printer file only once.
     D W_OpenP1        S              1A

      **  Work Field used to handle report page break.
     D WLIGNE          S              2  0

      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A

      ** Date from which to delete records.
     D W_DATE          S                   LIKE(BJRDNB)

      ** Number of deleted records by message type.
     D W_DELN          S                   LIKE(RCOUNT)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************
     C     Start         Tag

      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.

      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************

      **  Read first message type to be processed.

     C     *LOVAL        SETLL     RPTRAQL1
     C                   READ      RPTRAQL1                               81

      **  Do while message types to process.

     C     *IN81         DOWEQ     False                                        Begin Do_W_N81

      **  Set date to position to according to retention period.

     C                   EVAL      W_DATE = BJRDNB - RPREPD

      **  Position to first record to delete.

     C     TRCKEY        SETLL     RPTRACL3
     C     RPTRAF        READE     RPTRACL3                               82
     C                   EVAL      W_DELN = 0

      **  Do while outgoing messages to delete.

     C     *IN82         DOWEQ     False                                        Begin Do_W_N82

     C                   DELETE    RPTRACD3
     C                   EVAL      W_DELN = W_DELN + 1
     C                   EVAL      RCOUNT = RCOUNT + 1

      **  Read next outgoing message.

     C     RPTRAF        READE     RPTRACL3                               82

     C                   ENDDO                                                  End Do_W_N82

      **  Print message type deletion information on report.
     C                   IF        W_DELN > 0
     C                   EXSR      #Report

     C                   ENDIF

      **  Read next message type to process.

     C                   READ      RPTRAQL1                               81

     C                   ENDDO                                                  End Do_W_N81

      **  If at least one line has been printed.
     C     WLIGNE        IFGT      0                                            Begin RCOUNT

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   EVAL      Rqdln1 = 2
     C                   EVAL      Difln1 = Oflln1 - Prtln1
     C     Difln1        IFLE      Rqdln1                                       Begin Difln1

     C                   WRITE     HEADP1

     C                   ENDIF                                                  End Difln1

      **  Write out Trailer Format.
     C                   EVAL      P1DELT = RCOUNT
     C                   WRITE     ENDPAG1

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.

     C                   EVAL      Rqdln1 = 4
     C                   EVAL      Difln1 = Oflln1 - Prtln1
     C     Difln1        IFLE      Rqdln1                                       Begin Difln1

     C                   WRITE     HEADP1

     C                   ENDIF                                                  End Difln1

     C                   WRITE     TRAILP1

      **  Close Security Details take on Report printer file.
     C                   CLOSE     RP1485P1

     C                   ENDIF                                                  End RCOUNT

      **  Print Audit Report.
     C                   EXSR      #Audit

      **  End Program and Return.
     C                   EVAL      *inlr = '1'
     C                   RETURN

      /Eject
      *****************************************************************
      /Title SR/#Report
      *****************************************************************
      *                                                               *
      *  #Report - Subroutine to print details of processed record.   *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     #Report       BEGSR                                                  ** #Report SR **

      **  Insure Audit Report Spool File was recorded by RCF.
     C     W_OpenP1      IFEQ      *blank                                       Begin W_OpenP1
     C                   EVAL      W_OpenP1 = 'Y'
     C                   OPEN      RP1485P1
     C                   EXSR      #RCFP1

      **  Force header format printing.
     C                   EVAL      Prtln1 =  Oflln1

     C                   ENDIF                                                  End W_OpenP1

      **  Set up report printer file fields.
     C                   EVAL      P1TYPE = RPTYPE                              Message Type
     C                   EVAL      P1ACTI = RPACTI                              Activation flag
     C                   EVAL      P1REPD = RPREPD                              Retention period

      **  Format From Date Deleted.
     C                   CALLB     'ZDATE2'
     C                   PARM      RPDATE        ZDayno            5 0          I:Message Date
     C                   PARM      BJDFIN        Zdfin             1            I:Date format ind.
     C                   PARM                    ZDate             6 0          O:Value date
     C     P1DATF        PARM                    Zadate            7            O:Date DDMMMYY

      **  Format To Date Deleted.
     C                   CALLB     'ZDATE2'
     C                   PARM      W_DATE        ZDayno            5 0          I:Message Date
     C                   PARM      BJDFIN        Zdfin             1            I:Date format ind.
     C                   PARM                    ZDate             6 0          O:Value date
     C     P1DATT        PARM                    Zadate            7            O:Date DDMMMYY

     C                   EVAL      P1DELN = W_DELN                              Number deleted

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   EVAL      Rqdln1 = 1
     C                   EVAL      Difln1 = Oflln1 - Prtln1
     C     Difln1        IFLE      Rqdln1                                       Begin Difln1

      **  If end of page, print relevant record format.
     C     WLIGNE        IFGT      0                                            Begin RCOUNT
     C                   WRITE     ENDPAG1

     C                   ENDIF                                                  End RCOUNT

     C                   WRITE     HEADP1

     C                   ENDIF                                                  End Difln1

      ** Write record details.
     C                   WRITE     DETAIL1
     C                   EVAL      WLIGNE = WLIGNE + 1

     C                   ENDSR

      /Eject
      *****************************************************************
      /Title SR/#Rcfp1
      *****************************************************************
      *                                                               *
      *  #Rcfp1  - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     pgm ZSFILE                                        *
      *                                                               *
      *****************************************************************

     C     #Rcfp1        Begsr                                                  ** #Rcfp1 SR **

      **  Ensure Report Spool File recorded by RCF.

     C                   EVAL      Zsnum1 = Sfnum1
     C                   MOVE      Sfnum1        Zsnum1

     C                   CALL      'ZSFILE'
     C                   PARM      *Blanks       Seq               5
     C                   PARM                    Senty             3
     C                   PARM                    Sfile1
     C                   PARM                    Zsnum1            6 0
     C                   PARM                    Zserr             1

      **  If any Error occurred during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         IFEQ      'Y'                                          Begin Zserr
     C                   EVAL      *inu7 = True
     C                   EVAL      *inu8 = True
     C                   EVAL      *inlr = True
     C                   RETURN

     C                   ENDIF                                                  End Zserr

     C                   ENDSR

      /Eject
      *****************************************************************
      /Title SR/#Rcfau
      *****************************************************************
      *                                                               *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: #Audit                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************

     C     #Rcfau        Begsr                                                  ** #Rcfau SR **

      **  Ensure Audit Spool File recorded by RCF.
     C                   MOVE      Sfnumu        Zsnumu

     C                   CALL      'ZSFILE'
     C                   PARM      *Blanks       Seq
     C                   PARM      *Blanks       Senty
     C                   PARM                    Sfileu
     C                   PARM                    Zsnumu            6 0
     C                   PARM      *Blank        Zserr

      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         IFEQ      'Y'                                          Begin Zserr
     C                   EVAL      *inu7 = True
     C                   EVAL      *inu8 = True
     C                   EVAL      *inlr = True
     C                   RETURN

     C                   ENDIF                                                  End Zserr

     C                   ENDSR

      /Eject
      *****************************************************************
      /Title SR/#Audit
      *****************************************************************
      *                                                               *
      *  #Audit - Subroutine to output Audit report.                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     #Audit        BEGSR                                                  ** #Audit SR **

      **  Ensure Audit Report Spool File Recorded by RCF.
     C                   EXSR      #Rcfau

      **  Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL

      **  If there is a DB Error, output the DB Error Information.
     C     *inu7         IFEQ      *on                                          Begin *inu7
     C                   WRITE     DBERROR

     C                   ELSE                                                   Else *inu7

      **  Or, if no records read, output "No Details" message.
     C     RCOUNT        IFEQ      0                                            Begin RCOUNT
     C                   WRITE     NODTLS

     C                   ENDIF                                                  End RCOUNT

     C                   ENDIF                                                  End *inu7

     C                   ENDSR

      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program jus once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************

     C     *Pssr         Begsr                                                  ** *Pssr SR **

     C     W_RunBefore   IFNE      'Y'                                          Begin W_RunBefore
     C                   EVAL      W_RunBefore = 'Y'

     C                   EVAL      *inu7 = True
     C                   EVAL      *inu8 = True

     C                   DUMP
     C                   CALLB     'DBERRCTL'

      **  Ouput Audit Report.
     C                   EXSR      #Audit

     C                   ENDIF                                                  End W_RunBefore

     C                   EVAL      *inlr = True
     C                   RETURN

     C                   ENDSR

      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      *  *Inzsr  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     *Inzsr        BEGSR                                                  ** *Inzsr SR **

      ** Key list definition for access to outgoing messages trace file.
     C     TRCKEY        KLIST
     C                   KFLD                    RPTRAF
     C                   KFLD                    W_DATE

      **  Access Bank details by using access program.
     C                   CALL      'AOBANKR0'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*FIRST '     P_optn
     C     Sdbank        PARM      Sdbank        Dssdy

      **  If Bank details do not exist, handle database error.
     C     P_Rtcd        IFNE      *blanks                                      Begin P_Rtcd
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDBANKPD'                          ***************
     C                   EVAL      Dbase  = 01                                  * Db Error 01 *
     C                   EVAL      Dbkey  = '*first'                            ***************
     C                   OUT       LDA
     C                   EXSR      *Pssr

     C                   ENDIF                                                  End  P_Rtcd

     C                   ENDSR
      /Eject
      *****************************************************************
**Ctdata Cpy@
(c) Finastra International Limited 2021
