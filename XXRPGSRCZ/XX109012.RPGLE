     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('G-AML FTP Audit Report')                               *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      ***SCJ00003*-*G-AML*FTP*Audit*Report*****************************
      *  XX109012 - G-AML FTP Audit Report                            *
      *                                                               *
      *  Function:  This program reports the FTP commands allowing    *
      *             the error to be viewed                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 23May18               *
      *  Prev Amend No. JMI026  *Create    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML FTP PreProcessor (Upgrade to FB Midas)        *
      *  JMI026 - G-AML FTP PreProcessor                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** TCP/IP FTP Output File
     F*SCFTPOPP  IF   E             DISK    INFSR(*PSSR)                                      JMI109
     FXXFTPOPD  IF   E             DISK    INFSR(*PSSR)                                       JMI109
     F                                     USROPN
      *
      ** FTP Audit Report
     F*SCJ00003P1O    E             PRINTER INFDS(SPOOL1)                                     JMI109
     FXX109012P1O    E             PRINTER INFDS(SPOOL1)                                      JMI109
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File Information Data Structure for GLJ104P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Other fields used
     D WRun            S              1    INZ(' ')
     D WFirst          S              1    INZ('Y')
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C*****              OPEN      SCFTPOPP                                                   JMI109
     C*****              READ      SCFTPOPP                               88                  JMI109
     C                   OPEN      XXFTPOPD                                                   JMI109
     C                   READ      XXFTPOPD                               88                  JMI109
     C*****              OPEN      SCJ00003P1                                                 JMI109
     C                   OPEN      XX109012P1                                                 JMI109
      *
     C     *IN88         DOWEQ     *OFF
      *
      ** Process Report Lines.
     C                   EXSR      SRPrint
      *
      ** Read next record.
     C*****              READ      SCFTPOPP                               88                  JMI109
     C                   READ      XXFTPOPD                               88                  JMI109
      *
     C                   ENDDO

     C*****              CLOSE     SCFTPOPP                                                   JMI109
     C                   CLOSE     XXFTPOPD                                                   JMI109
     C*****              CLOSE     SCJ00003P1                                                 JMI109
     C                   CLOSE     XX109012P1                                                 JMI109

     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
     C                   CLEAR                   DETAIL

     C                   MOVEL     GFTPO         POUTDL
      ** Write Detail
     C                   WRITE     DETAIL

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************

     C     SREnd         BEGSR
      *
      ** End Program
     C                   EVAL      *INLR ='1'
     C                   RETURN

     C                   ENDSR
      *
      *****************************************************************
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd             7
     C                   PARM                    PSeq              5
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
