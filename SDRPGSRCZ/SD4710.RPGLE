     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Standing Data Authorisation Summary Rpt')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD4710  - Standing Data Requiring Authorisation Summary Rpt  *
      *                                                               *
      *  Function:  This program will report all the items of         *
      *             Standing Data which have not been authorised.     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Phase(s): I/C - On Request.                                  *
      *            COB - Automatic.                                   *
      *                                                               *
      *  Called By: SDC4710 Midas SD equiring Authorisation Summary   *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD028             Date 22Aug05               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD028 - KYC (Standing Data Authorisations)                  *
      *  CSD012 - Standing Data Requiring Authorisation               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                    FUNCTION OF INDICATORS                     *
      *                    **********************                     *
      *                                                               *
      *   50  - No Record to Report                                   *
      *   60  - Print blank line before printing details              *
      *   61  - Print authorisation status                            *                       CSD028
      *   80  - End of File SDAULGL2                                  *
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
      *  Sr_Trailer - Subroutine to Write End of Report Trailer.      *
      *  Sr_Audit - Subroutine to Output Audit report and End Program.*
      *  Sr_RCFA  - Subroutine to register SD4710AU via RCF.          *
      *  Sr_RCFP  - Subroutine to register SD4710P1 via RCF.          *
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
     FSDAULGL2  IF   E           K DISK    INFSR(*PSSR)
      ** SD Standing Data Requiring Authorisation Summary
      *
     FSD4710P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
      ** Standing Data Requiring Authorisation Summary - Detail Report
      *
     FSD4710AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      ** Standing Data Requiring Authorisation Summary - Audit Report
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data Structure for Access Objects, Short Data Structure
      *
      ***  File Information Data Structure for SD4710P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ***  File Information Data Structure for SD4710AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *                                                                                       CSD028
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD028
      *                                                                                       CSD028
      ** Data Structure for SAR Details                                                       CSD028
      *                                                                                       CSD028
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
     D OldALFUNC       S                   LIKE(ALFUNC)
      *                                                                                       CSD028
     D P@Rtcd          S              7                                                       CSD028
     D P@Optn          S              7                                                       CSD028
     D PSard           S              6                                                       CSD028
     D CSD028          S              1                                                       CSD028
      *                                                                                       CSD028
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     C/EJECT
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
      *                                                                                       CSD028
      ** Check if CSD028 is installed                                                         CSD028
      *                                                                                       CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   CALL      'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       P@Rtcd                                       CSD028
     C                   PARM      '*VERIFY'     P@Optn                                       CSD028
     C                   PARM      'CSD028'      PSard                                        CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
      *                                                                                       CSD028
      ** Database error                                                                       CSD028
      *                                                                                       CSD028
     C                   IF        (P@Rtcd <> *BLANKS) and                                    CSD028
     C                             (P@Rtcd <> '*NRF   ')                                      CSD028
     C     *LOCK         IN        LDA                                                        CSD028
     C                   EVAL      DBKEY = 'CSD028'                                           CSD028
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
     C                   EVAL      DBASE = 2                                                  CSD028
     C                   OUT       LDA                                                        CSD028
     C                   EXSR      *PSSR                                                      CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   IF        P@Rtcd  = *BLANKS                                          CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   Move      *ON           *IN61                                        CSD028
     C                   ENDIF                                                                CSD028
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
     C                   PARM                    PLVL              1
     C                   PARM                    PRENT             3
      *
      *
      ** Initialise LDA field.
     C                   Movel     'SD4710'      DBPGM
      *
      ** Access Bank details via access program
     C                   Call      'AOBANKR0'
     C                   PARM      '       '     ULRTCD            7
     C                   PARM      '*FIRST '     ULOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     ULRTCD        Ifne      *BLANK
     C                   Movel     'SDBANKPD'    DBFILE                          *************
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
     C                   Z-Add     *ZERO         A1RCNT                         No of Recds
      *
      ** Write Report header and column headings
     C                   Write     PGHEADER
     C                   Write     DTHEADER
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
      ** Access records from the Midas Standing Data Authorisation File
      *  PF/SDAULGPD via the logical file SDAULGL2
      *
     C                   Move      *Blanks       OldALFUNC
      *
     C     *LOVAL        SETLL     SDAULGL2
     C                   Read      SDAULGL2                               80
      *
     C     *IN80         Doweq     *OFF
      *
      ** Separate each set of Function by printing a blank line
     C     ALFUNC        Ifne      OldALFUNC
     C                   Move      *ON           *IN60
     C                   Endif
      *
     C                   IF        ((ALSTAT = *Blanks or ALSTAT = 'R' OR                      CSD028
     C                             ALSTAT = 'A') and CSD028 = 'Y') OR                         CSD028
     C                             CSD028 = 'N'                                               CSD028
     C                   Add       1             A1RCNT
     C                   Exsr      Sr_Print
     c                   ENDIF                                                                CSD028
      *
      ** Store old Function details
     C                   Move      ALFUNC        OldALFUNC
      *
     C                   Read      SDAULGL2                               80
      *
     C                   Enddo
      *
      *
      ** End of file so write trailer
     C                   Exsr      Sr_Trailer
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/Sr_Print
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
     C                   Movel     ALKEY         P1KEY
     C                   Movel     ALFUNC        P1FUNC
     C                   Movel     ALACTN        P1ACTN
     C                   Movel     ALUSER        P1USER
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   Movel     ALSTAT        P1ALSTAT                                     CSD028
     C                   ENDIF                                                                CSD028
      *
     C                   Write     DETAIL
      *
      ** Set off the print blank line indicator
     C                   Move      *OFF          *IN60
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/Sr_Trailer
      *****************************************************************
      *                                                               *
      *  Sr_Trailer - Subroutine to Write End of Report Trailer       *
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
      *
     C     A1RCNT        Ifeq      0
     C                   Move      *ON           *IN50
     C                   Endif
      *
      ** Write Trailer
      *
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
      *
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
      *
     C                   SETON                                        LR
     C                   Return
      *
     C                   Endsr
      *
      *****************************************************************
      /TITLE SR/Sr_RCFP
      *****************************************************************
      *                                                               *
      *  Sr_RCFP - Subroutine to register SD4710P1 via RCF.           *
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
     C                   PARM                    PRENT
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
      /TITLE SR/Sr_RCFA
      *****************************************************************
      *                                                               *
      *  Sr_RCFA - Subroutine to register SD4710AU via RCF            *
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
