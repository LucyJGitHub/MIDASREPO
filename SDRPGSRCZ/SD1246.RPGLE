     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Cashier Transaction Type Posting Details Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD1241  - Cashier Transaction Types Posting Report           *
      *                                                               *
      *  Function:  This program will produce the following reports:  *
      *                                                               *
      *             Input Cycle - Listing of all the Commission Codes *
      *             COB         - Listing of all the Commission Code  *
      *                           that has been changed today.        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Phase(s): I/C - On Request.                                  *
      *            COB - Automatic                                    *
      *                                                               *
      *  Called By: SDC1246 Cashier Transaction Types Posting Details *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB023             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRT012  *CREATE    Date 12May03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *  CRT012 - Midas/Cashier Interface - Multiple Charges          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                    FUNCTION OF INDICATORS                     *
      *                    **********************                     *
      *                                                               *
      *   50  - No Record to Report                                   *
      *   60  - Print description in COB mode                         *
      *   80  - End of File SDBACTL0                                  *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                      SUBROUTINE INDEX                         *
      *                      ****************                         *
      *                                                               *
      *  Sr_Init  - Subroutine to do Program Initialisation.          *
      *  Sr_Proc  - Subroutine to do Detail Processing.               *
      *  Sr_Print - Subroutine to Print detail record.                *
      *  Sr_Trailer - Subroutine to Write End of Report.              *
      *  Sr_Audit - Subroutine to Output Audit report and End Program.*
      *  Sr_RCFA  - Subroutine to register SD1241AU via RCF.          *
      *  Sr_RCFP  - Subroutine to register SD1241P1 via RCF.          *
      *  Sr_Term  - Subroutine to Terminate program                   *
      *  *PSSR    - Program exception error routine.                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Standing Data Requiring Authorisation Summary
     FSDCTPOL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Standing Data Cashier Transaction Type Posting - Detail Report
     FSD1246P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
      *
      ** Standing Data Cashier Transaction Type Posting - Audit Report
     FSD1246AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
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
      *
      ** The following fields are defined in the external file:
      *                                     134 141 DBFILE
      *                                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D*SDBANK***     E DS                  EXTNAME(SDBANKPD)                                  CCB023
     D SDSBNK        E DS                  EXTNAME(SDSBNKTD)                                  CCB023
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data Structure for Access Objects, Short Data Structure
      *
      ***  File Information Data Structure for SD1241P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ***  File Information Data Structure for SD1241AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZSFILE
     D PSEQ            S              5
     D ZSNUMU          S              6  0
      *
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
      *
     D PMODE           S              1
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
     C                   Exsr      Sr_Init
      *
      ***  Perform Detail Processing.
     C                   Exsr      Sr_Proc
      *
      ***  Output Audit Report and End Program.
     C                   Exsr      Sr_Audit
      *
      ***  Perform Termination Processing.
     C                   Exsr      Sr_Term
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      *
      *****************************************************************
      *                                                               *
      *  SR_Init   - Subroutine to do Program Initialisation.         *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     AOBANKR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     SR_Init       Begsr
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
      **  Receive Parameter List
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    PMODE
      *
      ** Initialise LDA field.
     C                   Movel     'SD1246'      DBPGM
      *
      ** Access Bank details via access program
     C**********         Call      'AOBANKR0'                                                 CCB023
     C**********         PARM      '       '     ULRTCD            7                          CCB023
     C**********         PARM      '*FIRST '     ULOPTN            7                          CCB023
     C*****SDBANK        PARM      SDBANK        DSFDY                                        CCB023
     C                   CALL      'AOSBNKR0'                                                 CCB023
     C                   PARM      '       '     ULRTCD            7                          CCB023
     C                   PARM      '*FIRST '     ULOPTN            7                          CCB023
     C     SDSBNK        PARM      SDSBNK        DSFDY                                        CCB023
      *
     C     ULRTCD        Ifne      *BLANK
     C**********         Movel     'SDBANKPD'    DBFILE                          *************CCB023
     C                   MOVEL     'SDSBNKTD'    DBFILE                                       CCB023
     C                   Movel     '01'          DBASE                           *DBERROR 001*
     C                   Exsr      *PSSR                                         *************
     C                   End
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      *                            MMDDYY (*IN98 on).
     C     BJDFIN        Ifeq      'M'
     C                   SETON                                        98
     C                   Endif
      *
      ** RCF Processing for Printer File
     C                   Exsr      Sr_RCFP
      *
      ** RCF Processing for Audit File.
     C                   Exsr      Sr_RCFA
      *
      ** Report Work fields.
     C                   Z-Add     0             RQDLN1
     C                   Z-Add     0             DIFLN1
      *
      ** Initialise all working fields
     C                   Z-Add     *ZERO         A1RCNT                         No of Rejn Code
      *
     C     PMODE         Ifeq      'A'
     C                   Move      *ON           *IN60
     C                   Endif
      *
      ** Write Report header and coulombs headings
     C                   Write     PGHEADER                                     Report header
     C                   Write     DTHEADER                                     Coulombs Header
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/Sr_Proc
      *****************************************************************
      *                                                               *
      *  Sr_Proc  - Subroutine to do Detail Processing.               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Proc       Begsr
      *
      ** Input Cycle - MODE = ' '
      *  COB         - MODE = 'A'
      *
      ** Access records from the Cashier Transaction Types Posting Details
      *  file PF/SDCTPOPD via the logical file SDCTPOL0
      *
     C     *LOVAL        SETLL     SDCTPOL0
     C                   Read      SDCTPOL0                               80
      *
     C     *IN80         Doweq     *OFF
      *
     C     PMODE         Ifeq      'A'
     C     CPLCD         Andeq     BJRDNB
     C     PMODE         OrNe      'A'
      *
     C                   Add       1             A1RCNT
     C                   Exsr      Sr_Print
      *
     C                   Endif
      *
     C                   Read      SDCTPOL0                               80
      *
     C                   Enddo
      *
      ** End of file so write trailer
     C                   Exsr      Sr_Trailer
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/SRPRNT
      *****************************************************************
      *                                                               *
      *  Sr_Print - Subroutine to write detail record                 *
      *                                                               *
      *  Called By: Sr_Proc                                           *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Print      Begsr
      *
      ** Check that sufficient lines remain for the Format. If not,
      *  write out the Main Headings on a new page.
      *
     C                   Z-Add     1             RQDLN1
     C     OFLLN1        Sub       PRTLN1        DIFLN1
     C     DIFLN1        Ifle      RQDLN1
     C                   Write     PGHEADER
     C                   Write     DTHEADER
     C                   Endif
      *
      *
      ** Populate the output fields.
     C                   Movel     CPBRCA        P1BRCA
     C                   Movel     CPCTRT        P1CTRT
      *
     C     CPACOD        IfNe      *Zeros
     C                   Movel     CPACOD        P1ACOD
     C                   Else
     C                   Move      *Blanks       P1ACOD
     C                   Endif
      *
     C     CPACSQ        IfNe      *Zeros
     C                   Movel     CPACSQ        P1ACSQ
     C                   Else
     C                   Move      *Blanks       P1ACSQ
     C                   Endif
      *
     C                   Movel     CPCUST        P1CUST
      *
     C     CPSTDY        IfNe      *Zeros
     C                   Movel     CPSTDY        P1STDY
     C                   Else
     C                   Move      *Blanks       P1STDY
     C                   Endif
      *
     C                   Movel     CPNARR        P1NARR
     C                   Movel     CPVALD        P1VALD
     C                   Movel     CPPLMI        P1PLMI
     C                   Movel     CPCHQC        P1CHQC
     C                   Movel     CPGROS        P1GROS
     C                   Movel     CPLCTP        P1LCTY
      *
     C                   Write     DETAIL
      *
      ** Set off the print blank line indicator
     C                   Move      *OFF          *IN60
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/SREND
      *****************************************************************
      *                                                               *
      *  Sr_End - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: Sr_Proc                                           *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Trailer    Begsr
      *
      ** Check that sufficient lines remain for the Format. If not,
      *  write out the Main Headings on a new page.
      *
     C                   Z-Add     4             RQDLN1
     C     OFLLN1        Sub       PRTLN1        DIFLN1
     C     DIFLN1        Ifle      RQDLN1
     C                   Write     PGHEADER
     C                   Endif
      *
      ** If no record processed then write 'NO RECORD TO REPORT'
      *  on the Rejection Code List report.
      *
     C     A1RCNT        Ifeq      0
     C                   Move      *ON           *IN50
     C                   Endif
      *
      ** Write Trailer
     C                   Write     TRAILER
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/Sr_Audit
      *****************************************************************
      *                                                               *
      *  Sr_Audit - Subroutine to Output Audit report and End Program *
      *                                                               *
      *  Called By: Main Processing, Sr_Proc, *PSSR                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
     C     Sr_Audit      Begsr
      *
      ** Output Report Header and File Controls.
     C                   Write     HEADERAU
     C                   Write     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
     C     *INU7         Ifeq      *ON
     C                   Write     DBERROR
     C                   Else
      *
      ** Or, if no records read, Output "No Details" message.
     C     A1RCNT        Ifeq      0
     C                   Write     NODTLS
     C                   Endif
     C                   Endif
      *
      ** Write Trailer for Audit Report.
      *
     C                   Write     AUTRAIL
      *
      ** End Program and Return.
     C                   SETON                                        LR
     C                   Return
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/SRRCFP
      *****************************************************************
      *                                                               *
      *  Sr_RCFP - Subroutine to register SD1241P1 via RCF.           *
      *                                                               *
      *  Called By: Sr_Init                                           *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     Sr_RCFP       Begsr
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PRENT             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      *  Calling Program.
      *
     C     ZSERR         Ifeq      'Y'
     C                   SETON                                        U7U8LR
     C                   Return
     C                   Endif
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/SRRCFA
      *****************************************************************
      *                                                               *
      *  Sr_RCFA - Subroutine to register SD1241AU via RCF            *
      *                                                               *
      *  Called By: Sr_Init                                           *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     Sr_RCFA       Begsr
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-add     SFNUMU        ZSNUMU
      *
     C                   Call      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PRENT
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         Ifeq      'Y'
     C                   SETON                                        U7U8LR
     C                   Return
     C                   Endif
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         Begsr
      *
     C     WWRUN         Ifeq      *BLANK
     C                   Move      'Y'           WWRUN             1
     C                   SETON                                        U7U8LR
     C                   Dump
     C                   Exsr      Sr_Audit
     C                   RETURN
     C                   Endif
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   Return
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/Sr_Term
      *****************************************************************
      *                                                               *
      *  Sr_Term  - Subroutine to do Terminate program                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Term       Begsr
     C                   SETON                                        LR
     C                   RETURN
     C                   Endsr
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
