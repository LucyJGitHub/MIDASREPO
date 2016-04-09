     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Corporate actions events maintenance')        *
/*OVRF*: OVRDBF FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)              : *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7502 - SE Corporate Actions Events Maintenance             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247764             Date 12Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 28Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 215168             Date 26Mar03               *
      *                 215165             Date 24Mar03               *
      *                 BUG2686            Date 31May04               *
      *                 CGL029             Date 01Sep03               *
      *                 208241             Date 17Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190204             Date 31May01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE020             Date 21Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156687             Date 08Mar99               *
      *                 155622             Date 22Feb99               *
      *                 148743             Date 25Nov98               *
      *                 137884             Date 20Jul98               *
      *                 149983             Date 10Dec98               *
      *                 138962             Date 13Aug98               *
      *                 137879             Date 01Jul98               *
      *                 136933             Date 25Jun98               *
      *                 136930             Date 17Jun98               *
      *                 136428             Date 15Jun98               *
      *                 136420             Date 11Jun98               *
      *                 136421             Date 08JUN98               *
      *                 136419             Date 05Jun98               *
      *                 CEU017             Date 24Feb98               *
      *                 CSE007             Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  247764 - Database Error on Corporate Action Screen.  Apply   *
      *           UBS-MAD local fix 221720.                           *
      *  221720 - Looping and other numerous problems caused by fix   *
      *           215165. Fix is to revert fix 215165 and create a new*
      *           fix for that error.                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  215168 - Not able to '?' on security and corporate action    *
      *           type field. Fix is to call SE0043 and SE7501S if '?'*
      *           is issued in these fields.                          *
      *  215165 - No Option shortname If option = 1 in Input          *
      *  BUG2686- Check whether lock job is active then update        *
      *           file SECOFRPD if not.                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208241 - Recompiled over changed /CPY ZSDESCZ3.              *
      *  190204 - Recompiled due to changes in PF/SECODVPD.           *
      *  CSE016 - Extended Security Descriptions                      *
      *  CSE020 - Corporate Actions Domino Effect Processing          *
      *  156687 - Corporate Actions: Keep the lock on reference when  *
      *           pressing F11 - Change Option(s).                    *
      *  155622 - Corporate Actions:                                  *
      *           1. Review setup of default values for fields Market *
      *              Cum Price and Market Ex-Price.                   *
      *           2. General Information Screen not validated in input*
      *  148743 - Corporate Actions: Add Rights Tradable fields to    *
      *           link 'FR' Corporate Action with 'EX' Corporate      *
      *           Action.                                             *
      *  137884 - Corporate Actions: Cash fields can be changed even  *
      *           if the Corporate action is stock authorised.        *
      *  149983 - EMU: Block OLD Security for Sale as well            *
      *  138962 - Corporate Actions: various errors:                  *
      *           1. When Corporate Type Exercises and Conversion     *
      *              linked to Dividend Events or Right Issues was    *
      *              creatyed using amendments on Dividend Events or  *
      *              Rights Issues Option, this new Corporate         *
      *              Exercises and Conversions did not appeared, so   *
      *              refresh subfile with using new parameter         *
      *              transmited between programs.                     *
      *           2. Review Reverse processing: reverse CO Blocked    *
      *              Positions.                                       *
      *           3. When a Corporate Action type 'DV' or 'RG' is     *
      *              linked with a Corporate Action type 'EX':        *
      *              - Delete of 'DV' or 'RG' only authorised if 'EX' *
      *                is deleted.                                    *
      *              - Reverse of 'DV' or 'RG' only authorised if     *
      *                'EX' linked is reversed.                       *
      *              - When user want to delete or reverse an 'EX', a *
      *                warning message is send on confirmation screen *
      *                to inform that this CO is linked to a 'DV' or  *
      *                'RG' and setup 'Rights' fields of 'DV' or 'RG' *
      *                if status neither 'C' nor 'X' nor 'S'.         *
      *           4. Correct bad command line in Confirmation screen, *
      *              F11 not allowed, only F3 and F12 allowed.        *
      *  137879 - Amend Review from processing, if Status and/or CO   *
      *           Type selected and roll up, the next pages shown all *
      *           Status and/or CO Type.                              *
      *         - When F9 key is pressed after an enquiry of a ref.   *
      *           with status 'R' or 'C', all fields in subfile was   *
      *           protect.                                            *
      *         - Review 'Deletion' and 'Reversal' processing for     *
      *           Currency Change Events (Processing Type 'CC').      *
      *         - When entering a new Corporate Action using F9 from  *
      *           the maintenance screen, ENTER should take you to the*
      *           general details screen, NOT back to the maintenance *
      *           screen.                                             *
      *  136933 - Block OLD Security from the allocation effective    *
      *           Date when generating the 'CC' events.               *
      *  136930 - EMU and Corporate Actions: various errors:          *
      *           - Amend selection if Review from Reference,         *
      *             Security and Ex-Date fields blanks and Review     *
      *             from CO Type and/or Status entered: nothing was   *
      *             selected, reposition at beginning of file.        *
      *  136428 - Recompile due to addition of Days Basis and Divisor *
      *           Basis field in SECORBPD.                            *
      *  136420 - Add the link between the Bulk Reference and the     *
      *           Corporate Action Reference(s) linked to the Bulk    *
      *  136421 - To show the the action in decsending order, so that *
      *           the latest action always on top.                    *
      *  136419 - Multiple securities can be redenominated in one     *
      *           New Security. Input of Currency Events (CC) now     *
      *           not allowed in 'Corporate Action Events Maintenance'*
      *           program                                             *
      *  CEU017 - Securities Redenomination Euro Changes              *
      *  CSE007 - Corporate Actions.                                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      **   MA - SE CORPORATE ACTIONS References - Upd Idx
     FSECORFL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MU - SE CORPORATE ACTIONS Blocked Positions
     FSECOBKL1  UF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **  MQ - SE CORPORATE ACTIONS Customer/Book Reply
     FSECOREL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **  MP - SE CORPORATE ACTIONS Reply History file-Detail
     FSECORHL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MU - SE CORPORATE ACTIONS Blocked Positions
     FSECOBKL2  UF A E           K DISK
     F                                     RENAME(SECOBKD0:SECOBKD2)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MA - SE CORPORATE ACTIONS References - Rtv Idx
     F*SECORFL1IF*E***********K********DISK                               136421
     FSECORFL9  IF   E           K DISK                                         136421
     F                                     RENAME(SECORFD0:SECORFD1)
     F                                     INFSR(*PSSR)
      *
      **   MA - SE CORPORATE ACTIONS References - Rtv Idx by SESN+COEX+CORF
     FSECORFL3  IF   E           K DISK
     F                                     RENAME(SECORFD0:SECORFD3)
     F                                     INFSR(*PSSR)
      *
      **   MA - SE CORPORATE ACTIONS References - Rtv Idx by COEX+SESN+CORF
     FSECORFL4  IF   E           K DISK
     F                                     RENAME(SECORFD0:SECORFD4)
     F                                     INFSR(*PSSR)
      *
      **   Securities Details
     FSECTYZ1   IF   E           K DISK
     F                                     INFSR(*PSSR)
      *                                                                   155622
      **   Market Prices                                                  155622
     FPRICM     IF   E           K DISK                                         155622
     F                                     INFSR(*PSSR)                         155622
      *
      **   Investment Types Details
     FINVTP     IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   Security Events by Type
     FSECED     IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   MM - SE CORPORATE ACTIONS Types
     FSECOATL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   MN - SE Option Narrative Code
     FSECONAL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   MA - SE CORPORATE ACTIONS Reference Number
     FSECORFPA  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MB - SE CORPORATE ACTIONS Depots - Rtv Idx
     FSECODPL1  IF   E           K DISK
     F                                     RENAME(SECODPD0:SECODPD1)
     F                                     INFSR(*PSSR)
      *
      **   SE Depot Positions by Security
     FDPOSS     IF   E           K DISK
     F                                     RENAME(DPOSNDF:DPOSSDF)
     F                                     INFSR(*PSSR)
      *
      **   MC - SE CORPORATE ACTIONS Allocation - Rtv Idx
     FSECOALL1  IF   E           K DISK
     F                                     RENAME(SECOALD0:SECOALDU)
     F                                     INFSR(*PSSR)
      *
      **   MB - SE CORPORATE ACTIONS Depots - Upd Idx
     FSECODPL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MS - SE CORPORATE ACTIONS Depots Reference
     FSECODRL1  IF   E           K DISK
     F                                     RENAME(SECODRD0:SECODRD1)
     F                                     INFSR(*PSSR)
      *
      **   MC - SE CORPORATE ACTIONS Allocation - Upd Idx
     FSECOALL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   Midas Corporate Actions - Depots Update index
     FSECODRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MD - SE Corporate Actions - Dividends Events
     FSECODVL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   ME - SE Corporate Actions - Free Allocations
     FSECOFRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MG - SE Corporate Actions - Capital Events
     FSECOCEL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MH - SE Corporate Actions - Merger
     FSECOCRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MI - SE Corporate Actions - Exchange Offers
     FSECOOFL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MF - SE Corporate Actions - Rights Issues
     FSECORGL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MJ - SE Corporate Actions - Exercises and Conversions
     FSECOEXL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MK - SE Corporate Actions - Non Financial Events
     FSECONFL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   ML - SE Corporate Actions - Name Changes
     FSECONCL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *                                                                   CEU017
      **   NA - SE Corporate Actions (EMU) - Currency Changes             CEU017
     FSECOCCL0  UF A E           K DISK                                         CEU017
     F                                     INFSR(*PSSR)                         CEU017
     F                                     COMMIT                               CEU017
      *                                                                   CEU017
      **  NB - Securities Redenomination Bulk Details - Updt Index        CEU017
     FSECORBL0  UF   E           K DISK    COMMIT                               CEU017
     F                                     INFSR(*PSSR)                         CEU017
      *                                                                   CEU017
      **  NC - Securities Redenomination Bulk Securities - Updt           CEU017
     FSECORSL0  UF   E           K DISK    COMMIT                               CEU017
     F                                     INFSR(*PSSR)                         CEU017
      *                                                                   138962
      ***  MJ - SE Corporate Actions - Exercises and Conversions,         138962
      ***       Linked Corporate Action Number.                           138962
      *                                                                   138962
     FSECOEXL2  IF   E           K DISK    INFSR(*PSSR)                         138962
     F                                     RENAME(SECOEXD0:SECOEXD2)            138962
     F/COPY WNCPYSRC,SE7502F001
      *                                                                                       CSE020
      **  Securities Corporate Actions - By parent Ref                                        CSE020
     FSECORFLA  IF   E           K DISK                                                       CSE020
     F                                     INFSR(*PSSR)                                       CSE020
      *                                                                                       CSE020
      **  Securities Corporate Actions - with level field                                     CSE020
     FSECORFPM  IF   E             DISK    USROPN                                             CSE020
     F                                     INFSR(*PSSR)                                       CSE020
      *
      **   Display file
     FSE7502DF  CF   E             WORKSTN INFDS(SCRDS)
     F                                     INFSR(*PSSR)
     F                                     SFILE(SE7502S0:#1RRN)
     D*****************************************************************
      /EJECT
     D********************************************************************
      *
      * ID F  C  H  L    Function of indicators
      * ---------------------------------------
      *
      *   KC : CMD  3 - End of program
      *   KE : CMD  5 - Reset Screen
      *   KI : CMD  9 - Go to 'Add' or 'Change' Mode
      *   KL : CMD 12 - Previous screen
      *
      *   LR :    Last record
      *   U7/U8 : Database error
      *
      *   06 : CGL031 Indicator                                                               CGL031
      *   07 : Reverse Image on 'Subject to European Tax'                                     CGL031
      *   13 : Reverse Image on 'Customer Last Reply Time'
      *   14 : Reverse Image on 'Depot    Last Reply Time'
      *   15 : LS=Final Allocation Stock
      *   16 : LY=Final Allocation Cash and Stock
      *   17 : S =Stock Authorised
      *   18 : X =Fully Authorised (Cash & Stock)
      *   20 : Reverse Image on 'Old Capital Value'
      *   21 : Reverse Image on 'New Capital Value'
      *   22 : Reverse Image on 'Old Nominal Value'
      *   23 : Reverse Image on 'New Nominal Value'
      *   24 : Reverse Image on 'Market Cum Price'
      *   26 : Number of options is 01
      *   27 : Rollup subfile
      *   28 : Error indicator (Subfile Field)
      *   29 : Error indicator
      *   30 : End of Subfile
      *   31 : Reverse Image on 'Market Ex Price'
      *   32 : Error indicator
      *   33 : Error indicator
      *   35 : Protect/Non-display fields for processing type 'CC'        CEU017
      *   37 : Error indicator
      *   38 : Error indicator
      *   39 : Error indicator
      *
      *   40 : Confirm REVERSAL or DELETION
      *   41 : Confirm AUTHORISATION
      *   42 : Reverse Image on 'Block Security'
      *
      *   43 : 'AMEND' Mode if *ON
      *        'ADD  ' Mode if *OFF
      *   44 : Error indicator
      *   45 : "First" Time Processing
      *   46 : Command Key pressed
      *   47 : Confirmation Screen or 'Full Details' Screen
      *   48 : Protect 'Allocation Effective Date'
      *   49 : Reverse Image on 'Event Date'
      *
      *   50 : Error indicator (Position Field)
      *   51 : Error indicator
      *   52 : Error indicator
      *
      *   53 : Access by Security Shortname and Ex-date
      *   54 : Access by Ex-date and Security Shortname
      *   55 : Access by Reference Number
      *
      *   56 : Protect 'Position/Selection' Fields
      *   57 : Protect and non-display 'Action'
      *   58 : Protect Security Shortname', 'Action Type', 'Number of Options',
      *   59 : Protect 'Ex-date' field
      *
      *   60 : Reverse Image on 'Trade Date'
      *   61 : Enquiry Mode
      *   62 : Error indicator (Action)
      *   63 : Protect 'Ex-date' fields
      *   64 : Report Mode
      *   65 : Reverse Image on 'Payment Date'
      *   66 : Reverse Image on 'Trade/Value Date Position'
      *   67 : Reverse Image on 'Coupon Number'
      *   68 : Protect 'Final Allocation' field
      *   69 : Error indicator (Selection Field)
      *   70 : Reverse Image on 'ShareHolders Meeting Date'
      *   71 : Reverse Image on 'Letter to be Sent'
      *   72 : Reverse Image on 'Block Positions'
      *   73 : Reverse Image on 'Block From Date'
      *   74 : Reverse Image on 'Block To   Date'
      *   75 : Protect 'Date of Announcement'
      *   76 : Reverse Image on 'Refuse Offer'
      *   77 : Reverse Image on 'Customer Option Narrative Code'
      *   78 : Reverse Image on 'Default no Reply'
      *   79 : Reverse Image on 'Default for Cash Preferred'
      *
      *   80 : Display Subfile control
      *   81 : Display Subfile
      *   82 : Reverse Image on 'Default for Stock Preferred'
      *   83 : Reverse Image on 'Customer Last Reply Date'
      *   84 : Subfile Next Change
      *   85 : Reverse Image on 'Depot Last Reply Date'
      *
      *   87 : Read Change indicator
      *   88 : Working indicator
      *   89 : Working indicator
      *
      *   90-99 : Used by Standard Subroutines
      *   98 : Indicator used by subroutine ZDATE1
      *   99 : Indicator used by subroutine ZDATE1
      **************************************************************************
      /EJECT
      **************************************************************************
      *
      * Name of the Subroutines
      * -----------------------
      *
      *       P001  - Initial processing
      *       P002  - Main processing
      *       P003  - Termination processing
      *
      *       P004  - Clear Subfile
      *       P005  - Build the subfile for Add Mode
      *       P006  - Build the subfile for Amend/Enquiry Mode
      *       P007  - Validate Position/Selection fields
      *       P008  - Validate subfile records
      *       P008A - Validate 'Action' field
      *       P009  - Process 'Action'
      *       P010  - Process 'Confirmation' screen
      *       P011  - Process Writing Options with Default Information
      *       P014  - Initialise error indicators
      *       P015  - Clear Subfile Fields
      *       P016  - Load Subfile Fields
      *       P017  - Reinitialise Position/selection fields
      *       P018  - Process 'Full details' screen
      *       P019  - Validate 'Full details' screen and update file
      *       P020  - Blocking Processing
      *       P021  - Retrieve Next Available Reference Number
      *       P022  - Apply Action to all Options
      *       P023  - View/Change Option(s)
      *
      *       R001  - Position into the File
      *       R002  - Read next record in File
      *
      *       *PSSR - "Standard" Database error processing
      *
      * Name of the Standard Subroutines
      * --------------------------------
      *
      *       ZNCD   - Determine Next Coupon Date
      *       ZDATE1 - Dates Validation and Conversion
      *       ZDATE2 - Dates Validation and Conversion
      *       ZASNMS - Send Message to Program's message queue
      *       ZSEDIT - Insert a decimal point and sign into a numeric field
      *                and blank out leading zeros
      *       ZALIGN - To validate and right-align numeric fields
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      **   ARRAYS USED BY ZDATE1
      *
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
      *
      **   FOR COMPILATION - COPYRIGHT INSERTION
      *
      *
      **   STORE THE EIGHT GROUP EACH CUSTOMER IS ASSOCIATED
      *
     D CGRP            S              1    DIM(9)                               CUSTOMER GROUP
     D AGRP            S              1    DIM(9)                               ACCOUNT COMMISS.
      *
      *
     D*****               TXT     1   5 78               COMMAND KEYS     137879
     D*TXT*******      S             78    DIM(6) CTDATA PERRCD(1)  COMMAND KEYS       137879 CSE020
     D TXT             S             78    DIM(11) CTDATA PERRCD(1)                           CSE020
      *
     D*/COPY ZSRSRC,ZALIGNZ1
     D ZA1             S              1    DIM(16)                              ZALIGN SR. ARRAY
     D ZA2             S              1    DIM(16)                              ZALIGN SR. ARRAY
     D*/COPY ZSRSRC,ZASIGNZ1
     D*
     D ZS3             S              1    DIM(17)                              ZASIGN SR. ARRAY
     D ZS4             S              1    DIM(16)                              ZASIGN SR. ARRAY
     D ZS5             S              1    DIM(15)                              ZASIGN SR. ARRAY
     D*
     D*/COPY ZSRSRC,ZSEDITZ1
     D ZS2             S              1    DIM(21)
      *
     D NARR            S             27    DIM(9) CTDATA PERRCD(1)              NARRATIVE
      *
     D*/COPY ZSRSRC,ZHOLE
     D ZHL1            S              1    DIM(366)
      *
      * Arrays to split holiday fields into 1-bit elements
      *
                                                                                              CSE016
      ** Parameter declaration of ZSDESC                                                      CSE016
                                                                                              CSE016
     D PSRPN           S             20A                                                      CSE016
     D PSFN1           S             30A                                                      CSE016
     D PSFN2           S             30A                                                      CSE016
     D PRSFD           S              1A                                                      CSE016
     D PRNME           S             41A                                                      CSE016
     D PFNM1           S             30A                                                      CSE016
     D PFNM2           S             50A                                                      CSE016
     D PFNM3           S             50A                                                      CSE016
      *                                                                                       215168
     D WSECN           S             10A                                                      215168
     D WCOAT           S              2A                                                      215168
     D WREDSP          S              1A                                                      215168
     D CSE010          S              1A                                                      215168
                                                                                              CGL031
      ** Access Object Parameters                                                             CGL031
     D PRetCde         S              7A                                                      CGL031
     D POption         S              7A                                                      CGL031
     D PSARD           S              6A                                                      CGL031
                                                                                              CGL031
      ** Switchable Features                                                                  CGL031
     D CGL031          S              1A                                                      CGL031
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      **   PROGRAM DATA STRUCTURE
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      **   FILE INFORMATION DATA STRUCTURE
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      **   FILE RECORD DATA STRUCTURE
      *
     D FIELD         E DS                  EXTNAME(SECORFPD)
      *
      ** External DS for Switchable Feature Details                                           CSE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE020
      *                                                                                       CSE020
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE020
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE020
      *                                                                                       CSE020
     D SCRDS           DS
     D  DSPNUM               197    205
     D  CPFPOS               378    379B 0
      *
      **   DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      **   DATA STRUCTURE FOR DATABASE ERROR
      *
     D LDA             DS           256
     D  WWLOT                132    183
     D  WWFILE               132    141
     D  WWKEY                142    170
     D  WWPGM                171    180
     D  WWASE                181    183  0
     D  PGMNAM               184    189
      *
     D DIGITS          C                   CONST('0123456789')
      *
     D CDDS            DS
     D  CD01                   1      4  0
     D  CD02                   5      8  0
     D  CD03                   9     12  0
     D  CD04                  13     16  0
     D  CD05                  17     20  0
     D  CD06                  21     24  0
     D  CD07                  25     28  0
     D  CD08                  29     32  0
     D  CD09                  33     36  0
     D  CD10                  37     40  0
     D  CD11                  41     44  0
     D  CD12                  45     48  0
     D  CD                     1     48  0
     D                                     DIM(12)                              CD01-12 ARRAY
     D CRDS            DS
     D  CR01                   1      1
     D  CR02                   2      2
     D  CR03                   3      3
     D  CR04                   4      4
     D  CR05                   5      5
     D  CR06                   6      6
     D  CR07                   7      7
     D  CR08                   8      8
     D  CR09                   9      9
     D  CR10                  10     10
     D  CR11                  11     11
     D  CR12                  12     12
     D  CR                     1     12
     D                                     DIM(12)                              CR01-12 ARRAY
     D LOCKDS          DS
     D  WUSER                  1     10
     D  WJOBN                 11     20
      *
     D ZMUSER          DS            17
      ** Data area ZMUSER
     D  BVBRCD                11     13
      *
      ***  Data structure used to send data to message ID CO00600:        138962
      ***  Linked Corporate Action Number and Processing Type.            138962
      *                                                                   138962
     D REFLIN          DS                                                       138962
     D  WWLNKR                 1      6                                         138962
     D  WWPTYP                 7      8                                         138962
     D RUNDAT        E DS
      **  Standard Data Area Layout for System flags and Run Date
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Data structure for branch details
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  Data structure for securities trading details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access objects
      *
     I/COPY WNCPYSRC,SE7502I001
     D*/COPY ZSRSRC,ZHOLI
     D ZHOLDS          DS
      *
      * Data structure defined over holiday file fields
      *
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL                   17    382
     D                                     DIM(366)
      *
      *
     D ZVARS           DS
      *
      * Data structure to define variables used in holiday sub-routines
      *
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
      *
     D  ZCCY                  15     17
     D  ZLOC                  18     20
     D  @ZWRKI                15     20
      *
     D  ZSCCY                 21     23
     D  ZSLOC                 24     26
     D  ZSWEXX                27     30  0
     D  ZSJAN                 31     33P 0
     D  ZSDCM                 34     36P 0
     D  RTNCD                 37     43
     D  @ZWRKO                21     43
      *
     D  ZOPTN                 44     50
     D  ZZCCY                 51     53
     D  ZZLOC                 54     56
     D  ZZDYNO                57     59P 0
     D  ZSRTN                 60     66
     D*/COPY ZSRSRC,ZSEDITZ2
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
      *
     *********************************************************************
      /EJECT
      ********************************************************************
      **    P R O G R A M   S T A R T
      ********************************************************************
      *
      **   INITIAL PROCESSING
      *
     C                   EXSR      P001
      *
      **   MAIN PROCESSING
      *
     C/COPY WNCPYSRC,SE7502C006
     C                   EXSR      P002
     C/COPY WNCPYSRC,SE7502C007
      *
      **   TERMINATION PROCESSING
      *
     C                   EXSR      P003
      *
      ********************************************************************
      **    P R O G R A M     E N D
      ********************************************************************
      /EJECT
      *****************************************************************
      * P001   : INITIAL PROCESSING                                   *
      *****************************************************************
      *
     C     P001          BEGSR
      *
      **  Copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
     C                   MOVE      '0'           WIN45             1                          CSE020
     C                   MOVE      'N'           WOPEN             1                          CSE020
     C                   MOVE      '0'           WIN53             1                          CSE020
      *
      **  Read in DTAARA/RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      **  Read in DTAARA/ZMUSER
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      **   KEY FIELDS
      *
     C     KEY1          KLIST
     C                   KFLD                    KSECN            10
     C                   KFLD                    KEXDT             5 0
     C                   KFLD                    KREFN             6
      *
     C     KEY2          KLIST
     C                   KFLD                    KEXDT
     C                   KFLD                    KSECN
     C                   KFLD                    KREFN
      *
     C     KEY3          KLIST
     C                   KFLD                    KNMCY
     C                   KFLD                    KSITP
      *
     C     KEY4          KLIST
     C                   KFLD                    KSECN
     C                   KFLD                    KEXDT
      *
     C     KEY5          KLIST
     C                   KFLD                    KSECN            10
     C                   KFLD                    KEXDT             5 0
     C                   KFLD                    KTYPE             2
      *
     C     KEY6          KLIST
     C                   KFLD                    KCORF             6
     C                   KFLD                    KOPTN             2 0
      *                                                                   155622
     C     KEY7          KLIST                                                                 15562
     C                   KFLD                    KSECN                                         15562
     C                   KFLD                    KEXDT                                         15562
      *
      **   ENTRY PARAMETERS
      **   RECEIVE 'ACTION CODE' TO DETERMINE THE PROCESSING MODE
      **   VALUE CAN BE 'E' FOR ENQUIRY, 'A' FOR UPDATE OR 'R' FOR REPORT
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
     C/COPY WNCPYSRC,SE7502C008
     C                   PARM                    P#MBR            10                          CSE020
      *
      **   INITIALISE KEY AND WORKING FIELDS
      *
     C                   MOVE      *BLANKS       WWLOT
     C                   MOVEL     'SE7502'      DBPGM            10
      *
     C                   MOVE      *BLANKS       #3REFN
     C                   MOVE      *BLANKS       #3SECN
     C                   MOVE      *BLANKS       #3EXDT
     C                   MOVE      *BLANKS       #3STAT
     C                   MOVE      *BLANKS       #3COAT
      *
     C                   Z-ADD     0             WWRRN             4 0          SAVE RCD.NBR.
      *
      **   SETUP SCREEN TIME
      *
     C                   TIME                    ##TME             6 0          Screen time.
      *
      **   ACCESS TO BANK DETAILS TO RETRIEVE THE MIDAS RUN DATE
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WLRTCD            7
     C                   PARM      '*FIRST'      WLOPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      **   IF RECORD NOT FOUND
      *
     C     WLRTCD        IFNE      *BLANKS
     C                   MOVEL     '001'         DBASE             3 0          *****************
     C                   MOVE      'SDBANKPD'    DBFILE           10            * DB ERROR 01   *
     C                   MOVEL     *BLANKS       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      BJMRDT        ##MRDT                         MIDAS RUN DATE
      *
      **   DETERMINE DATE FORMAT
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
      **   ACCESS TO SECURITIES TRADING DATA TO RETRIEVE THE BACK VALUE PERIOD
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       WLRTCD
     C                   PARM      '*FIRST'      WLOPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      **   IF RECORD IS NOT FOUND
      *
     C     WLRTCD        IFNE      *BLANKS
     C                   MOVEL     '002'         DBASE                          *****************
     C                   MOVE      'SDSTRDPD'    DBFILE                         * DB ERROR 02   *
     C                   MOVEL     *BLANKS       DBKEY                          *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **   CALCULATE RETENTION PERIODS
      *
     C                   Z-ADD     *ZEROS        WK3N              3 0
     C     31            MULT      BVROPS        WK3N
     C     BJRDNB        SUB       WK3N          RTNPOS            5 0
      *
     C                   Z-ADD     *ZEROS        WK3N
     C     31            MULT      BVROST        WK3N
     C     BJRDNB        SUB       WK3N          RTNTRD            5 0
      *
      **  Access SDBRCHPD using the default user branch
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       WLRTCD
     C                   PARM      '*KEY   '     WLOPTN
     C                   PARM      BVBRCD        WLBRCH            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      **  Check if error occurred
      *
     C     WLRTCD        IFNE      *BLANKS
     C                   MOVEL     '003'         DBASE                          *****************
     C                   MOVE      'SDBRCHPD'    DBFILE                         * DB ERROR 03   *
     C                   MOVEL     *BLANKS       DBKEY                          *****************
     C                   MOVEL     BVBRCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSE020
      ** Check if CA Domino Effect Enhancement is installed                                   CSE020
      *                                                                                       CSE020
     C                   MOVE      'N'           CSE020            1                          CSE020
     C                   CALL      'AOSARDR0'                                                 CSE020
     C                   PARM      *BLANKS       WLRTCD                                       CSE020
     C                   PARM      '*VERIFY'     WLOPTN                                       CSE020
     C                   PARM      'CSE020'      WSARD             6                          CSE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE020
      *                                                                                       CSE020
     C     WLRTCD        IFNE      *BLANKS                                                    CSE020
     C     WLRTCD        ANDNE     '*NRF   '                                                  CSE020
     C                   MOVEL     '004'         DBASE                          ************  CSE020
     C                   MOVE      'SCSARDPD'    DBFILE                         * DBERR 04 *  CSE020
     C                   MOVEL     *BLANKS       DBKEY                          ************  CSE020
     C                   MOVEL     'CSE020'      DBKEY                                        CSE020
     C                   EXSR      *PSSR                                                      CSE020
     C                   ELSE                                                                 CSE020
     C     WLRTCD        IFEQ      *BLANKS                                                    CSE020
     C                   MOVE      'Y'           CSE020                                       CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      'N'           CSE020                                       CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
      ** Check if SE Transactions Enhancements is installed                                   215168
      *                                                                                       215168
     C                   CALL      'AOSARDR0'                                                 215168
     C                   PARM      *BLANKS       WLRTCD                                       215168
     C                   PARM      '*VERIFY'     WLOPTN                                       215168
     C                   PARM      'CSE010'      WSARD             6                          215168
      *                                                                                       215168
     C     WLRTCD        IFEQ      *BLANKS                                                    215168
     C                   MOVE      'Y'           CSE010                                       215168
     C                   ELSE                                                                 215168
     C                   MOVE      'N'           CSE010                                       215168
     C                   ENDIF                                                                215168
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRetCde                                      CGL031
     C                   PARM      '*VERIFY'     POption                                      CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
     C                   EVAL      *IN60 = *OFF                                               CGL031
                                                                                              CGL031
     C                   IF        PRetCde = *BLANKS                                          CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   EVAL      *IN06 = *ON                                                CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRetCde <> *BLANKS                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       215168
      **   CALCULATE THE SE BACKVALUE DATE
      *
     C     BJRDNB        SUB       BVBVP         WBACKD            5 0
      *
      **   IF THE 'ACTION' PARAMETER IS EQUAL TO 'E' OR 'R'
      **   SETON INDICATOR FOR ENQUIRY MODE OR REPORT MODE
      *
     C     ACTION        IFEQ      'E'                                          B*1
     C     ACTION        OREQ      'R'
     C                   MOVE      '1'           *IN61
     C                   MOVEA     TXT(1)        ##CTX1
      *
     C     ACTION        IFEQ      'R'                                          B*2
     C                   MOVE      '1'           *IN64
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF THE 'ACTION' PARAMETER IS EQUAL TO 'A'
      **   SETON INDICATOR FOR 'UPDATE' MODE
      *
     C     ACTION        IFEQ      'A'                                          B*1
     C/COPY WNCPYSRC,SE7502C009
      *
      **   ACCESS THE ER REFERENCES FILE TO SEE IF THERE IS RECORD IN THE FILE
      *
     C************LOVAL    SETLLSECORFL1                                  136421
     C************         READ SECORFL1                 89               136421
     C     *HIVAL        SETGT     SECORFL9                                                    13642
     C                   READ      SECORFL9                               89                   13642
      *
      **   IF RECORD IS NOT FOUND, SETON THE INDICATOR OF 'ADD MODE'
      *
     C     *IN89         IFEQ      '1'                                          B*2
     C                   MOVE      '0'           *IN43
     C                   MOVEA     TXT(2)        ##CTX1
      *
      **   IF RECORD IS NOT FOUND, SETON THE INDICATOR OF 'AMEND MODE'
      *
     C                   ELSE                                                   X*2
     C                   MOVE      '1'           *IN43
     C                   MOVEA     TXT(3)        ##CTX1
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   ONLY TO DECLARE THE FILE IN 'ADD' MODE
      *
     C     *IN99         IFEQ      '0'                                          B*1
     C     *IN99         ANDEQ     '1'
     C                   WRITE     SECODRD0
     C                   WRITE     SECODPD0
     C                   WRITE     SECOALD0
     C                   WRITE     SECORED0
     C                   WRITE     SECORHD0
     C                   ENDIF                                                  E*1
      *
      **   RETRIEVE NEXT REFERENCE NUMBER
      *
     C     *LOVAL        SETLL     SECORFPA
     C                   READ(N)   SECORFPA                               89
      *
      **   IF RECORD NOT FOUND
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      'D'           MXRECI
     C                   Z-ADD     BJRDNB        MXLCD
     C                   MOVE      'I'           MXCHTP
     C                   MOVE      ##USR         MXLUID
     C                   MOVE      '000001'      MXCORF
     C                   WRITE     SECORFP0
     C                   ENDIF
      *
     C                   MOVE      MXCORF        WWCORF            6 0
     C                   MOVE      MXCORF        W1CORF            6 0
      *
      **   SELECT THE PROGRAM MSGQ FOR ERROR MSG
      *
     C                   MOVEL     '*'           TOPQ             10
     C                   MOVEL     '*PRV'        TOPRQ             5
     C                   MOVEL     'SEUSRMSG'    PMSGF            10
      *
      **   FILL IN FIELDS FOR SUBROUTINE ZASNMS
      *
     C                   MOVEL     'SE7502'      ZAPGM            10            Message queue
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10            Message file
     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C/COPY WNCPYSRC,SE7502C010
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   WRITE     #MSGCTL
      *
     C/COPY WNCPYSRC,SE7502C001
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P002   : MAIN PROCESSING                                      *
      *****************************************************************
      *
     C     P002          BEGSR
      *
      **   WHILE CMD3 NOT PRESSED
      *
     C     *INKC         DOWEQ     '0'                                          B*1
      *
      **   IF IT'S THE FIRST TIME PROCESSING OR F5 IS PRESSED
      *
     C******IN45*        IFEQ      '0'                                          B*2           CSE020
     C     WIN45         IFEQ      '0'                                                        CSE020
     C     *INKE         OREQ      '1'
     C     WWREX         OREQ      'Y'                                                         13896
      *
     C***********        MOVE      '0'           *IN53                                        CSE020
     C                   MOVE      '0'           WIN53                                        CSE020
     C                   MOVE      '0'           *IN54
     C                   MOVE      '0'           *IN55
     C                   MOVE      ' '           WWREX                                         13896
      *
      **   IF IT'S NOT THE ENQUIRY MODE
      *
     C     *IN61         IFEQ      '0'                                          B*3
      *
      **   IT IT'S THE 'AMEND' MODE, BUILD THE FIRST SUBFILE PAGE
      *
     C     *IN43         IFEQ      '1'                                          B*4
     C***********        MOVE      '0'           *IN45                                        CSE020
     C                   MOVE      '0'           WIN45             1                          CSE020
      *
      **   CLEAR SUBFILE
      *
     C                   EXSR      P004
      *
      **   PROTECT ON 'POSITION/SELECTION' FIELDS *OFF
      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *OFF
      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *ON
      *
     C                   MOVE      '0'           *IN56
     C                   MOVE      '0'           *IN57
     C                   MOVE      '1'           *IN58
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
      **   REINITIALISE POSITION/SELECTION FIELDS
      *
     C                   EXSR      P017
      *
      **   SET KEY FIELDS WITH BLANKS OR ZEROS
      *
     C                   MOVE      *BLANKS       KREFN
     C                   MOVE      *BLANKS       KSECN
     C                   Z-ADD     *ZEROS        KEXDT
      *
      **   BUILD THE FIRST SUBFILE PAGE
      *
     C                   EXSR      P006
     C                   ELSE                                                   X*4
      *
      **   IT IT'S THE 'ADD' MODE, BUILD A BLANK SUBFILE
      *
     C                   EXSR      P004
      *
      **   PROTECT ON 'POSITION/SELECTION' FIELDS *ON
      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *ON
      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *OFF
      *
     C                   MOVE      '1'           *IN56
     C                   MOVE      '1'           *IN57
     C                   MOVE      '0'           *IN58
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
      **   BUILD A BLANK SUBFILE
      *
     C                   EXSR      P005
     C                   Z-ADD     1             #1RRN
     C                   ENDIF                                                  E*4
      *
      **   IF IT'S THE ENQUIRY MODE
      *
     C                   ELSE                                                   X*3
     C***********        MOVE      '0'           *IN45                                        CSE020
     C                   MOVE      '0'           WIN45                                        CSE020
      *
      **   CLEAR SUBFILE
      *
     C                   EXSR      P004
      *
      **   REINITIALISE POSITION/SELECTION FIELDS
      *
     C                   EXSR      P017
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
      **   SET KEY FIELDS WITH BLANKS OR ZEROS
      *
     C                   MOVE      *BLANKS       KREFN
     C                   MOVE      *BLANKS       KSECN
     C                   Z-ADD     *ZEROS        KEXDT
      *
      **   BUILD THE FIRST SUBFILE PAGE
      *
     C                   EXSR      P006
     C                   ENDIF                                                  E*3
      *
     C***********        MOVE      '1'           *IN45                                        CSE020
     C                   MOVE      '1'           WIN45                                        CSE020
     C                   ENDIF                                                  E*2
      *
      **   IF CMD9 IS PRESSED
      *
     C     *IN09         IFEQ      '1'                                          B*2
      *
      **  Check if user is authorised to action 'Insert'
      *
     C     AGMBIN        IFNE      'Y'
      *
      **  If single branch environment
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'I'           WLACTN            1
     C                   PARM      *ZERO         WLERR             1 0
      *
     C     WLERR         IFNE      *ZERO
     C                   MOVEL     'CO00034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      *
      **  If multibranching environment
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      'I'           WLACTN            1
     C                   PARM      BVBRCD        WLBRCH            3
     C                   PARM      *ZERO         WLERR             1 0
      *
     C     WLERR         IFEQ      1
     C                   MOVEL     'CO00035'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WLERR         IFEQ      2
     C                   MOVEL     'CO00036'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WLERR         IFEQ      *ZERO
      *
      **   IT IT'S THE 'AMEND' MODE, BUILD A BLANK SUBFILE
      *
     C     *IN43         IFEQ      '1'                                          B*3
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
      **   CLEAR SUBFILE
      *
     C                   EXSR      P004
     C                   MOVEA     TXT(2)        ##CTX1
      *
      **   PROTECT ON 'POSITION/SELECTION' FIELDS *ON
      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *ON
      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *OFF
      *
     C                   MOVE      '1'           *IN56
     C                   MOVE      '1'           *IN57
     C                   MOVE      '0'           *IN58
      *
     C                   MOVE      '0'           *IN30
     C                   MOVE      '0'           *IN59
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN68
     C                   MOVE      '1'           *IN48
     C                   MOVE      '0'           *IN75
      *
      **   BUILD A BLANK SUBFILE
      *
     C                   EXSR      P005
     C                   Z-ADD     1             #1RRN
     C                   MOVE      '0'           *IN43
     C                   ELSE                                                   X*3
      *
     C***********        MOVE      '0'           *IN53                                        CSE020
     C                   MOVE      '0'           WIN53                                        CSE020
     C                   MOVE      '0'           *IN54
     C                   MOVE      '0'           *IN55
      *
      **   CLEAR SUBFILE
      *
     C                   EXSR      P004
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
      **   IT IT'S THE 'ADD' MODE, BUILD A FIRST SUBFILE PAGE
      **   (BEGINNING AT FIRST INSERTED RECORD)
      *
     C                   MOVEA     TXT(3)        ##CTX1
      *
      **   PROTECT ON 'POSITION/SELECTION' FIELDS *OFF
      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *OFF
      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *ON
      *
     C                   MOVE      '0'           *IN56
     C                   MOVE      '0'           *IN57
     C                   MOVE      '1'           *IN58
      *
     C***********        MOVE      '0'           *IN45                                        CSE020
     C                   MOVE      '0'           WIN45                                        CSE020
      *
      **   BUILD THE FIRST SUBFILE PAGE
      *
     C                   EXSR      P006
     C***********        MOVE      '1'           *IN45                                        CSE020
     C                   MOVE      '1'           WIN45                                        CSE020
     C                   MOVE      '1'           *IN43
     C                   ENDIF                                                  E*3
      *
     C                   ENDIF
      *
     C                   ENDIF                                                  E*2
      *
      **   IF ROLLUP IS PRESSED
      *
     C     *IN27         IFEQ      '1'                                          B*2
     C                   Z-ADD     WWRRN         #1RRN
      *
      **   REINITIALISE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      **   IF IT'S THE 'ADD' MODE ONLY
      *
     C     *IN43         IFEQ      '0'                                          B*3
     C     *IN61         ANDEQ     '0'
      *
      **   BUILD A BLANK SUBFILE PAGE
      *
     C                   EXSR      P005
      *
      **   IF IT'S THE 'AMEND' MODE OR THE 'ENQUIRY' MODE
      *
     C                   ELSE                                                   X*3
      *
      **   SET KEY FIELDS WITH BLANKS OR ZEROS
      *
     C                   MOVE      *BLANKS       KREFN
     C                   MOVE      *BLANKS       KSECN
     C                   Z-ADD     *ZEROS        KEXDT
      *
      **   BUILD THE NEXT SUBFILE PAGE
      *
     C                   EXSR      P006
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
     C                   MOVE      '0'           *IN50                          Error on Reference
     C                   MOVE      '0'           *IN51                          Error on Security
     C                   MOVE      '0'           *IN52                          Error on Ex-date
     C                   MOVE      '0'           *IN69                          Error Type Select.
     C                   MOVE      '0'           *IN86                          Error Status Select.
      *
      **   IF ONE OF THE POSITION/SELECTION FIELDS IS CHANGED
      *
     C     #REFN         IFNE      #3REFN                                       B*2
     C     #SECN         ORNE      #3SECN
     C     #EXDT         ORNE      #3EXDT
     C     #COAT         ORNE      #3COAT
     C     #STAT         ORNE      #3STAT
      *
      **   VALIDATE POSITION/SELECTION FIELDS
      *
     C                   EXSR      P007
      *
      **   IF NO ERROR IS FOUND, BUILD THE FIRST SUBFILE PAGE
      *
     C     *IN50         IFEQ      '0'                                          B*3
     C     *IN51         ANDEQ     '0'
     C     *IN52         ANDEQ     '0'
     C     *IN69         ANDEQ     '0'
     C     *IN86         ANDEQ     '0'
      *
      **   CLEAR SUBFILE
      *
     C                   EXSR      P004
      *
      **   SET KEY FIELDS WITH BLANKS OR ZEROS
      *
     C                   MOVE      *BLANKS       KREFN
     C                   MOVE      *BLANKS       KSECN
     C                   Z-ADD     *ZEROS        KEXDT
      *
      **   BUILD THE FIRST SUBFILE PAGE
      *
     C                   EXSR      P006
      ******                                                              137879
      *****REINITIALISE*POSITION/SELECTION*FIELDS*(IDEM*FOR*HIDDEN*FIELDS)137879
      ******                                                              137879
     C******               MOVE *BLANKS   #REFN                           137879
     C******               MOVE *BLANKS   #SECN                           137879
     C******               MOVE *BLANKS   #EXDT                           137879
     C******               MOVE *BLANKS   #COAT                           137879
     C******               MOVE *BLANKS   #STAT                           137879
     C******               MOVE *BLANKS   #3REFN                          137879
     C******               MOVE *BLANKS   #3SECN                          137879
     C******               MOVE *BLANKS   #3EXDT                          137879
     C******               MOVE *BLANKS   #3STAT                          137879
     C******               MOVE *BLANKS   #3COAT                          137879
     C                   ENDIF                                                  E*3
     C                   ELSE                                                                  13787
     C     *IN81         IFEQ      '0'                                                         13787
     C                   MOVEL     'CO00001'     ZAMSID                         Message id.    13787
     C                   EXSR      ZASNMS                                       Send message   13787
     C                   ENDIF                                                                 13787
     C                   ENDIF                                                  E*2
      *
      **   SETUP SCREEN TIME
      *
     C                   TIME                    ##TME                          Screen time.
      *
      **   EXECUTE THE SUBFILE CONTROL RECORD
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     SE7502F1
     C                   EXFMT     SE7502C0
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      **   IF NO FUNCTION IS PRESSED AND ALL POSITION/SELECTION FIELDS UNCHANGED
      **      VALIDATE ALL SUBFILE RECORDS
      *
     C     *IN46         IFEQ      '0'                                          B*2
     C     #REFN         ANDEQ     #3REFN
     C     #SECN         ANDEQ     #3SECN
     C     #EXDT         ANDEQ     #3EXDT
     C     #COAT         ANDEQ     #3COAT
     C     #STAT         ANDEQ     #3STAT
     C     WWCPT         ANDNE     *ZEROS
      *
      **   REINITIALIZE ERROR INDICATORS
      *
     C                   EXSR      P014
      *
     C                   EXSR      P008
     C                   ENDIF                                                  E*2
      *
     C                   ENDDO                                                  E*1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P003   : TERMINATION PROCESSING                               *
      *****************************************************************
      *
     C     P003          BEGSR
      *
      **   ROLLBACK UNCOMMITED CHANGES
      *
     C                   ROLBK
      *
      **   END OF PROGRAM
      *
     C/COPY WNCPYSRC,SE7502C011
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P004  - TO CLEAR THE SUBFILE                                  *
      *****************************************************************
     C     P004          BEGSR
      *
      **   CLEAR SUBFILE
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     SE7502C0
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
     C                   Z-ADD     0             #1RRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P005   : BUILD THE SUBFILE FOR ADD MODE                       *
      *****************************************************************
      *
     C     P005          BEGSR
      *
      **   REINITIALISE POSITION/SELECTION FIELDS (HIDDEN FIELDS ALSO)
      *
     C                   EXSR      P017
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      **   LOAD A BLANK SUBFILE PAGE
      *
     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
      *
      **   INIT SCREEN LINE NUMBER
      *
     C                   Z-ADD     0             WWCPT             2 0
      *
      **   LOAD SUBFILE
      *
     C*****WWCPT         DOWLT     15                                           B*1           CSE016
     C     WWCPT         DOWLT     7                                                          CSE016
      *
     C                   ADD       1             #1RRN                81        SFLRCDNBR
     C                   ADD       1             WWCPT                          SCREEN LINE NBR
      *
      **   CLEAR SFL FIELDS
      *
     C                   EXSR      P015
      *
      **   ADD RECORD IN SUBFILE
      *
     C                   WRITE     SE7502S0
     C                   ENDDO                                                  E*1
      *
      **   SAVE POSITION
      *
     C                   Z-ADD     #1RRN         WWRRN                          SAVE SFL.RCD.NBR.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P006   : BUILD THE SUBFILE FOR AMEND/ENQUIRY MODE             *
      *****************************************************************
      *
     C     P006          BEGSR
      *
      **   LOAD A BLANK SUBFILE PAGE
      *
     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
      *
      **   IF ROLLUP (AMEND/ENQUIRY), SET KEY BY LAST RECORD OF PREVIOUS SCREEN
      *
     C     *IN27         IFEQ      '1'                                          B*1
     C     *IN43         ANDEQ     '1'
     C     *IN27         OREQ      '1'
     C     *IN61         ANDEQ     '1'
      *
     C     #1RRN         CHAIN     SE7502S0                           88
     C                   MOVE      #1REFN        KREFN
     C                   MOVE      #1SECN        KSECN
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        KEXDT
      *
     C                   ELSE                                                   X*1
      *
      **   SET KEY FIELDS BY NEW 'SELECT/POSITION TO' FIELD(S)
      *
     C     #REFN         IFNE      *BLANKS                                      B*2
     C     #SECN         ORNE      *BLANKS
     C     #EXDT         ORNE      *BLANKS
     C                   MOVE      #REFN         KREFN
     C                   MOVE      #SECN         KSECN
     C                   MOVE      #EXDT         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        KEXDT
     C                   ENDIF                                                  E*2
      *                                                                   136930
     C     #REFN         IFEQ      *BLANKS                                                     13693
     C     #SECN         ANDEQ     *BLANKS                                                     13693
     C     #EXDT         ANDEQ     *BLANKS                                                     13693
     C     *IN55         ANDEQ     '1'                                                         13787
     C******     #COAT     IFNE *BLANKS                            136930 137879
     C******     #STAT     ORNE *BLANKS                            136930 137879
     C     CSE020        IFEQ      'N'                                                        CSE020
     C     CSE020        OREQ      'Y'                                                        CSE020
     C     #COAT         ANDNE     *BLANKS                                                    CSE020
     C     CSE020        OREQ      'Y'                                                        CSE020
     C     #STAT         ANDNE     *BLANKS                                                    CSE020
     C                   MOVE      *HIVAL        KREFN                                         13693
     C                   ELSE                                                                 CSE020
     C                   Z-ADD     1             W#RRN                                        CSE020
     C                   ENDIF                                                                CSE020
     C******               ENDIF                                   136930 137879
     C                   ENDIF                                                                 13693
      *                                                                   136930
     C                   ENDIF                                                  E*1
      *                                                                                       CSE020
      ** Call SE7502M to write records to SECORFPM to show                                    CSE020
      ** Interdependencies                                                                    CSE020
      *                                                                                       CSE020
     C                   MOVE      'N'           WDMNO             1                          CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     WIN45         IFEQ      '0'                                                        CSE020
      *                                                                                       CSE020
     C     WOPEN         IFEQ      'Y'                                                        CSE020
     C                   CLOSE     SECORFPM                                                   CSE020
     C                   MOVE      'N'           WOPEN                                        CSE020
     C                   ENDIF                                                                CSE020
     C                   CALLB     'SE7502M'                                                  CSE020
     C                   PARM                    P#MBR                                        CSE020
     C                   Z-ADD     1             W#RRN                                        CSE020
      *                                                                                       CSE020
     C     WOPEN         IFEQ      'N'                                                        CSE020
     C                   OPEN      SECORFPM                                                   CSE020
     C                   MOVE      'Y'           WOPEN                                        CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     #REFN         ANDEQ     *BLANKS                                                    CSE020
     C     #SECN         ANDEQ     *BLANKS                                                    CSE020
     C     #EXDT         ANDEQ     *BLANKS                                                    CSE020
     C     #COAT         ANDEQ     *BLANKS                                                    CSE020
     C     #STAT         ANDEQ     *BLANKS                                                    CSE020
     C                   MOVE      '1'           *IN45                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      '0'           *IN45                                        CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
      ** Set flag to 'Y' if CSE020 is installed and all review fields                         CSE020
      ** are blanks to know if SECORFPM is the file to be used in                             CSE020
      ** building subfile                                                                     CSE020
      *                                                                                       CSE020
     C     #REFN         IFEQ      *BLANKS                                                    CSE020
     C     #SECN         ANDEQ     *BLANKS                                                    CSE020
     C     #EXDT         ANDEQ     *BLANKS                                                    CSE020
     C     #COAT         ANDEQ     *BLANKS                                                    CSE020
     C     #STAT         ANDEQ     *BLANKS                                                    CSE020
     C                   MOVE      'Y'           WDMNO                                        CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *
      **   POSITION INTO ER REFERENCE FILE
      *
     C                   EXSR      R001
      *
      **   READ NEXT RECORD OF THE ER REFERENCE FILE
      *
     C                   EXSR      R002
      *
      **   INIT SCREEN LINE NUMBER
      *
     C                   Z-ADD     0             WWCPT             2 0
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     W#RRN         ANDGT     0                                                          CSE020
     C                   SUB       1             W#RRN                                        CSE020
     C                   ENDIF                                                                CSE020
      *
      **   LOAD SUBFILE
      *
     C     *IN30         DOWEQ     '0'                                          B*1
     C*****WWCPT         ANDLT     15                                                         CSE016
     C     WWCPT         ANDLT     7                                                          CSE016
      *
      **  RETRIEVE THE "HIGHER" STATUS AND FINAL ALLOCATION INDICATOR
      *
     C                   MOVE      *BLANKS       #1STAT
     C                   MOVE      *BLANKS       #1FINA
     C                   MOVE      'Y'           WFIRST            1
      *
     C     MACORF        SETLL     SECODRL1
     C     MACORF        READE     SECODRL1                               89
      *                                                                   137879
     C     *IN89         IFEQ      '1'                                          B*6            13787
     C                   MOVE      MASTAT        #1STAT                                        13787
     C                   ENDIF                                                  E*6            13787
      *
     C     *IN89         DOWEQ     '0'                                          B*6
      *
     C     MSRECI        IFEQ      'D'                                          B*6A
      *
     C     WFIRST        IFEQ      'Y'                                          B*7
     C                   MOVE      MSFAID        #1FINA
     C                   MOVE      MSCOST        #1STAT
     C                   MOVE      'N'           WFIRST
     C                   ELSE                                                   X*7
      *
      **  RETRIEVE THE "HIGHER" FINAL ALLOCATION INDICATOR
      *
     C     MSFAID        IFEQ      'Y'                                          B*8
     C                   MOVE      MSFAID        #1FINA
     C                   ELSE                                                   X*8
     C     MSFAID        IFEQ      'S'                                          B*9
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      MSFAID        #1FINA
     C                   ENDIF                                                  E*9
     C                   ENDIF                                                  E*8
      *
      **  RETRIEVE THE "HIGHER" STATUS
      *
     C     MSCOST        IFEQ      'C'                                          B*8
     C                   MOVE      MSCOST        #1STAT
     C                   ELSE                                                   X*8
     C     MSCOST        IFEQ      'X'                                          B*9
     C     #1STAT        IFEQ      'S'                                          B10
     C     #1STAT        OREQ      'L'
     C     #1STAT        OREQ      'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF                                                  E*10
     C                   ENDIF                                                  E*9
      *
     C     MSCOST        IFEQ      'S'                                          B*9
     C     #1STAT        IFEQ      'L'                                          B10
     C     #1STAT        OREQ      'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF                                                  E*10
     C                   ENDIF                                                  E*9
      *
     C     MSCOST        IFEQ      'L'                                          B*9
     C     #1STAT        ANDEQ     'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF                                                  E*9
     C                   ENDIF                                                  E*8
     C                   ENDIF                                                  E*7
     C                   ENDIF                                                  E*6A
      *
     C     MACORF        READE     SECODRL1                               89
     C                   ENDDO                                                  E*6
      *
     C     #1FINA        IFEQ      *BLANKS                                      B*6
     C     #1STAT        ANDEQ     *BLANKS
     C                   MOVE      'N'           #1FINA
     C                   MOVE      'I'           #1STAT
     C                   ENDIF                                                  E*6
      *
      **   IF ONE OF THE 'SELECTION' FIELD IS NOT BLANK
      **    CHECK IF THE RECORD MUST BE TAKEN OR NOT IN THE SUBFILE
      *
     C     #STAT         IFNE      *BLANKS                                      B*2
      *
     C     #STAT         IFNE      MASTAT                                       B*3
     C                   GOTO      TAG1
     C                   ENDIF                                                  E*3
      *
     C                   ENDIF                                                  E*2
      *
     C     #COAT         IFNE      *BLANKS                                      B*2
      *
     C     #COAT         IFNE      MACOAT                                       B*3
     C                   GOTO      TAG1
     C                   ENDIF                                                  E*3
      *
     C                   ENDIF                                                  E*2
      *
      **   IF AMEND MODE AND CMD 9 NOT PRESSED
      **   OR IF ADD MODE AND CMD 9 PRESSED
      *
     C     *IN43         IFEQ      '1'                                          B*2
     C     *IN09         ANDEQ     '0'
     C     *IN43         OREQ      '0'
     C     *IN09         ANDEQ     '1'
      *
      **   IF 'LOCKED BY USER IDENTIFIER' IS NOT BLANK
      **     PROTECT ALL SUBFILE RECORD FIELDS
      *
     C     MAUSER        IFNE      *BLANKS                                      B*3
     C                   MOVE      '1'           *IN63
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN63
     C                   ENDIF                                                  E*3
      *
      **   IF 'CORPORATE ACTION STATUS' IS 'I' OR 'L' AND FINAL INDICATOR 'N'
      **     NON-PROTECT 'EX-DATE' SUBFILE FIELD
      *
     C     #1STAT        IFEQ      'I'                                          B*3
     C     #1STAT        OREQ      'L'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      '0'           *IN59
     C                   ELSE                                                   X*3
     C                   MOVE      '1'           *IN59
     C                   ENDIF                                                  E*3
      *
      **   IF 'CORPORATE ACTION STATUS' IS EQUAL TO S/X/C/R, PROTECT ALLOCATION
      *
     C     #1STAT        IFEQ      'S'                                          B*3
     C     #1STAT        OREQ      'X'
     C     #1STAT        OREQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '0'           *IN48
     C                   ELSE                                                   X*3
     C                   MOVE      '1'           *IN48
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
     C/COPY WNCPYSRC,SEH00001
      **   IF 'CORPORATE ACTION STATUS' IS 'C' OR 'R', PROTECT DATE OF ANNOUNCEM
      *
     C     #1STAT        IFEQ      'C'                                          B*3
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN75
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN75
     C                   ENDIF                                                  E*3
      *
     C                   ADD       1             #1RRN                81        SFLRCDNBR
     C                   ADD       1             WWCPT                          SCREEN LINE NBR
      *
      **   CLEAR SFL FIELDS
      *
     C                   EXSR      P015
      *
      **   LOAD SFL FIELDS
      *
     C                   EXSR      P016
      *
      **   ADD RECORD IN SUBFILE
      *
     C                   WRITE     SE7502S0
      *
     C     TAG1          TAG
      *
      **   READ NEXT RECORD OF THE ER REFERENCE FILE
      *
     C                   EXSR      R002
      *
      **   END OF DO WHILE
      *
     C                   ENDDO                                                  E*1
      *
      **   SAVE POSITION
      *
     C                   Z-ADD     #1RRN         WWRRN                          SAVE SFL.RCD.NBR.
      *
      **   IF IT'S NOT A ROLLUP
      *
     C     *IN27         IFEQ      '0'                                          B*1
     C                   Z-ADD     1             #1RRN
     C                   ENDIF                                                  E*1
      *
      **   IF NO RECORDS FOUND, DISPLAY ERROR MESSAGE
      **   SEND MESSAGE 'NO DATA TO DISPLAY'
      *
     C     WWCPT         IFEQ      *ZEROS                                       B*1
     C                   MOVEL     'CO00001'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P007   : VALIDATE POSITION/SELECTION FIELDS                   *
      *****************************************************************
      *
     C     P007          BEGSR
      *
     C***********        MOVE      '0'           *IN53                          Access by Sec CSE020
     C                   MOVE      '0'           WIN53                          Access by Sec CSE020
     C                   MOVE      '0'           *IN54                          Access by Ex-D. & Se
     C                   MOVE      '0'           *IN55                          Access by Reference
     C                   MOVE      '0'           *IN89                          Valid Numeric Field
      *
      **   IF REFERENCE NUMBER IS DIFFERENT THEN BLANKS
      *
     C     #REFN         IFNE      *BLANKS                                      B*1
      *
      **   CHECK IT'S A VALID NUMERIC FIELD
      *
     C     DIGITS        CHECK     #REFN:1       N                 1 0    89
      *
      **   IF IT'S NOT A VALID NUMERIC FIELD
      *
     C     *IN89         IFEQ      '1'                                          B*2
     C                   MOVE      '1'           *IN50                          Reverse image
     C                   MOVEL     'CO00004'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
      *
      **   IF SECURITY OR EX-DATE IS/ARE DIFFERENT THAN BLANKS
      *
     C     #SECN         IFNE      *BLANKS                                      B*2
     C     #EXDT         ORNE      *BLANKS
     C                   MOVE      '1'           *IN50                          Reverse image
     C                   MOVEL     'CO00030'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF EX-DATE IS DIFFERENT THAN BLANKS
      *
     C     #EXDT         IFNE      *BLANKS                                      B*1
      *
      **   VERIFY IF IT'S A VALID DATE FORMAT
      *
     C                   MOVE      #EXDT         ZDATE
     C                   EXSR      ZDATE1
      *
      **   IT'S NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      '1'           *IN52                          Reverse image
     C                   MOVEL     'CO00006'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'TYPE' IS DIFFERENT THAN BLANKS
      *
     C     #COAT         IFNE      *BLANKS                                      B*1
      *
      **   CORPORATE ACTION TYPE MUST BE A LIVE ACTION TYPE
      *
     C     #COAT         CHAIN     SECOATL0                           89
      *
     C     *IN89         IFEQ      '1'
     C     MMRECI        ORNE      'D'
     C                   MOVE      '1'           *IN69                          Reverse image
     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'STATUS' IS DIFFERENT THAN BLANKS
      *
     C     #STAT         IFNE      *BLANKS                                      B*1
      *
      **   IF 'STATUS' IS NOT A VALID STATUS (I, L, X, S, C, R)
      *
     C     #STAT         IFNE      'I'                                          B*2
     C     #STAT         ANDNE     'L'
     C     #STAT         ANDNE     'X'
     C     #STAT         ANDNE     'S'
     C     #STAT         ANDNE     'C'
     C     #STAT         ANDNE     'R'
     C                   MOVE      '1'           *IN86                          Reverse image
     C                   MOVEL     'CO00008'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF NO ERROR INDICATOR ON
      *
     C     *IN50         IFEQ      '0'                                          B*1
     C     *IN51         ANDEQ     '0'
     C     *IN52         ANDEQ     '0'
     C     *IN69         ANDEQ     '0'
     C     *IN86         ANDEQ     '0'
      *
     C                   MOVE      #REFN         #3REFN
     C                   MOVE      #COAT         #3COAT
     C                   MOVE      #STAT         #3STAT
     C                   MOVE      #EXDT         #3EXDT
      *
      **   IF SECURITY FIELD IS SELECTED
      *
     C     #SECN         IFNE      *BLANKS                                      B*2
      *
     C                   MOVE      #SECN         #3SECN
      *
      **   SETON AN INDICATOR TO DETERMINE THAN THE ACCESS IN THE ER REFERENCE
      **   MUST BE DONE BY SECURITY AND EX-DATE AND REFERENCE
      *
     C***********        MOVE      '1'           *IN53                                        CSE020
     C                   MOVE      '1'           WIN53                                        CSE020
     C                   MOVE      #EXDT         #3EXDT
      *
      **   ELSE, SECURITY FIELD IS LEAVED BLANK
      *
     C                   ELSE                                                   X*2
     C                   MOVE      *BLANKS       #3SECN
      *
      **   IF EX-DATE FIELD IS SELECTED, SETON AN INDICATOR TO DETERMINE
      **   THAN THE ACCESS IN THE ER REFERENCE FILE MUST BE DONE BY EX-DATE
      **   AND SECURITY FIELDS
      *
     C     #EXDT         IFNE      *BLANKS                                      B*3
     C                   MOVE      #EXDT         #3EXDT
     C                   MOVE      '1'           *IN54
      *
      **   ELSE, SECURITY AND EX-DATE FIELD ARE LEAVED BLANK, SETON AN INDICATOR
      **   TO DETERMINE THAT THE ACCESS IN THE ER REFERENCE FILE MUST BE DONE
      **   BY REFERENCE
      *
     C                   ELSE                                                   B*3
     C                   MOVE      *BLANKS       #3EXDT
     C                   MOVE      '1'           *IN55
     C                   ENDIF                                                  E*3
      *
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *                                                                                       CSE020
      ** Do not display level column if either Security, Ex-date,                             CSE020
      ** Type or Status is non-blank.                                                         CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     #REFN         ANDEQ     *BLANKS                                                    CSE020
     C     #SECN         ANDEQ     *BLANKS                                                    CSE020
     C     #EXDT         ANDEQ     *BLANKS                                                    CSE020
     C     #COAT         ANDEQ     *BLANKS                                                    CSE020
     C     #STAT         ANDEQ     *BLANKS                                                    CSE020
     C                   MOVE      '1'           *IN45                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      '0'           *IN45                                        CSE020
     C                   ENDIF                                                                CSE020
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * P008   : VALIDATE SUBFILE RECORDS                             *
      *****************************************************************
      *
     C     P008          BEGSR
      *
     C                   MOVE      'N'           ERMSG             1
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C/COPY WNCPYSRC,SE7502C012
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      **   READ CHANGED SUBFILE RECORD
      *
     C                   READC     SE7502S0                               87
     C/COPY WNCPYSRC,SE7502C013
      *
      **   SETUP THE RRN WITH THE CURRENT CPF'S POSITION WITHIN THE SUBFILE
      *
     C     *IN87         IFEQ      '1'                                          B*1
     C                   Z-ADD     CPFPOS        #1RRN
     C                   ENDIF                                                  E*1
      *
      **   DO WHILE END OF FILE IS NOT REACHED AND F12 OR F3 NOT PRESSED
      *
     C     *IN87         DOWEQ     '0'                                          B*1
     C     *INKC         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
      *
      **   REINITIALIZE ERROR INDICATORS
      *
     C                   EVAL      WREDSP = 'N'                                               215168
     C                   EXSR      P014
      *
     C                   MOVE      '1'           *IN84                          SFLNXTCHG
      *
      **   IF 'ADD MODE'
      *
     C     *IN43         IFEQ      '0'                                          B*2
     C     *IN61         ANDEQ     '0'
      *
      **   IF AT LEAST ONE FIELD IS DIFFERENT THAN BLANKS
      *
     C     #1SECN        IFNE      *BLANKS                                      B*3
     C     #1COAT        ORNE      *BLANKS
     C     #1COAN        ORNE      *BLANKS
     C     #1EXDT        ORNE      *BLANKS
     C     #1ALEF        ORNE      *BLANKS
     C     #1NBOP        ORNE      *BLANKS
      *
      **   IF 'SECURITY SHORTNAME' LEFT BLANK
      *
     C     #1SECN        IFEQ      *BLANKS                                      B*4
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00005'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*4
      *
      **   CHECK SECURITY SHORTNAME
      *
     C/COPY WNCPYSRC,SE7502C002
      *
      **   ACCESS SECURITY DETAILS WITH CURRENT SECURITY SHORTNAME
      *
     C     CSE010        IFEQ      'Y'                                                        215168
     C     '?'           SCAN      #1SECN                                 01                  215168
     C                   IF        *IN01                                                      215168
     C                   CALL      'SE0043'                                                   215168
     C                   PARM                    WLACTN                                       215168
     C                   PARM      '?'           WSECN                                        215168
      *                                                                                       215168
     C                   IF        WSECN <> *BLANKS                                           215168
     C                   EVAL      #1SECN = WSECN                                             215168
     C                   ELSE                                                                 215168
     C                   EVAL      #1SECN = *BLANKS                                           215168
     C                   ENDIF                                                                215168
     C                   EVAL      WREDSP = 'Y'                                               215168
     C                   ENDIF                                                                215168
     C                   ENDIF                                                                215168
      *                                                                                       215168
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      **   IF RECORD IS NOT FOUND OR IS FOUND BUT NOT "LIVE"
      *
     C     *IN89         IFEQ      '1'                                          B*5
     C     *IN89         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00007'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*5
      *
      **   FOR CORPORATE ACTION WITH PROCESSING TYPE 'DV'
      *
     C     MMPTYP        IFEQ      'DV'                                         B*6
      *
      **   ACCESS INVESTMENT TYPE FILE
      *
     C                   MOVE      NMCY          KNMCY             3
     C                   MOVE      SITP          KSITP             3
      *
     C     KEY3          CHAIN     INVTP                              89
      *
      **   IF NO RECORD FOUND
      *
     C     *IN89         IFEQ      '1'                                          B*7
     C                   MOVEL     NMCY          WFLD1             6
     C                   MOVE      SITP          WFLD1
     C                   MOVEL     '005'         DBASE                          *****************
     C                   MOVE      'INVTP   '    DBFILE                         * DB ERROR 05   *
     C                   MOVEL     WFLD1         DBKEY                          *****************
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E*7
      *
      **   PROCESSING TYPE MUST BE '4' OR '7'
      *
     C     PROT          IFNE      '4'                                          B*7
     C     PROT          ANDNE     '7'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00012'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*7
     C                   ENDIF                                                  E*6
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
      *
      **   IF 'ACTION TYPE' LEFT BLANK
      *
     C     #1COAT        IFEQ      *BLANKS                                      B*4
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*4
      *                                                                                       215168
     C     '?'           SCAN      #1COAT                                 01                  215168
     C                   IF        *IN01                                                      215168
     C                   CALL      'SE7501S'                                                  215168
     C                   PARM      '?'           WCOAT                                        215168
      *                                                                                       215168
     C                   IF        WCOAT <> *BLANKS                                           215168
     C                   EVAL      #1COAT = WCOAT                                             215168
     C                   ELSE                                                                 215168
     C                   EVAL      #1COAT = *BLANKS                                           215168
     C                   ENDIF                                                                215168
     C                   EVAL      WREDSP = 'Y'                                               215168
     C                   ENDIF                                                                215168
      *
      **   CORPORATE ACTION TYPE MUST BE A LIVE ACTION TYPE
      *
     C     #1COAT        CHAIN     SECOATL0                           89
      *
     C     *IN89         IFEQ      '1'                                          B*5
     C     MMRECI        ORNE      'D'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*5
      *                                                                   136419
     C     *IN89         IFEQ      '0'                                          B*5            13641
     C     MMPTYP        ANDEQ     'CC'                                                        13641
     C                   MOVE      'Y'           ERMSG                                         13641
     C                   MOVE      '1'           *IN33                          Reverse image  13641
     C                   MOVEL     'CO00577'     ZAMSID                         Message id.    13641
     C                   EXSR      ZASNMS                                       Send message   13641
     C                   ENDIF                                                  E*5            13641
     C                   ENDIF                                                  E*4
      *
      **   VALIDATION 'NUMBER OF OPTION'
      *
     C     #1NBOP        IFNE      *BLANKS                                      B*4
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     #1NBOP        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        #1NBOP
     C                   MOVE      #1NBOP        W1NBOP
      *
      **   IF IT'S NOT A VALID NUMERIC FIELD BETWEEN 1 AND 9
      *
     C     *IN99         IFEQ      '1'                                          B*5
     C     W1NBOP        ORLT      1
     C     W1NBOP        ORGT      9
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVEL     'CO00042'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*5
     C     MMPTYP        IFEQ      'NF'                                         B*6
     C     W1NBOP        ANDNE     1
     C     MMPTYP        OREQ      'NC'
     C     W1NBOP        ANDNE     1
     C     MMPTYP        OREQ      'CC'                                                        CEU01
     C     W1NBOP        ANDNE     1                                                           CEU01
     C/COPY WNCPYSRC,SE7502C014
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVEL     'CO00261'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*6
     C                   ENDIF                                                  E*5
      *
     C                   ELSE                                                   X*4
     C                   MOVE      '01'          #1NBOP
     C                   ENDIF                                                  E*4
      *
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   IF NOT ENQUIRY MODE
      *
     C     *IN61         IFEQ      '0'                                          B*2
      *
      **   IF AT LEAST ONE FIELD IS DIFFERENT THAN BLANK
      *
     C     #1EXDT        IFNE      *BLANKS                                      B*3
     C     #1REFN        ORNE      *BLANKS
     C     #1SECN        ORNE      *BLANKS
     C     #1ALEF        ORNE      *BLANKS
     C     #1COAN        ORNE      *BLANKS
      *
      **   IF LAST ALLOCATION DATE IS CHANGED
      *
     C     #1COAN        IFNE      #2COAN                                       B*4
     C     #1COAN        ANDNE     *BLANKS
      *
     C                   MOVE      #1COAN        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF DATE OF ANNOUNCEMENT IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*5
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVEL     'CO00033'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
      *
      **   IF EX-DATE IS CHANGED
      *
     C     #1EXDT        IFNE      #2EXDT                                       B*4
     C     #1EXDT        ANDNE     *BLANKS
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF EX-DATE IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*5
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00006'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*5
     C                   Z-ADD     ZDAYNO        WEXDT
      *
      **   IF EX-DATE LOWER OR EQUAL THAN SE BACK VALUE DATE
      *
     C     WEXDT         IFLE      WBACKD
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00013'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*6
      *
      **   IF EX-DATE NOT LOWER THAN SECURITY MATURITY DATE
      *
     C     WEXDT         IFGE      MATY                                         B*6
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00014'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*6
      *                                                                                       CSE020
      ** Validate Ex-date so that it is equal to that of the Parent                           CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     #1MPRF        ANDNE     *BLANKS                                                    CSE020
     C     #1MPRF        CHAIN     SECORFL9                           89                      CSE020
     C     *IN89         IFEQ      '0'                                                        CSE020
     C     WEXDT         ANDNE     MACOEX                                                     CSE020
     C                   MOVE      'Y'           ERMSG                                        CSE020
     C                   MOVE      '1'           *IN32                                        CSE020
     C                   MOVEL     'CO00368'     ZAMSID                                       CSE020
     C                   EXSR      ZASNMS                                                     CSE020
     C                   ENDIF                                                                CSE020
     C     #1REFN        CHAIN     SECORFL9                           89                      CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                  E*5
      *                                                                                       CSE020
     C                   ELSE                                                                 CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     #1MPRF        ANDNE     *BLANKS                                                    CSE020
     C     #1MPRF        CHAIN     SECORFL9                           89                      CSE020
     C     *IN89         IFEQ      '0'                                                        CSE020
     C     MACOEX        ANDNE     *ZEROS                                                     CSE020
     C     #1EXDT        ANDEQ     *BLANKS                                                    CSE020
     C                   MOVE      'Y'           ERMSG                                        CSE020
     C                   MOVE      '1'           *IN32                                        CSE020
     C                   MOVEL     'CO00368'     ZAMSID                                       CSE020
     C                   EXSR      ZASNMS                                                     CSE020
     C                   ENDIF                                                                CSE020
     C     #1REFN        CHAIN     SECORFL9                           89                      CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                  E*4
      *
      **   IF ALLOCATION EFFECTIVE DATE IS CHANGED
      *
     C     #1ALEF        IFNE      #2ALEF                                       B*4
     C     #1ALEF        ANDNE     *BLANKS
      *
      **   IF 'ALLOCATION EFFECTIVE DATE' ENTERED
      *
     C                   MOVE      #1ALEF        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WALEF
      *
      **   IF ALLOCATION EFFECTIVE DATE IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*5
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVEL     'CO00041'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*5
      *
     C     WALEF         IFLT      WEXDT                                        B*5
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVEL     'CO00251'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*5
      *
      **   IF DATE NOT LOWER THAN SECURITY MATURITY DATE
      *
     C     WALEF         IFGE      MATY                                         B*5
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00300'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*5
     C/COPY WNCPYSRC,SEH00002
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   IF 'AMEND MODE' OR 'ENQUIRY' MODE
      *
     C     *IN43         IFEQ      '1'                                          B*2
     C     *IN61         OREQ      '1'
      *
      **   IF ACTION INDICATOR IS CHANGED
      *
     C     #1SEL         IFNE      *BLANKS                                      B*3
     C                   EXSR      P008A
     C                   ENDIF                                                  E*3
      *
      **   PROCESS ACTION (ONLY ENQUIRY MODE)
      *
     C     ERMSG         IFEQ      'N'                                          B*3
     C     *IN61         ANDEQ     '1'
     C                   EXSR      P009
     C                   MOVE      '0'           *IN84
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   IF AN ERROR MESSAGE IS SENT
      **   OR IF 'ADD MODE'
      *
     C     ERMSG         IFEQ      'Y'                                          B*2
     C     *IN43         OREQ      '0'
      *
      **   IF 'CORPORATE ACTION STATUS' IS 'I' OR 'L' AND FINAL INDICATOR 'N'
      **     NON-PROTECT 'EX-DATE' SUBFILE FIELD (AMEND MODE)
      *
     C     *IN43         IFEQ      '1'                                          B*3
      *
     C     #1STAT        IFEQ      'I'                                          B*4
     C     #1STAT        OREQ      'L'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      '0'           *IN59
     C                   ELSE                                                   X*4
     C                   MOVE      '1'           *IN59
     C                   ENDIF                                                  E*4
      *
      **   IF 'CORPORATE ACTION STATUS' IS EQUAL TO S/X/C/R, PROTECT ALLOCATION
      *
     C     #1STAT        IFEQ      'S'                                          B*3
     C     #1STAT        OREQ      'X'
     C     #1STAT        OREQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '0'           *IN48
     C                   ELSE                                                   X*3
     C                   MOVE      '1'           *IN48
     C                   ENDIF                                                  E*3
     C/COPY WNCPYSRC,SEH00003
      *
      **   IF 'CORPORATE ACTION STATUS' IS 'C' OR 'R', PROTECT DATE OF ANNOUNCEM
      *
     C     #1STAT        IFEQ      'C'                                          B*3
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN75
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN75
     C                   ENDIF                                                  E*3
      *
      **   IF 'LOCKED BY USER IDENTIFIER' IS NOT BLANK
      **     PROTECT ALL SUBFILE RECORD FIELDS
      *
     C***********#1REFN    CHAINSECORFL1             89                   136421
     C     #1REFN        CHAIN     SECORFL9                           89                       13642
      *
     C     MAUSER        IFNE      *BLANKS                                      B*4
     C                   MOVE      '1'           *IN63
     C                   ELSE                                                   X*4
     C                   MOVE      '0'           *IN63
     C                   ENDIF                                                  E*4
      *
     C                   ENDIF                                                  E*3
      *
      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
      *
     C/COPY WNCPYSRC,SE7502C015
     C                   UPDATE    SE7502S0
     C/COPY WNCPYSRC,SE7502C016
      *
      **   GOTO NEXT READ OF THE SUBFILE CHANGING
      *
     C                   GOTO      TAG4
     C                   ENDIF                                                  E*2
      *
      **   IF 'AMEND MODE'
      *
     C     *IN43         IFEQ      '1'                                          B*2
      *
      **   IF DATE OF ANNOUNCEMENT, EX-DATE, FINAL INDICATOR, STATUS OR ALLOCATI
      **   EFFECTIVE DATE IS/ARE CHANGED
      *
     C     #1COAN        IFNE      #2COAN                                       B*3
     C     #1EXDT        ORNE      #2EXDT
     C     #1ALEF        ORNE      #2ALEF
      *
      **   ACCESS CORPORATE ACTION REFERENCE FILE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           89
      *
      **   IF RECORD IS DIFFERENT THAN READ AT CHARGING OF SUBFILE
      *
     C     FIELD         IFNE      #FIELD                                       B*4
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
      *
      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
      *
     C/COPY WNCPYSRC,SE7502C017
     C                   UPDATE    SE7502S0
     C/COPY WNCPYSRC,SE7502C018
      *
      **   RELEASE THE RECORD
      *
     C     #1REFN        SETLL     SECORFL0
      *
      **   GOTO NEXT READ OF THE SUBFILE CHANGING
      *
     C                   GOTO      TAG4
     C                   ELSE                                                   X*4
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
      *
      **   IF DATE OF ANNOUNCEMENT CHANGED
      *
     C     #1COAN        IFNE      #2COAN                                       B*5
      *
     C                   MOVE      #1COAN        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACOAN
     C                   MOVE      #1COAN        #2COAN
      *
     C                   ENDIF                                                  E*5
      *
      **   IF EX-DATE CHANGED
      *
     C     #1EXDT        IFNE      #2EXDT                                       B*5
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACOEX
      *
     C                   MOVE      #1EXDT        #2EXDT
      *
     C                   ENDIF                                                  E*5
      *
      **   IF ALLOCATION EFFECTIVE DATE CHANGED
      *
     C     #1ALEF        IFNE      #2ALEF                                       B*5
     C/COPY WNCPYSRC,SEH00004
     C                   MOVE      #1ALEF        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MAALEF
     C                   MOVE      #1ALEF        #2ALEF
     C                   ENDIF                                                  E*5
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      MAJOBN        WAJOBN           10
     C                   MOVE      MAUSER        WAUSER           10
     C                   Z-ADD     MAJNBR        WAJNBR            6 0
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      WAJOBN        MAJOBN
     C                   MOVE      WAUSER        MAUSER
     C                   Z-ADD     WAJNBR        MAJNBR
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
      *
      **   EXECUTE COMMITMENT CONTROL
      *
     C                   COMMIT
      *
      **   IF ACTION IS CHANGED
      *
     C     #1SEL         IFNE      #2SEL                                        B*3
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           89
      *
      **   IF RECORD IS DIFFERENT THAN READ AT CHARGING OF SUBFILE
      *
     C     FIELD         IFNE      #FIELD                                       B*4
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
      *
      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
      *
     C/COPY WNCPYSRC,SE7502C019
     C                   UPDATE    SE7502S0
      *
     C/COPY WNCPYSRC,SE7502C020
      **   RELEASE THE RECORD
      *
     C     #1REFN        SETLL     SECORFL0
      *
      **   GOTO NEXT READ OF THE SUBFILE CHANGING
      *
     C                   GOTO      TAG4
     C                   ELSE                                                   X*4
      *
     C                   MOVE      ##JOB         MAJOBN
     C                   MOVE      ##USR         MAUSER
     C                   Z-ADD     ##JNO         MAJNBR
      *
      **   UPDATE THE RECORD IN CORPORATE ACTION REFERENCE FILE
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      MAJOBN        WAJOBN           10
     C                   MOVE      MAUSER        WAUSER           10
     C                   Z-ADD     MAJNBR        WAJNBR            6 0
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      WAJOBN        MAJOBN
     C                   MOVE      WAUSER        MAUSER
     C                   Z-ADD     WAJNBR        MAJNBR
      *
      **   EXECUTE THE COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
      **   PROCESS ACTION
      *
     C                   EXSR      P009
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
      *
      **   IF 'CORPORATE ACTION STATUS' IS 'I' OR 'L' AND FINAL INDICATOR 'N'
      **     NON-PROTECT 'EX-DATE' SUBFILE FIELD (AMEND MODE)
      *
     C     #1STAT        IFEQ      'I'                                          B*4
     C     #1STAT        OREQ      'L'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      '0'           *IN59
     C                   ELSE                                                   X*4
     C                   MOVE      '1'           *IN59
     C                   ENDIF                                                  E*4
      *
      **   IF 'CORPORATE ACTION STATUS' IS EQUAL TO S/X/C/R, PROTECT ALLOCATION
      *
     C     #1STAT        IFEQ      'S'                                          B*3
     C     #1STAT        OREQ      'X'
     C     #1STAT        OREQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '0'           *IN48
     C                   ELSE                                                   X*3
     C                   MOVE      '1'           *IN48
     C                   ENDIF                                                  E*3
     C/COPY WNCPYSRC,SEH00005
      *
      **   IF 'CORPORATE ACTION STATUS' IS 'C' OR 'R', PROTECT DATE OF ANNOUNCEM
      *
     C     #1STAT        IFEQ      'C'                                          B*3
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN75
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN75
     C                   ENDIF                                                  E*3
      *
      **   IF 'LOCKED BY USER IDENTIFIER' IS NOT BLANK
      **     PROTECT ALL SUBFILE RECORD FIELDS
      *
     C     MAUSER        IFNE      *BLANKS                                      B*4
     C                   MOVE      '1'           *IN63
     C                   ELSE                                                   X*4
     C                   MOVE      '0'           *IN63
     C                   ENDIF                                                  E*4
      *
      **   IF NO ERROR MESSAGE SENT
      *
     C     ERMSG         IFEQ      'N'                                          B*3
     C                   MOVE      '0'           *IN84
     C/COPY WNCPYSRC,SE7502C021
     C                   UPDATE    SE7502S0
     C/COPY WNCPYSRC,SE7502C022
     C                   ELSE                                                   X*3
     C                   MOVE      '1'           *IN84
     C/COPY WNCPYSRC,SE7502C023
     C                   UPDATE    SE7502S0
     C/COPY WNCPYSRC,SE7502C024
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
     C     TAG4          TAG
      *
     C/COPY WNCPYSRC,SE7502C025
     C                   WRITE     #MSGCTL
      *
      **   READ CHANGED SUBFILE RECORD
      *
     C                   READC     SE7502S0                               87
     C/COPY WNCPYSRC,SE7502C026
     C                   ENDDO                                                  E*1
      *
      **   IF 'ADD MODE'
      **   AND IF NO ERROR MESSAGE IS SENT
      *
     C     *IN43         IFEQ      '0'                                          B*1
     C     *IN61         ANDEQ     '0'
     C     ERMSG         ANDEQ     'N'
     C     WREDSP        ANDNE     'Y'                                                        215168
      *
     C                   Z-ADD     1             #1RRN
     C                   MOVE      'Y'           FINSR             1
      *
      **   READ FIRST RECORD OF SUBFILE
      *
     C/COPY WNCPYSRC,SE7502C027
     C                   READC     SE7502S0                               87
     C/COPY WNCPYSRC,SE7502C028
      *
      **   DO WHILE END OF SUBFILE IS NOT REACHED
      *
     C     *IN87         DOWEQ     '0'                                          B*2
      *
      **   RETRIEVE NEXT AVAILABLE REFERENCE NUMBER
      *
     C                   EXSR      P021
      *
      **   IF SECURITY SHORTNAME IS LEFT BLANK (IT MEANS THAT RECORD IS BLANK)
      *
     C     #1SECN        IFNE      *BLANKS                                      B*3
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C***********#1REFN    CHAINSECORFL1             88                   136421
     C     #1REFN        CHAIN     SECORFL9                           88                       13642
      *
      **   IF A RECORD IS FOUND
      *
     C     *IN88         IFEQ      '0'                                          B*4
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00002'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
      *
      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
      *
     C/COPY WNCPYSRC,SE7502C029
     C                   UPDATE    SE7502S0
     C/COPY WNCPYSRC,SE7502C030
      *
      **   ROLLBACK INSTRUCTION TO REVERSE ALL INSERTS
      *
     C                   ROLBK
      *
      **   TERMINATE CURRENT PROCESSING
      *
     C                   GOTO      TAG5
     C                   ELSE                                                   X*4
      *
      **   WRITE A RECORD IN CORPORATE ACTION REFERENCE FILE
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'I'           MACHTP
     C                   MOVE      ##USR         MALUID
     C                   MOVE      #1REFN        MACORF
     C*****                MOVE *BLANKS   MAJOBN                          137879
     C*****                MOVE *BLANKS   MAUSER                          137879
     C*****                Z-ADD*ZEROS    MAJNBR                          137879
     C                   MOVE      ##JOB         MAJOBN                                        13787
     C                   MOVE      ##USR         MAUSER                                        13787
     C                   Z-ADD     ##JNO         MAJNBR                                        13787
     C                   MOVE      #1SECN        MASESN
     C                   MOVE      #1COAT        MACOAT
      *
     C     #1COAT        CHAIN     SECOATL0                           89
     C                   MOVE      MMPTYP        MAPTYP
      *
     C     #1COAN        IFNE      *BLANKS                                      B*5
     C                   MOVE      #1COAN        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACOAN
     C                   ELSE                                                   X*5
     C                   Z-ADD     *ZEROS        MACOAN
     C                   ENDIF                                                  E*5
      *
     C     #1EXDT        IFNE      *BLANKS                                      B*5
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACOEX
     C                   ELSE                                                   X*5
     C                   Z-ADD     *ZEROS        MACOEX
     C                   ENDIF                                                  E*5
      *
     C     #1ALEF        IFNE      *BLANKS                                      B*5
     C                   MOVE      #1ALEF        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MAALEF
     C                   ELSE                                                   X*5
     C                   Z-ADD     *ZEROS        MAALEF
     C                   ENDIF                                                  E*5
      *
     C                   MOVE      #1NBOP        MANBOP
     C                   MOVE      'T'           MATDVD
     C                   Z-ADD     MAALEF        MACOPD
     C                   Z-ADD     MAALEF        MATDDT
     C                   Z-ADD     MACOEX        MAEVDT
     C                   Z-ADD     *ZEROS        MACPNB
     C                   Z-ADD     *ZEROS        MASHMD
     C                   MOVE      'N'           MALTBS
     C                   Z-ADD     *ZEROS        MAOCPV
     C                   Z-ADD     *ZEROS        MANCPV
     C                   Z-ADD     *ZEROS        MAONML
     C                   Z-ADD     *ZEROS        MANNML
      *
     C                   MOVE      MASESN        KSECN
     C                   Z-ADD     MACOEX        KEXDT
      *                                                                   155622
     C     KEY7          SETLL     PRICM                                                       15562
     C                   READ      PRICM                                  89                   15562
      *                                                                   155622
     C     *IN89         IFEQ      '0'                                                         15562
     C     PSSN          ANDEQ     KSECN                                                       15562
     C     PVDT          ANDGE     KEXDT                                                       15562
     C     KEXDT         ANDNE     *ZEROS                                                      15562
     C                   Z-ADD     PPRC          MACUPC                                        15562
     C                   Z-ADD     PPRC          MAEXPC                                        15562
     C                   ELSE                                                                  15562
S3    *                                                                   155622
     C                   MOVE      'PR'          KTYPE
      *
     C     KEY5          SETLL     SECED
     C                   READ      SECED                                  89
      *
     C     *IN89         IFEQ      '0'
     C     SNSN          ANDEQ     KSECN
     C     SNDT          ANDGE     KEXDT
     C     SNET          ANDEQ     'PR'
     C     KEXDT         ANDNE     *ZEROS                                                      15562
     C                   Z-ADD     SNPR          MACUPC
     C                   Z-ADD     SNPR          MAEXPC
     C                   ELSE
     C     KSECN         CHAIN     SECTYZ1                            89                       15562
     C     *IN89         IFEQ      '0'                                                         15562
     C                   Z-ADD     MKPR          MACUPC                                        15562
     C                   Z-ADD     MKPR          MAEXPC                                        15562
     C                   ELSE                                                                  15562
     C                   Z-ADD     *ZEROS        MACUPC
     C                   Z-ADD     *ZEROS        MAEXPC
     C                   ENDIF                                                                 15562
     C                   ENDIF
     C                   ENDIF                                                                 15562
      *
     C                   Z-ADD     *ZEROS        MACLRD
     C                   Z-ADD     *ZEROS        MACLRT
     C                   Z-ADD     *ZEROS        MADLRD
     C                   Z-ADD     *ZEROS        MADLRT
     C                   MOVE      'N'           MABLOS
     C                   MOVE      'N'           MABLOP
     C                   Z-ADD     *ZEROS        MABFRD
     C                   Z-ADD     *ZEROS        MABEND
      *                                                                                       CGL031
     C                   EVAL      MASETX = *BLANK                                            CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y' AND                                           CGL031
     C                             #1COAT = 'DI'                                              CGL031
     C                   EVAL      KSECN = #1SECN                                             CGL031
     C     KSECN         CHAIN     SECTYZ1                                                    CGL031
     C                   IF        %FOUND                                                     CGL031
     C                   EVAL      MASETX = SETX                                              CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
     C                   MOVE      'N'           MAREFO
     C                   MOVE      *BLANKS       MACONR
     C                   MOVE      *BLANKS       MADFNR
     C                   MOVE      *BLANKS       MADFCP
     C                   MOVE      *BLANKS       MADFSP
     C                   MOVE      'N'           MALREQ
     C                   Z-ADD     *ZEROS        MALPRO
     C                   MOVE      'N'           MALTSI
     C                   MOVE      'I'           MASTAT
     C                   MOVE      *BLANKS       MAPREF                                       CSE020
      *
     C                   WRITE     SECORFD0
      *
     C                   Z-ADD     1             WWOPNB            2 0
     C                   MOVE      #1NBOP        W1NBOP            2 0
      *
      **   WRITE THE RECORD(S) ON THE CORPORATE ACTION OPTION FILE
      **   DEPENDING OF THE PROCESSING TYPE
      *
     C     WWOPNB        DOWLE     W1NBOP                                       B*5
     C                   EXSR      P011
     C                   ADD       1             WWOPNB
     C                   ENDDO                                                  E*5
      *
      **   SAVE THE FIRST INSERTED RECORD FIELDS
      *
     C     FINSR         IFEQ      'Y'                                          B*5
     C                   MOVE      MACORF        KREFN
     C                   MOVE      '1'           *IN55
     C                   MOVE      'N'           FINSR
     C                   ENDIF                                                  E*5
      *
      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
      *
     C/COPY WNCPYSRC,SE7502C031
     C                   UPDATE    SE7502S0
     C/COPY WNCPYSRC,SE7502C032
      *                                                                   137879
      **   INITIALISE ERROR INDICATORS                                    137879
      *                                                                   137879
     C                   EVAL      *IN07 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN13                                         13787
     C                   MOVE      '0'           *IN14                                         13787
     C                   MOVE      '0'           *IN20                                         13787
     C                   MOVE      '0'           *IN21                                         13787
     C                   MOVE      '0'           *IN22                                         13787
     C                   MOVE      '0'           *IN23                                         13787
     C                   MOVE      '0'           *IN24                                         13787
     C                   MOVE      '0'           *IN31                                         13787
     C                   MOVE      '0'           *IN35                                         13787
     C                   MOVE      '1'           *IN36                                         13787
     C                   MOVE      '0'           *IN42                                         13787
     C                   MOVE      '1'           *IN43                                         13787
     C                   MOVE      '0'           *IN49                                         13787
     C                   MOVE      '0'           *IN60                                         13787
     C                   MOVE      '0'           *IN65                                         13787
     C                   MOVE      '0'           *IN66                                         13787
     C                   MOVE      '0'           *IN67                                         13787
     C                   MOVE      '0'           *IN70                                         13787
     C                   MOVE      '0'           *IN71                                         13787
     C                   MOVE      '0'           *IN72                                         13787
     C                   MOVE      '0'           *IN73                                         13787
     C                   MOVE      '0'           *IN74                                         13787
     C                   MOVE      '0'           *IN76                                         13787
     C                   MOVE      '0'           *IN77                                         13787
     C                   MOVE      '0'           *IN78                                         13787
     C                   MOVE      '0'           *IN79                                         13787
     C                   MOVE      '0'           *IN82                                         13787
     C                   MOVE      '0'           *IN83                                         13787
     C                   MOVE      '0'           *IN85                                         13787
      *                                                                   137879
     C                   MOVE      'N'           #1FINA                                        13787
     C                   MOVE      'I'           #1STAT                                        13787
     C                   MOVE      'G'           #1SEL                                         13787
     C                   MOVE      'Y'           WWINPT            1                           13787
     C                   EXSR      P018                                                        13787
     C                   MOVE      '0'           *IN36                                         13787
     C                   MOVE      '0'           *IN43                                         13787
     C                   MOVE      ' '           #1SEL                                         13787
     C                   MOVE      'N'           WWINPT                                        13787
      *                                                                   137879
     C     #1REFN        CHAIN     SECORFL0                           89                       13787
      *                                                                   137879
     C                   MOVE      *BLANKS       MAJOBN                                        13787
     C                   MOVE      *BLANKS       MAUSER                                        13787
     C                   Z-ADD     *ZEROS        MAJNBR                                        13787
      *                                                                   137879
     C     *IN89         IFEQ      '0'                                          B*5            13787
     C                   UPDATE    SECORFD0                                                    13787
     C                   ENDIF                                                  E*5            13787
     C/COPY WNCPYSRC,SE7502C003
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
      *
      **   READ FIRST RECORD OF SUBFILE
      *
     C/COPY WNCPYSRC,SE7502C033
     C                   READC     SE7502S0                               87
     C/COPY WNCPYSRC,SE7502C034
     C                   ENDDO                                                  E*2
      *
      **   IF AT LEAST ONE RECORD CREATED
      *
     C     W1CORF        IFNE      WWCORF                                       B*2
     C     *LOVAL        SETLL     SECORFPA
     C                   READ      SECORFPA                               89
      *
     C     *IN89         IFEQ      '0'                                          B*3
     C                   MOVE      WWCORF        MXCORF
     C                   UPDATE    SECORFP0
     C                   ENDIF                                                  E*3
      *
     C                   ENDIF                                                  E*2
      *
      **   EXECUTE COMMITMENT CONTROL TO FIX ALL INSERTED RECORDS
      *
     C                   COMMIT
      *
      **   SET KEY FIELDS FROM KLIST TO FIRST INSERTED RECORD
      *
      **   CLEAR SUBFILE
      *
     C                   Z-ADD     0             WWRRN             4 0          SAVE RCD.NBR.
      *
      **   CLEAR SUBFILE
      *
     C                   EXSR      P004
      *
      **   SET INDICATOR TO RETURN TO 'AMEND MODE'
      *
     C                   MOVE      '1'           *IN43
     C                   MOVEA     TXT(3)        ##CTX1
      *
      **   PROTECT ON 'POSITION/SELECTION' FIELDS *OFF
      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *OFF
      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *ON
      *
     C                   MOVE      '0'           *IN56
     C                   MOVE      '0'           *IN57
     C                   MOVE      '1'           *IN58
      *
     C***********        MOVE      '0'           *IN45                                        CSE020
     C                   MOVE      '0'           WIN45                                        CSE020
     C                   MOVE      '0'           *IN30
      *
     C/COPY WNCPYSRC,SE7502C035
     C                   EXSR      P006
     C/COPY WNCPYSRC,SE7502C036
      *
     C***********        MOVE      '1'           *IN45                                        CSE020
     C                   MOVE      '1'           WIN45                                        CSE020
      *
     C                   ENDIF                                                  E*1
      *
     C     TAG5          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P008A  : VALIDATE 'ACTION' FIELD                              *
      *****************************************************************
      *
     C     P008A         BEGSR
      *
      **   IF IT'S NOT THE REPORT MODE
      *
     C     *IN64         IFEQ      '0'                                          B*1
      *
      **   IF IT'S THE ENQUIRY MODE, THE 'ACTION' MUST BE EQUAL TO 'E' OR 'F'
      *
     C     *IN61         IFEQ      '1'                                          B*2
      *
     C     #1SEL         IFNE      'E'                                          B*3
     C     #1SEL         ANDNE     'F'
     C     #1SEL         ANDNE     'V'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00017'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*3
      *
     C                   ELSE                                                   X*2
      *
      **   'ACTION' CODE CAN BE 'G','F','A','E','R','Y','P','V','D','C','N'
      *
     C     #1SEL         IFNE      'G'                                          B*3
     C     #1SEL         ANDNE     'F'
     C     #1SEL         ANDNE     'A'
     C     #1SEL         ANDNE     'E'
     C     #1SEL         ANDNE     'R'
     C     #1SEL         ANDNE     'Y'
     C     #1SEL         ANDNE     'P'
     C     #1SEL         ANDNE     'V'
     C     #1SEL         ANDNE     'D'
     C     #1SEL         ANDNE     'C'
     C     #1SEL         ANDNE     'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00018'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   IF IT'S THE REPORT MODE, THE 'ACTION' MUST BE EQUAL TO 'P'
      *
     C                   ELSE                                                   X*1
      *
     C     #1SEL         IFNE      'P'                                          B*2
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00019'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'EX-DATE' IS *GE THAN 'RUN DATE' AND ACTION IS NOT EQUAL TO 'F'
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        KEXDT
      *
     C     #1SEL         IFEQ      'A'                                          B*1
     C     #1SEL         OREQ      'E'
     C     #1SEL         OREQ      'Y'
     C     KEXDT         IFGE      BJRDNB                                       B*2
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00020'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   ACCESS ER REFERENCE FILE
      *
     C***********#1REFN    CHAINSECORFL1             89                   136421
     C     #1REFN        CHAIN     SECORFL9                           89                       13642
      *
      **   IF LOCKED BY USER IDENTIFIER IS NOT BLANK
      *
     C     MAUSER        IFNE      *BLANKS                                      B*1
      *                                                                                      BUG2686
     C                   MOVEL     MAUSER        RTJOBW1          16                         BUG2686
     C                   MOVE      MAJNBR        RTJOBW1                                     BUG2686
     C                   MOVE      RTJOBW1       RTJOB                                       BUG2686
     C                   MOVEL     MAJOBN        RTJOB                                       BUG2686
      *                                                                                      BUG2686
     C                   CALL      'AOC8002'                                                 BUG2686
      *                                                                                      BUG2686
     C                   PARM                    RTJOB            26                         BUG2686
     C                   PARM                    RTNJOBW          10                         BUG2686
     C                   PARM                    RTNUSRW          10                         BUG2686
     C                   PARM                    RTNNUMW           6                         BUG2686
     C                   PARM                    RTNJIDW          16                         BUG2686
     C                   PARM                    RTNSTSW          10                         BUG2686
      *                                                                                      BUG2686
     C     RTNSTSW       IFEQ      '*ACTIVE'                                                 BUG2686
      *                                                                                      BUG2686
     C                   MOVE      MAUSER        WUSER
     C                   MOVE      MAJOBN        WJOBN
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     LOCKDS        ZAMSDA
     C                   MOVEL     'CO00021'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
      *                                                                                      BUG2686
     C                   ELSE                                                                BUG2686
      *                                                                                      BUG2686
     C     #1REFN        CHAIN     SECORFL0                           89                     BUG2686
     C                   MOVE      *BLANKS       MAUSER                                      BUG2686
     C                   MOVE      *BLANKS       MAJOBN                                      BUG2686
     C                   Z-ADD     *ZEROS        MAJNBR                                      BUG2686
      *                                                                                      BUG2686
     C                   UPDATE    SECORFD0                                                  BUG2686
     C                   MOVE      FIELD         #FIELD                                      BUG2686
      *                                                                                      BUG2686
     C                   COMMIT                                                              BUG2686
      *                                                                                      BUG2686
     C                   ENDIF                                                               BUG2686
      *                                                                                      BUG2686
     C                   ENDIF                                                  E*1
      *
      **   IF 'PROCESSING TYPE' IS NOT 'NC' AND 'ACTION' IS 'N'
      **     ERROR MESSAGE : ACTION 'N' NOT ALLOWED
      *
     C     #1PTYP        IFNE      'NC'                                         B*1
     C     #1SEL         ANDEQ     'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00254'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*1
     C/COPY WNCPYSRC,SE7502C037
      *
      **   IF 'ACTION' IS 'N' AND STATUS DIFFERENT THAN 'I'
      **     ERROR MESSAGE : ACTION 'N' NOT ALLOWED
      *
     C     #1SEL         IFEQ      'N'                                          B*1
     C     #1GSTS        ANDNE     'I'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00257'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*1
      *
      **   IF 'CO STATUS' IS 'AUTHORISED'
      **   AND ACTION IS 'G', 'D', 'Y' OR 'N'
      **    ERROR MESSAGE : ... NOT ALLOWED WITH STATUS 'X' (AUTHORISED)
      *
     C     #1GSTS        IFEQ      'X'                                          B*1
     C/COPY WNCPYSRC,SEH00022
     C     #1SEL         IFEQ      'G'                                          B*2
     C/COPY WNCPYSRC,SEH00006
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00023'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'CO STATUS' IS 'STOCK AUTHORISED'
      **   AND ACTION IS 'G', 'D', 'Y' OR 'N'
      **    ERROR MESSAGE : ... NOT ALLOWED WITH STATUS 'S' (STOCK AUTHORISED)
      *
     C     #1GSTS        IFEQ      'S'                                          B*1
     C*****      #1SEL     IFEQ 'G'                        B*2            137884
     C*****      #1SEL     OREQ 'D'                                       137884
     C     #1SEL         IFEQ      'D'                                                         13788
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00098'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'CO STATUS' IS 'COMPLETED'
      **   AND ACTION IS 'G','A','D','Y' OR 'N'
      **    ERROR MESSAGE : ... NOT ALLOWED WITH STATUS 'C' (COMPLETED)
      *
     C     #1GSTS        IFEQ      'C'                                          B*1
     C     #1SEL         IFEQ      'G'                                          B*2
     C     #1SEL         OREQ      'A'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00024'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'CO STATUS' IS 'REVERSED' AND ACTION IS NOT 'E'
      **    ERROR MESSAGE : ONLY 'F' AND 'P'
      **                    ALLOWED WHEN STATUS 'R' (REVERSED)
      *
     C     #1GSTS        IFEQ      'R'                                          B*1
     C     #1SEL         ANDNE     'F'
     C     #1SEL         ANDNE     'P'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00025'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*1
      *                                                                   138962
      ***  If 'Action' is 'Delete' ('D'), test if it's possible to        138962
      ***  Delete.                                                        138962
      *                                                                   138962
     C     #1SEL         IFEQ      'D'                                                         13896
      *                                                                   138962
      *****If*Processing*Type*=*Dividend*Events*or*Rights*Issues.* 138962 148743
      ***  If Processing Type = Dividend Events, Rights Issues or Offers. 148743
      *                                                                   138962
     C     #1PTYP        IFEQ      'DV'                                                        13896
     C     #1PTYP        OREQ      'RG'                                                        13896
     C     #1PTYP        OREQ      'FR'                                                        14874
      *                                                                   138962
      ***  If there is a linked Exercises and Conversions Corporate.      138962
      *                                                                   138962
     C     #1REFN        CHAIN     SECOEXL2                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C     MJCORF        CHAIN     SECORFL9                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C     MASTAT        IFEQ      'R'                                                         13896
      *                                                                   138962
      ***  If the linked 'EX' Corporate is Reversed, Delete not allowed,  138962
      ***  only Reverse allowed.                                          138962
      *                                                                   138962
     C                   MOVEL     'CO00599'     ZAMSID                         Message id.    13896
     C                   ELSE                                                                  13896
      *                                                                   138962
      ***  If the linked 'EX' Corporate is not Reversed, Delete not       138962
      ***  allowed.                                                       138962
      *                                                                   138962
     C                   MOVEL     'CO00597'     ZAMSID                         Message id.    13896
     C                   ENDIF                                                                 13896
     C                   MOVE      'Y'           ERMSG                                         13896
     C                   MOVE      '1'           *IN62                          Reverse image  13896
     C                   MOVEL(P)  MJCORF        ZAMSDA                                        13896
     C                   EXSR      ZASNMS                                       Send message   13896
     C                   GOTO      TAG2                                                        13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
      *                                                                   138962
     C                   ENDIF                                                                 13896
      *
      **   IF 'ACTION' IS 'REVERSE' ('R'), TEST IF IT'S POSSIBLE TO REVERSE
      *
     C     #1SEL         IFEQ      'R'                                          B*1
      *
      **   ACCESS SECURITY DETAILS TO RETRIEVE SECURITY MATURITY DATE
      *
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      **   IF 'EX-DATE' IS NOT GREATER THAN CALCULATED 'BACK VALUE DATE'
      **   OR IF 'RUN DATE' IS NOT LOWER THAN SECURITY 'MATURITY DATE'
      *
     C     KEXDT         IFLE      WBACKD                                       B*2
     C     KEXDT         ANDNE     *ZEROS                                                      13787
     C     BJRDNB        ORGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00028'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*2
      *
     C     BJRDNB        SUB       MATDDT        RTNWRF            5 0
      *
     C     RTNWRF        IFGE      RTNPOS                                       B*2
     C     RTNWRF        ORGE      RTNTRD
     C     MASTAT        IFNE      'I'                                          B*3            13787
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00556'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF                                                  E*3            13787
     C                   ENDIF                                                  E*2
      *                                                                   138962
      *****If*Processing*Type*=*Dividend*Events*or*Rights*Issues.* 138962 148743
      ***  If Processing Type = Dividend Events, Rights Issues or Offers. 148743
      *                                                                   138962
     C     #1PTYP        IFEQ      'DV'                                                        13896
     C     #1PTYP        OREQ      'RG'                                                        13896
     C     #1PTYP        OREQ      'FR'                                                        14874
      *                                                                   138962
      ***  If there is a linked Exercises and Conversions Corporate and   138962
      ***  this linked Corporate not Reversed, Reverse not allowed.       138962
      *                                                                   138962
     C     #1REFN        CHAIN     SECOEXL2                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C     MJCORF        CHAIN     SECORFL9                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C     MASTAT        ANDNE     'R'                                                         13896
     C                   MOVE      'Y'           ERMSG                                         13896
     C                   MOVE      '1'           *IN62                          Reverse image  13896
     C                   MOVEL     'CO00598'     ZAMSID                         Message id.    13896
     C                   MOVEL(P)  MJCORF        ZAMSDA                                        13896
     C                   EXSR      ZASNMS                                       Send message   13896
     C                   GOTO      TAG2                                                        13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
      *                                                                   138962
     C                   ENDIF                                                  E*1
      *                                                                                       CSE020
      ** Parent Reference can only be reversed or deleted if all of its                       CSE020
      ** subordinate actions are already deleted                                              CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C                   MOVE      'Y'           WDELAL            1                          CSE020
     C     #1SEL         IFEQ      'R'                                                        CSE020
     C     #1SEL         OREQ      'D'                                                        CSE020
     C     #1REFN        SETLL     SECORFLA                                                   CSE020
     C     #1REFN        READE     SECORFLA                               89                  CSE020
      *                                                                                       CSE020
     C     *IN89         DOWEQ     *OFF                                                       CSE020
     C     WDELAL        ANDEQ     'Y'                                                        CSE020
     C     MASTAT        IFNE      'R'                                                        CSE020
     C                   MOVE      'N'           WDELAL                                       CSE020
     C                   ENDIF                                                                CSE020
     C     #1REFN        READE     SECORFLA                               89                  CSE020
     C                   ENDDO                                                                CSE020
      *                                                                                       CSE020
     C     WDELAL        IFEQ      'N'                                                        CSE020
     C                   MOVE      'Y'           ERMSG                                        CSE020
     C                   MOVE      '1'           *IN62                                        CSE020
     C                   MOVEL     'CO00369'     ZAMSID                                       CSE020
     C                   EXSR      ZASNMS                                                     CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *
      **   IF 'ACTION' IS 'REPLY' AND IF PROCESSING TYPE 'NC'
      **   OR 'CC'                                                        CEU017
      *
     C     #1SEL         IFEQ      'Y'                                          B*1
     C     #1PTYP        ANDEQ     'NC'
     C     #1SEL         OREQ      'Y'                                                         CEU01
     C     #1PTYP        ANDEQ     'CC'                                                        CEU01
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00110'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*1
      *
     C     #1SEL         IFEQ      'F'                                          B*1
     C     #1SEL         OREQ      'V'
     C     #1SEL         OREQ      'E'
     C                   MOVE      'E'           WLACTN
     C                   ELSE                                                   X*1
     C     #1SEL         IFEQ      'N'                                          B*2            13788
     C                   MOVE      'X'           WLACTN                                        13788
     C                   ELSE                                                   X*2            13788
     C                   MOVE      #1SEL         WLACTN
     C                   ENDIF                                                  E*2            13788
     C                   ENDIF                                                  E*1
      *
     C     #1SEL         IFEQ      'E'                                          B*1
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'V'
     C     #1SEL         OREQ      'N'
     C                   EXSR      P025
     C                   ENDIF                                                  E*1
      *
      **  Check if user is authorised to the action code
      *
      **  If single branch environment
      *
     C     AGMBIN        IFNE      'Y'
     C                   CALL      'ZVACTU'
     C                   PARM                    WLACTN            1
     C                   PARM                    WLERR             1 0
      *
     C     WLERR         IFNE      *ZERO
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      *
      **  If multibranching environment
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    WLACTN            1
     C                   PARM      BVBRCD        WLBRCH            3
     C                   PARM                    WLERR             1 0
      *
     C     WLERR         IFEQ      1
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00035'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WLERR         IFEQ      2
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00036'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     TAG2          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P009   : PROCESS 'ACTION'                                     *
      *****************************************************************
      *
     C     P009          BEGSR
     C/COPY WNCPYSRC,SE7502C064
      *
      **   IF ACTION IS 'AMEND' CALL 'DEPOTS MAINTENANCE' PROGRAM
      **   OR IF ACTION IS 'ENQUIRY' CALL 'DEPOTS ENQUIRY' PROGRAM
      *
     C     #1SEL         IFEQ      'A'                                          B*1
     C     #1SEL         OREQ      'E'
      *
     C                   MOVE      *BLANKS       WRTCD
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WEXDAT
      *
     C                   MOVE      *BLANKS       WNBOP
     C                   MOVE      #1NBOP        WNBOP             2
      *
     C                   CALL      'SE7512'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1PTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    WNBOP                          Number of Options
     C                   PARM                    #1SEL                          Amend or Enquiry ?
     C                   PARM      *BLANKS       WWGSTS            1            General Status
     C                   PARM                    WRTCD             1            Return Code
      *
     C     #1SEL         IFEQ      'A'                                          B*2
     C                   MOVE      WWGSTS        #1GSTS
      *                                                                   137879
      **  RETRIEVE THE "HIGHER" STATUS AND FINAL ALLOCATION INDICATOR     137879
      *                                                                   137879
     C                   MOVE      *BLANKS       #1STAT                                        13787
     C                   MOVE      *BLANKS       #1FINA                                        13787
     C                   MOVE      'Y'           WFIRST            1                           13787
      *                                                                   137879
     C     #1REFN        SETLL     SECODRL1                                                    13787
     C     #1REFN        READE     SECODRL1                               89                   13787
      *                                                                   137879
     C     *IN89         IFEQ      '1'                                          B*3            13787
     C                   MOVE      MASTAT        #1STAT                                        13787
     C                   ENDIF                                                  E*3            13787
      *                                                                   137879
     C     *IN89         DOWEQ     '0'                                          B*3            13787
      *                                                                   137879
     C     MSRECI        IFEQ      'D'                                          B*4            13787
      *                                                                   137879
     C     WFIRST        IFEQ      'Y'                                          B*5            13787
     C                   MOVE      MSFAID        #1FINA                                        13787
     C                   MOVE      MSCOST        #1STAT                                        13787
     C                   MOVE      'N'           WFIRST                                        13787
     C                   ELSE                                                   X*5            13787
      *                                                                   137879
      **  RETRIEVE THE "HIGHER" FINAL ALLOCATION INDICATOR                137879
      *                                                                   137879
     C     MSFAID        IFEQ      'Y'                                          B*6            13787
     C                   MOVE      MSFAID        #1FINA                                        13787
     C                   ELSE                                                   X*6            13787
     C     MSFAID        IFEQ      'S'                                          B*7            13787
     C     #1FINA        ANDEQ     'N'                                                         13787
     C                   MOVE      MSFAID        #1FINA                                        13787
     C                   ENDIF                                                  E*7            13787
     C                   ENDIF                                                  E*6            13787
      *                                                                   137879
      **  RETRIEVE THE "HIGHER" STATUS                                    137879
      *                                                                   137879
     C     MSCOST        IFEQ      'C'                                          B*6            13787
     C                   MOVE      MSCOST        #1STAT                                        13787
     C                   ELSE                                                   X*6            13787
     C     MSCOST        IFEQ      'X'                                          B*7            13787
     C     #1STAT        IFEQ      'S'                                          B*8            13787
     C     #1STAT        OREQ      'L'                                                         13787
     C     #1STAT        OREQ      'I'                                                         13787
     C                   MOVE      MSCOST        #1STAT                                        13787
     C                   ENDIF                                                  E*8            13787
     C                   ENDIF                                                  E*7            13787
      *                                                                   137879
     C     MSCOST        IFEQ      'S'                                          B*7            13787
     C     #1STAT        IFEQ      'L'                                          B*8            13787
     C     #1STAT        OREQ      'I'                                                         13787
     C                   MOVE      MSCOST        #1STAT                                        13787
     C                   ENDIF                                                  E*8            13787
     C                   ENDIF                                                  E*7            13787
      *                                                                   137879
     C     MSCOST        IFEQ      'L'                                          B*7            13787
     C     #1STAT        ANDEQ     'I'                                                         13787
     C                   MOVE      MSCOST        #1STAT                                        13787
     C                   ENDIF                                                  E*7            13787
     C                   ENDIF                                                  E*6            13787
     C                   ENDIF                                                  E*5            13787
     C                   ENDIF                                                  E*4            13787
      *                                                                   137879
     C     #1REFN        READE     SECODRL1                               89                   13787
     C                   ENDDO                                                  E*3            13787
      *                                                                   137879
     C     #1FINA        IFEQ      *BLANKS                                      B*3            13787
     C     #1STAT        ANDEQ     *BLANKS                                                     13787
     C                   MOVE      'N'           #1FINA                                        13787
     C                   MOVE      'I'           #1STAT                                        13787
     C                   ENDIF                                                  E*3            13787
     C                   ENDIF                                                  E*2
      *
      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
      **         DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C     WRTCD         OREQ      'E'
     C                   MOVEL     '006'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 06 **
     C                   MOVEL     NARR(5)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E*2
      *
     C     WRTCD         IFNE      'M'                                          B*2
     C                   MOVE      *BLANKS       #1SEL
     C                   ENDIF                                                  E*2
      *
      **   IF RETURN CODE IS EQUAL TO '2', '3' OR 'M'
      *
     C     WRTCD         IFEQ      '2'                                          B*2
     C     WRTCD         OREQ      '3'
     C     WRTCD         OREQ      'M'
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
     C/COPY WNCPYSRC,SE7502C004
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C     WRTCD         IFEQ      '3'                                          B*3
     C                   MOVE      '1'           *INKC
     C                   ENDIF                                                  E*3
      *
     C     WRTCD         IFEQ      'M'                                          B*3
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00031'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
     C                   GOTO      TAG3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS PRINT
      *
     C     #1SEL         IFEQ      'P'                                          B*1
      *
     C                   MOVE      *BLANKS       #1SEL
      *
     C                   MOVE      *BLANKS       @PARM           100
     C                   MOVEL     'SE7533'      @RNAM
     C                   MOVEL     'SEC7533B'    @COTT
      *
     C                   CALL      'FC0040X'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    @RNAM            10
     C                   PARM                    @COTT            10
     C                   PARM      '10004'       @CSEQ             5
     C                   PARM      #1REFN        @PARM           100
     C                   PARM      AGMBIN        @MBRC             1
     C                   PARM      'S'           @LVL              1
     C                   PARM      *BLANKS       @ETTY             3
      *
      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
      **         DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '008'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 08 **
     C                   MOVEL     NARR(8)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E*2
      *
      **   IF RETURN CODE IS EQUAL TO BLANK
      *
     C     @RTCD         IFEQ      ' '                                          B*2
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
     C                   MOVEL     'CO00294'     ZAMSID
     C                   EXSR      ZASNMS
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS REVERSE, DELETE OR AUTHORISATION (PROCESSING TYPE 'NC'
      *
     C     #1SEL         IFEQ      'R'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'N'
      *
      **   PRODUCE CONFIRMATION SCREEN
      *
     C                   EXSR      P010
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      **   IF CONFIRMATION INDICATOR RETURNED IS NOT EQUAL TO 'Y'
      *
     C     #1CONF        IFNE      'Y'                                          B*2
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
     C                   COMMIT
      *
     C                   MOVE      *BLANKS       #1SEL
      *
      **   TERMINATE CURRENT PROCESSING
      *
     C                   GOTO      TAG3
      *
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS REVERSE
      *
     C     #1SEL         IFEQ      'R'                                          B*1
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'R'           MACHTP
     C                   MOVE      ##USR         MALUID
      *
      **   IF EX-DATE CHANGED
      *
     C     #1EXDT        IFNE      #2EXDT                                       B*2
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACOEX
      *
     C                   MOVE      #1EXDT        #2EXDT
     C                   ENDIF                                                  E*2
      *
      **   IF DATE OF ANNOUNCEMENT CHANGED
      *
     C     #1COAN        IFNE      #2COAN                                       B*2
     C                   MOVE      #1COAN        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACOAN
      *
     C                   MOVE      #1COAN        #2COAN
     C                   ENDIF                                                  E*2
      *
      **   IF ALLOCATION EFFECTIVE DATE CHANGED
      *
     C     #1ALEF        IFNE      #2ALEF                                       B*2
     C                   MOVE      #1ALEF        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MAALEF
      *
     C                   MOVE      #1ALEF        #2ALEF
     C                   ENDIF                                                  E*2
      *
     C     #1REFN        SETLL     SECOALL0
     C     #1REFN        READE     SECOALL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MCCORF
      *
     C     MCRECI        IFEQ      '*'                                          B*3
     C                   DELETE    SECOALD0
     C                   ELSE                                                   X*3
     C                   MOVE      '*'           MCRECI
     C                   Z-ADD     BJRDNB        MCLCD
     C                   MOVE      'R'           MCCHTP
     C                   MOVE      ##USR         MCLUID
     C                   UPDATE    SECOALD0
     C                   ENDIF                                                  E*3
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECOALL0                               89
     C                   ENDDO                                                  E*2
      *
     C     #1REFN        SETLL     SECODPL0
     C     #1REFN        READE     SECODPL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MBCORF
      *
     C     MBRECI        IFEQ      '*'                                          B*3
     C                   DELETE    SECODPD0
     C                   ELSE                                                   X*3
     C                   MOVE      '*'           MBRECI
     C                   Z-ADD     BJRDNB        MBLCD
     C                   MOVE      'R'           MBCHTP
     C                   MOVE      ##USR         MBLUID
     C                   UPDATE    SECODPD0
     C                   ENDIF                                                  E*3
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECODPL0                               89
     C                   ENDDO                                                  E*2
      *
     C     #1REFN        SETLL     SECODRL0
     C     #1REFN        READE     SECODRL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MSCORF
      *
     C                   Z-ADD     BJRDNB        MSLCD
     C                   MOVE      'R'           MSCHTP
     C                   MOVE      ##USR         MSLUID
     C                   MOVE      'R'           MSCOST
     C                   UPDATE    SECODRD0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECODRL0                               89
     C                   ENDDO                                                  E*2
      *                                                                   138962
      ***  Reverse records on Blocking File.                              138962
      *                                                                   138962
     C     #1REFN        SETLL     SECOBKL1                                                    13896
     C     #1REFN        READE     SECOBKL1                               89                   13896
      *                                                                   138962
      ***  Do while end of file not reached.                              138962
      *                                                                   138962
     C     *IN89         DOWEQ     '0'                                          B*2            13896
      *                                                                   138962
     C     MURECI        IFEQ      '*'                                          B*3            13896
     C                   DELETE    SECOBKD0                                                    13896
     C                   ELSE                                                   X*3            13896
     C                   Z-ADD     BJRDNB        MULCD                                         13896
     C                   MOVE      'R'           MUCHTP                                        13896
     C                   MOVE      ##USR         MULUID                                        13896
     C                   MOVE      '*'           MURECI                                        13896
     C                   UPDATE    SECOBKD0                                                    13896
     C                   ENDIF                                                  E*3            13896
      *                                                                   138962
      ***  Access next record.                                            138962
      *                                                                   138962
     C     #1REFN        READE     SECOBKL1                               89                   13896
     C                   ENDDO                                                  E*2            13896
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      'R'           MASTAT
      *
     C                   UPDATE    SECORFD0
     C                   MOVE(P)   FIELD         WWFLD           175                           13896
      *                                                                   138962
      *****If*Exercises*and*Conversions*and*'DV'*or*'RG'*linked*** 138962 148743
      *****Corporate Action*exists.******************************* 138962 148743
      ***  If Exercises and Conversions and 'DV', 'RG' or 'OF' linked     148743
      ***  Corporate Action exists.                                       148743
      *                                                                   138962
     C     #1PTYP        IFEQ      'EX'                                                        13896
     C     WWLNKR        ANDNE     *BLANKS                                                     13896
     C     WWLNKR        CHAIN     SECORFL9                           89                       13896
      *                                                                   138962
      *****If*Status*of*the*'DV'*or*'RG'*linked*Corporate*Action** 138962 148743
      *****neither*Stock*Autorised,*nor*Fully*Authorised,*nor***** 138962 148743
      *****Complete,*set*'Rights'*fields*to*blank*or*zero*(and**** 138962 148743
      *****'Subscription*Rights*Tradable'*field*if*'DV'*to*'N').** 138962 148743
      ***  If Status of the 'DV', 'RG' or 'FR' linked Corporate Action    148743
      ***  neither Stock Autorised, nor Fully Authorised, nor Complete,   148743
      ***  set 'Rights' fields to blank or zero (and 'Subscription Rights 148743
      ***  Tradable' field if 'DV' to 'N').                               148743
      *                                                                   138962
     C     *IN89         IFEQ      '0'                                                         13896
     C     MASTAT        IFNE      'S'                                                         13896
     C     MASTAT        ANDNE     'X'                                                         13896
     C     MASTAT        ANDNE     'C'                                                         13896
     C     WWPTYP        IFEQ      'DV'                                                        13896
     C     WWLNKR        CHAIN     SECODVL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      'N'           MDSBRT                                        13896
     C                   MOVE      *BLANKS       MDSBRS                                        13896
     C                   Z-ADD     0             MDREPR                                        13896
     C                   Z-ADD     0             MDREXD                                        13896
     C                   Z-ADD     0             MDREXA                                        13896
     C                   MOVE      *BLANKS       MDREAT                                        13896
     C                   Z-ADD     0             MDRNNS                                        13896
     C                   Z-ADD     0             MDRNRI                                        13896
     C                   Z-ADD     0             MDRMLT                                        13896
     C                   Z-ADD     0             MDRDIV                                        13896
     C                   Z-ADD     0             MDRTRF                                        13896
     C                   Z-ADD     0             MDRTRT                                        13896
     C                   Z-ADD     BJRDNB        MDLCD                                         13896
     C                   MOVE      'A'           MDCHTP                                        13896
     C                   MOVE      ##USR         MDLUID                                        13896
     C                   UPDATE    SECODVD0                                                    13896
     C                   ENDIF                                                                 13896
     C                   ELSE                                                                  13896
     C     WWPTYP        IFEQ      'RG'                                                        14874
     C     WWLNKR        CHAIN     SECORGL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      *BLANKS       MFSBRS                                        13896
     C                   Z-ADD     0             MFSBRP                                        13896
     C                   Z-ADD     0             MFREXD                                        13896
     C                   Z-ADD     0             MFREXA                                        13896
     C                   MOVE      *BLANKS       MFREAT                                        13896
     C                   Z-ADD     0             MFRNNS                                        13896
     C                   Z-ADD     0             MFRNRI                                        13896
     C                   Z-ADD     0             MFRMLT                                        13896
     C                   Z-ADD     0             MFRDIV                                        13896
     C                   Z-ADD     0             MFRTRF                                        13896
     C                   Z-ADD     0             MFRTRT                                        13896
     C                   MOVE      *BLANKS       MFAVOP                                        13896
     C                   Z-ADD     BJRDNB        MFLCD                                         13896
     C                   MOVE      'A'           MFCHTP                                        13896
     C                   MOVE      ##USR         MFLUID                                        13896
     C                   UPDATE    SECORGD0                                                    13896
     C                   ENDIF                                                                 13896
     C                   ELSE                                                                  14874
     C     WWLNKR        CHAIN     SECOFRL0                           89                       14874
     C     *IN89         IFEQ      '0'                                                         14874
     C                   MOVE      'N'           MESBRT                                        14874
     C                   MOVE      *BLANKS       MESBRS                                        14874
     C                   Z-ADD     0             MEREPR                                        14874
     C                   Z-ADD     0             MEREXD                                        14874
     C                   Z-ADD     0             MEREXA                                        14874
     C                   MOVE      *BLANKS       MEREAT                                        14874
     C                   Z-ADD     0             MERNNS                                        14874
     C                   Z-ADD     0             MERNRI                                        14874
     C                   Z-ADD     0             MERMLT                                        14874
     C                   Z-ADD     0             MERDIV                                        14874
     C                   Z-ADD     0             MERTRF                                        14874
     C                   Z-ADD     0             MERTRT                                        14874
     C                   Z-ADD     BJRDNB        MELCD                                         14874
     C                   MOVE      'A'           MECHTP                                        14874
     C                   MOVE      ##USR         MELUID                                        14874
     C                   UPDATE    SECOFRD0                                                    14874
     C                   ENDIF                                                                 14874
     C                   ENDIF                                                                 14874
     C                   ENDIF                                                                 13896
      *                                                                   138962
     C     #1REFN        CHAIN     SECOEXL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      *BLANKS       MJLNKR                                        13896
     C                   Z-ADD     BJRDNB        MJLCD                                         13896
     C                   MOVE      'A'           MJCHTP                                        13896
     C                   MOVE      ##USR         MJLUID                                        13896
     C                   UPDATE    SECOEXD0                                                    13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   MOVE      WWFLD         FIELD                                         13896
     C                   ENDIF                                                                 13896
      *
     C     #1PTYP        IFEQ      'CC'                                         B*2            CEU01
     C     #1REFN        CHAIN     SECOCCL0                           89                       CEU01
      *                                                                   CEU017
     C     *IN89         IFEQ      '0'                                                         CEU01
     C                   MOVE      '*'           NARECI                                        CEU01
     C                   Z-ADD     BJRDNB        NALCD                                         CEU01
     C                   MOVE      'R'           NACHTP                                        CEU01
     C                   MOVE      ##USR         NALUID                                        CEU01
     C                   UPDATE    SECOCCD0                                                    CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU017
     C     NABLKR        IFNE      *ZEROS                                       B*3            CEU01
     C     *IN89         ANDEQ     '0'                                                         CEU01
     C                   Z-ADD     *ZEROS        WCOUNT                                        13787
     C                   MOVE      #1REFN        W1REFN                                        13787
     C     NABLKR        CHAIN     SECORBL0                           89                       CEU01
      *                                                                   CEU017
      **  Reverse all matching records in LF/SECORSL0                     CEU017
     C     NBBLKR        SETLL     SECORSL0                                                    CEU01
     C     NBBLKR        READE     SECORSL0                               89                   CEU01
      *                                                                   CEU017
     C     *IN89         DOWEQ     '0'                                          B*4            CEU01
     C     NCRECI        IFEQ      'D'                                          B*5            13787
     C                   ADD       1             WCOUNT                                        13787
     C                   ENDIF                                                  E*5            13787
     C     W1REFN        IFEQ      NCCORF                                       B*5            13787
     C                   MOVE      '*'           NCRECI                                        CEU01
     C                   Z-ADD     BJRDNB        NCLCD                                         CEU01
     C                   MOVE      'R'           NCCHTP                                        CEU01
     C                   MOVE      ##USR         NCLUID                                        CEU01
     C                   UPDATE    SECORSD0                                                    CEU01
     C                   SUB       1             WCOUNT                                        13787
     C                   ENDIF                                                  E*5            13787
     C     NBBLKR        READE     SECORSL0                               89                   CEU01
     C                   ENDDO                                                  E*4            CEU01
      *                                                                   CEU017
      **  Reverse matching record in LF/SECORBL0                          CEU017
     C     WCOUNT        IFEQ      *ZEROS                                       B*4            13787
     C                   MOVE      'R'           NBSTAT                                        CEU01
     C                   Z-ADD     BJRDNB        NBLCD                                         CEU01
     C                   MOVE      'R'           NBCHTP                                        CEU01
     C                   MOVE      ##USR         NBLUID                                        CEU01
     C                   UPDATE    SECORBD0                                                    CEU01
     C                   ENDIF                                                  E*4            13787
     C                   ENDIF                                                  E*3            CEU01
      *                                                                   CEU017
     C                   ENDIF                                                  E*2            CEU01
      *
      **   UPDATE SUBFILE FIELDS
      *
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      'R'           #1STAT
     C                   MOVE      'R'           #1GSTS
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS 'GENERAL INFORMATION', 'F' - ENQUIRY OR 'G' - MAINTENA
      *
     C     #1SEL         IFEQ      'F'                                          B*1
     C     #1SEL         OREQ      'G'
      *                                                                   CEU017
     C                   MOVE      '0'           *IN35                                         CEU01
     C     #1PTYP        IFEQ      'CC'                                         B*1            CEU01
     C                   MOVE      '1'           *IN35                                         CEU01
     C                   ENDIF                                                  E*1            CEU01
      *
     C                   MOVE      *IN61         WIN61             1
     C     #1SEL         IFEQ      'F'                                          B*2
     C                   MOVE      '1'           *IN61
     C                   ENDIF                                                  E*2
     C/COPY WNCPYSRC,SEH00007
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EVAL      *IN07 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN13
     C                   MOVE      '0'           *IN14
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN42
     C                   MOVE      '0'           *IN49
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C                   MOVE      '0'           *IN67
     C                   MOVE      '0'           *IN70
     C                   MOVE      '0'           *IN71
     C                   MOVE      '0'           *IN72
     C                   MOVE      '0'           *IN73
     C                   MOVE      '0'           *IN74
     C                   MOVE      '0'           *IN76
     C                   MOVE      '0'           *IN77
     C                   MOVE      '0'           *IN78
     C                   MOVE      '0'           *IN79
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   MOVE      '0'           *IN85
      *
      **   PROCESS 'FULL DETAILS' SCREEN
      *
     C                   EXSR      P018
      *
      **   IF F3 OR F12 IS PRESSED OR IF ALL FIELDS PROTECTED
      *
     C     *INKC         IFEQ      '1'                                          B*2
     C     *INKL         OREQ      '1'
     C     *IN61         OREQ      '1'
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      **   UPDATE SUBFILE FIELDS
      *
     C                   MOVE      FIELD         #FIELD
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
     C                   ENDIF                                                  E*2
      *
     C                   MOVE      *BLANKS       #1SEL
      *
     C                   MOVE      WIN61         *IN61
      *
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS DELETE
      *
     C     #1SEL         IFEQ      'D'                                          B*1
      *
      **   DELETE RECORDS IN DEPOT FILES
      *
     C     #1REFN        SETLL     SECODPL0
     C     #1REFN        READE     SECODPL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MBCORF
      *
     C                   DELETE    SECODPD0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECODPL0                               89
     C                   ENDDO                                                  E*2
      *
      **   DELETE RECORDS IN DEPOT FILES
      *
     C     #1REFN        SETLL     SECODRL0
     C     #1REFN        READE     SECODRL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MSCORF
      *
     C                   DELETE    SECODRD0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECODRL0                               89
     C                   ENDDO                                                  E*2
      *
      **   DELETE RECORDS IN ALLOCATION FILES
      *
     C     #1REFN        SETLL     SECOALL0
     C     #1REFN        READE     SECOALL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MCCORF
      *
     C                   DELETE    SECOALD0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECOALL0                               89
     C                   ENDDO                                                  E*2
      *
      **   DELETE RECORDS IN REPLY HANDLING FILES
      *
     C     #1REFN        SETLL     SECOREL0
     C     #1REFN        READE     SECOREL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MQCORF
      *
     C                   DELETE    SECORED0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECOREL0                               89
     C                   ENDDO                                                  E*2
      *
      **   DELETE RECORDS IN HISTORIC REPLY HANDLING FILES
      *
     C     #1REFN        SETLL     SECORHL0
     C     #1REFN        READE     SECORHL0                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MPCORF
      *
     C                   DELETE    SECORHD0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECORHL0                               89
     C                   ENDDO                                                  E*2
      *
      **   DELETE RECORDS IN BLOCKING FILE
      *
     C     #1REFN        SETLL     SECOBKL1
     C     #1REFN        READE     SECOBKL1                               89
      *
      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
      *
     C     *IN89         DOWEQ     '0'                                          B*2
     C     #1REFN        ANDEQ     MUCORF
      *
     C                   DELETE    SECOBKD0
      *
      **   ACCESS NEXT RECORD
      *
     C     #1REFN        READE     SECOBKL1                               89
     C                   ENDDO                                                  E*2
      *
      **   DELETE ALL THE RELATIVE OPTIONS
      *
     C                   EXSR      P022
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
     C                   DELETE    SECORFD0
      *                                                                   138962
      *****If*Exercises*and*Conversions*and*'DV'*or*'RG'*linked*** 138962 148743
      *****Corporate*Action*exists.******************************* 138962 148743
      ***  If Exercises and Conversions and 'DV', 'RG' or 'FR' linked     148743
      ***  Corporate Action exists.                                       148743
      *                                                                   138962
     C     #1PTYP        IFEQ      'EX'                                                        13896
     C     WWLNKR        ANDNE     *BLANKS                                                     13896
     C     WWLNKR        CHAIN     SECORFL9                           89                       13896
      *                                                                   138962
      *****If*Status*of*the*'DV'*or*'RG'*linked*Corporate*Action** 138962 148743
      *****neither*Stock*Autorised,*nor*Fully*Authorised,*nor***** 138962 148743
      *****Complete,*set*'Rights'*fields*to*blank*or*zero*(and**** 138962 148743
      *****'Subscription*Rights*Tradable'*field*if*'DV'*to*'N').** 138962 148743
      ***  If Status of the 'DV', 'RG' or 'FR' linked Corporate Action    148743
      ***  neither Stock Autorised, nor Fully Authorised, nor Complete,   148743
      ***  set 'Rights' fields to blank or zero (and 'Subscription Rights 148743
      ***  Tradable' field if 'DV' to 'N').                               148743
      *                                                                   138962
     C     *IN89         IFEQ      '0'                                                         13896
     C     MASTAT        IFNE      'S'                                                         13896
     C     MASTAT        ANDNE     'X'                                                         13896
     C     MASTAT        ANDNE     'C'                                                         13896
     C     WWPTYP        IFEQ      'DV'                                                        13896
     C     WWLNKR        CHAIN     SECODVL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      'N'           MDSBRT                                        13896
     C                   MOVE      *BLANKS       MDSBRS                                        13896
     C                   Z-ADD     0             MDREPR                                        13896
     C                   Z-ADD     0             MDREXD                                        13896
     C                   Z-ADD     0             MDREXA                                        13896
     C                   MOVE      *BLANKS       MDREAT                                        13896
     C                   Z-ADD     0             MDRNNS                                        13896
     C                   Z-ADD     0             MDRNRI                                        13896
     C                   Z-ADD     0             MDRMLT                                        13896
     C                   Z-ADD     0             MDRDIV                                        13896
     C                   Z-ADD     0             MDRTRF                                        13896
     C                   Z-ADD     0             MDRTRT                                        13896
     C                   Z-ADD     BJRDNB        MDLCD                                         13896
     C                   MOVE      'A'           MDCHTP                                        13896
     C                   MOVE      ##USR         MDLUID                                        13896
     C                   UPDATE    SECODVD0                                                    13896
     C                   ENDIF                                                                 13896
     C                   ELSE                                                                  13896
     C     WWPTYP        IFEQ      'RG'                                                        14874
     C     WWLNKR        CHAIN     SECORGL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      *BLANKS       MFSBRS                                        13896
     C                   Z-ADD     0             MFSBRP                                        13896
     C                   Z-ADD     0             MFREXD                                        13896
     C                   Z-ADD     0             MFREXA                                        13896
     C                   MOVE      *BLANKS       MFREAT                                        13896
     C                   Z-ADD     0             MFRNNS                                        13896
     C                   Z-ADD     0             MFRNRI                                        13896
     C                   Z-ADD     0             MFRMLT                                        13896
     C                   Z-ADD     0             MFRDIV                                        13896
     C                   Z-ADD     0             MFRTRF                                        13896
     C                   Z-ADD     0             MFRTRT                                        13896
     C                   MOVE      *BLANKS       MFAVOP                                        13896
     C                   Z-ADD     BJRDNB        MFLCD                                         13896
     C                   MOVE      'A'           MFCHTP                                        13896
     C                   MOVE      ##USR         MFLUID                                        13896
     C                   UPDATE    SECORGD0                                                    13896
     C                   ENDIF                                                                 13896
     C                   ELSE                                                                  14874
     C     WWLNKR        CHAIN     SECOFRL0                           89                       14874
     C     *IN89         IFEQ      '0'                                                         14874
     C                   MOVE      'N'           MESBRT                                        14874
     C                   MOVE      *BLANKS       MESBRS                                        14874
     C                   Z-ADD     0             MEREPR                                        14874
     C                   Z-ADD     0             MEREXD                                        14874
     C                   Z-ADD     0             MEREXA                                        14874
     C                   MOVE      *BLANKS       MEREAT                                        14874
     C                   Z-ADD     0             MERNNS                                        14874
     C                   Z-ADD     0             MERNRI                                        14874
     C                   Z-ADD     0             MERMLT                                        14874
     C                   Z-ADD     0             MERDIV                                        14874
     C                   Z-ADD     0             MERTRF                                        14874
     C                   Z-ADD     0             MERTRT                                        14874
     C                   Z-ADD     BJRDNB        MELCD                                         14874
     C                   MOVE      'A'           MECHTP                                        14874
     C                   MOVE      ##USR         MELUID                                        14874
     C                   UPDATE    SECOFRD0                                                    14874
     C                   ENDIF                                                                 14874
     C                   ENDIF                                                                 14874
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C/COPY WNCPYSRC,SE7502C005
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C                   MOVE      *BLANKS       #1SEL
     C***********        MOVE      '0'           *IN45                                        CSE020
     C                   MOVE      '0'           WIN45                                        CSE020
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS AUTHORISATION (PROCESSING TYPE 'NC')
      *
     C     #1SEL         IFEQ      'N'                                          B*1
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
     C                   MOVE      'X'           MASTAT
     C                   UPDATE    SECORFD0
      *
      **   UPDATE SUBFILE FIELDS
      *
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      'X'           #1GSTS
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS CUSTOMER REPLY HANDLE
      *
     C     #1SEL         IFEQ      'Y'                                          B*1
      *
     C                   MOVE      *BLANKS       WRTCD
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WEXDAT
      *
     C                   CALL      'SE7514'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1PTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    NMCY              3            Nominal Currency
     C                   PARM                    WRTCD             1            Return Code
      *
      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
      **         DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C     WRTCD         OREQ      'E'
     C                   MOVEL     '006'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 06 **
     C                   MOVEL     NARR(6)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E*2
      *
     C     WRTCD         IFNE      'M'                                          B*2
     C                   MOVE      *BLANKS       #1SEL
     C                   ENDIF                                                  E*2
      *
      **   IF RETURN CODE IS EQUAL TO '2', '3' OR 'M'
      *
     C     WRTCD         IFEQ      '2'                                          B*2
     C     WRTCD         OREQ      '3'
     C     WRTCD         OREQ      'M'
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      **   UPDATE SUBFILE FIELDS
      *
     C                   MOVE      FIELD         #FIELD
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C     WRTCD         IFEQ      '3'                                          B*3
     C                   MOVE      '1'           *INKC
     C                   ENDIF                                                  E*3
      *
     C                   ENDIF                                                  E*2
      *
     C                   MOVE      *BLANKS       #1SEL
      *
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS VIEW CUSTOMER ALLOCATIONS
      *
     C     #1SEL         IFEQ      'V'                                          B*1
      *
     C                   MOVE      *BLANKS       WRTCD
     C     *LOCK         IN        LDA
     C                   MOVEL     'SE7502'      PGMNAM
     C                   OUT       LDA
      *
     C                   CALL      'SE7540'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM      *BLANKS       WWOPTN            2            Option number
     C                   PARM      *BLANKS       WWBRCD            3            Branch Code
     C                   PARM      *BLANKS       WWBOOK            2            Book
     C                   PARM      *BLANKS       WWCUST            6            Customer
     C                   PARM      *BLANKS       WWPTFR            4            Portfolio
     C                   PARM      *BLANKS       WWCPGM            6            Calling Pgm
     C                   PARM                    WRTCD             1            Return Code
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANKS       PGMNAM
     C                   OUT       LDA
      *
      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
      **         DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C     WRTCD         OREQ      'E'
     C                   MOVEL     '007'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 07 **
     C                   MOVEL     NARR(9)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E*2
      *
     C     WRTCD         IFNE      'M'                                          B*2
     C                   MOVE      *BLANKS       #1SEL
     C                   ENDIF                                                  E*2
      *
      **   IF RETURN CODE IS EQUAL TO '2', '3' OR 'M'
      *
     C     WRTCD         IFEQ      '2'                                          B*2
     C     WRTCD         OREQ      '3'
     C     WRTCD         OREQ      'M'
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      **   UPDATE SUBFILE FIELDS
      *
     C                   MOVE      FIELD         #FIELD
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C     WRTCD         IFEQ      '3'                                          B*3
     C                   MOVE      '1'           *INKC
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
     C                   ENDIF                                                  E*1
      *
      **   IF 'ACTION' IS PRINT CORRESPONDENCE, *** FUTURE USE, PHASE II ***
      *
     C     #1SEL         IFEQ      'C'                                          B*1
      *
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00258'     ZAMSID
     C                   EXSR      ZASNMS
      *
      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      **   UPDATE SUBFILE FIELDS
      *
     C                   MOVE      FIELD         #FIELD
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C                   ENDIF                                                  E*1
      *
     C     TAG3          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P010   : PROCESS 'CONFIRMATION' SCREEN                        *
      *****************************************************************
      *
     C     P010          BEGSR
      *
     C                   MOVE      *BLANKS       #1CONF
      *
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
      *
     C                   MOVE      '0'           *IN44
     C                   MOVE      '1'           *IN47
      *                                                                   138962
      ***  If Delete or Reverse of a Corporate Action type Exercises and  138962
      ***  Conversions, check if there is a linked Corporate Action.      138962
      *                                                                   138962
     C                   MOVE      *BLANKS       REFLIN                                        13896
     C     #1PTYP        IFEQ      'EX'                                                        13896
     C     #1SEL         ANDEQ     'D'                                                         13896
     C     #1PTYP        OREQ      'EX'                                                        13896
     C     #1SEL         ANDEQ     'R'                                                         13896
     C     #1REFN        CHAIN(N)  SECOEXL0                           89                       13896
     C     MJLNKR        IFNE      *BLANKS                                                     13896
     C     MJLNKR        CHAIN(N)  SECODVL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      MJLNKR        WWLNKR                                        13896
     C                   MOVE      'DV'          WWPTYP                                        13896
     C                   ELSE                                                                  13896
     C     MJLNKR        CHAIN(N)  SECORGL0                           89                       13896
     C     *IN89         IFEQ      '0'                                                         13896
     C                   MOVE      MJLNKR        WWLNKR                                        13896
     C                   MOVE      'RG'          WWPTYP                                        13896
     C                   ELSE                                                                  14874
     C     MJLNKR        CHAIN(N)  SECOFRL0                           89                       14874
     C     *IN89         IFEQ      '0'                                                         14874
     C                   MOVE      MJLNKR        WWLNKR                                        14874
     C                   MOVE      'FR'          WWPTYP                                        14874
     C                   ENDIF                                                                 14874
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
     C                   ENDIF                                                                 13896
      *
      **   DEPENDING OF THE 'ACTION', SET THE CORRECT NARRATIVE
      **   *** CONFIRM REVERSAL ***
      *
     C     #1SEL         IFEQ      'R'                                          B*1
     C                   MOVE      '1'           *IN40
     C                   MOVE      '0'           *IN41
     C                   ELSE                                                   X*1
      *
      **   *** CONFIRM DELETION ***
      *
     C     #1SEL         IFEQ      'D'                                          B*2
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   ELSE                                                   X*2
      *
      **   *** CONFIRM AUTHORISATION ***
      *
     C     #1SEL         IFEQ      'N'                                          B*3
     C                   MOVE      '0'           *IN40
     C                   MOVE      '1'           *IN41
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C******     *IN61     IFEQ '1'                        B*1            138962
     C******               MOVEATXT,4     ##CTX1                          138962
     C******               ELSE                            X*1            138962
     C******               MOVEATXT,5     ##CTX1                          138962
     C******               ENDIF                           E*1            138962
     C                   MOVEA     TXT(6)        ##CTX1                                        13896
      *
      **   DO WHILE F3 OR F12 NOT PRESSED AND NO ERROR
      *
     C     *INKC         DOWEQ     '0'                                          B*1
     C     *INKL         ANDEQ     '0'
     C     #1CONF        ANDNE     'Y'
     C     #1CONF        ANDNE     'N'
      *
      **   SETUP SCREEN TIME
      *
     C                   TIME                    ##TME                          Screen time.
      *                                                                   138962
      ***  If Delete or Reverse CO type 'EX' linked with CO type 'DV' or  138962
      ***  'RG' or 'FR', send warning message.                            148743
      *****'RG',*send*warning*message.**************************** 138962 148743
      *                                                                   138962
     C     #1SEL         IFEQ      'D'                                                         13896
     C     WWLNKR        ANDNE     *BLANKS                                                     13896
     C     #1SEL         OREQ      'R'                                                         13896
     C     WWLNKR        ANDNE     *BLANKS                                                     13896
     C                   MOVEL(P)  REFLIN        ZAMSDA                                        13896
     C                   MOVEL     'CO00600'     ZAMSID                         Message id.    13896
     C                   EXSR      ZASNMS                                       Send message   13896
     C                   ENDIF                                                                 13896
      *
      **   EXECUTE SCREEN FORMAT
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     SE7502F1
     C                   EXFMT     SE7502F2
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      **   IF 'CONFIRMATION INDICATOR' IS NOT EQUAL TO 'Y' OR 'N'
      *
     C     #1CONF        IFNE      'N'                                          B*2
     C     #1CONF        ANDNE     'Y'
     C                   MOVE      '1'           *IN44                          Reverse image
     C                   MOVEL     'CO00032'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   MOVE      '0'           *IN44                          Reverse image
     C                   ENDIF                                                  E*2
     C                   ENDDO                                                  E*1
      *
     C                   MOVEA     TXT(3)        ##CTX1
     C                   MOVE      '0'           *IN47
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P011   : WRITE OPTION(S) WITH DEFAULT INFORMATION             *
      *****************************************************************
      *
     C     P011          BEGSR
      *
     C                   MOVEL     NARR(4)       WWOPSH           26
     C                   MOVE      WWOPNB        WWOPSH
      *
     C     MAPTYP        IFEQ      'DV'                                         B*1
     C                   CLEAR                   SECODVD0
     C                   MOVE      'D'           MDRECI
     C                   Z-ADD     BJRDNB        MDLCD
     C                   MOVE      'I'           MDCHTP
     C                   MOVE      ##USR         MDLUID
     C                   MOVE      #1REFN        MDCORF
     C                   Z-ADD     WWOPNB        MDOPTN
     C                   MOVE      #1SECN        MDNSEC
     C                   MOVE      'D'           MDRNDN
     C                   MOVE      'N'           MDRNDS
     C                   MOVE      'N'           MDSBRT
     C                   MOVEL     WWOPSH        MDOPSH
     C                   WRITE     SECODVD0
     C                   ELSE                                                   X*1
     C     MAPTYP        IFEQ      'FR'                                         B*2
     C                   CLEAR                   SECOFRD0
     C                   MOVE      'D'           MERECI
     C                   Z-ADD     BJRDNB        MELCD
     C                   MOVE      'I'           MECHTP
     C                   MOVE      ##USR         MELUID
     C                   MOVE      #1REFN        MECORF
     C                   Z-ADD     WWOPNB        MEOPTN
     C                   MOVE      #1SECN        MENSEC
     C                   MOVE      'D'           MERNDN
     C                   MOVE      'N'           MERNDS
     C                   MOVEL     WWOPSH        MEOPSH
     C                   WRITE     SECOFRD0
     C                   ELSE                                                   X*2
     C     MAPTYP        IFEQ      'CE'                                         B*3
     C                   CLEAR                   SECOCED0
     C                   MOVE      'D'           MGRECI
     C                   Z-ADD     BJRDNB        MGLCD
     C                   MOVE      'I'           MGCHTP
     C                   MOVE      ##USR         MGLUID
     C                   MOVE      #1REFN        MGCORF
     C                   Z-ADD     WWOPNB        MGOPTN
     C                   MOVEL     WWOPSH        MGOPSH
     C                   WRITE     SECOCED0
     C                   ELSE                                                   X*3
     C     MAPTYP        IFEQ      'CR'                                         B*4
     C                   CLEAR                   SECOCRD0
     C                   MOVE      'D'           MHRECI
     C                   Z-ADD     BJRDNB        MHLCD
     C                   MOVE      'I'           MHCHTP
     C                   MOVE      ##USR         MHLUID
     C                   MOVE      #1REFN        MHCORF
     C                   Z-ADD     WWOPNB        MHOPTN
     C                   MOVEL     WWOPSH        MHOPSH
     C                   WRITE     SECOCRD0
     C                   ELSE                                                   X*4
     C     MAPTYP        IFEQ      'OF'                                         B*5
     C                   CLEAR                   SECOOFD0
     C                   MOVE      'D'           MIRECI
     C                   Z-ADD     BJRDNB        MILCD
     C                   MOVE      'I'           MICHTP
     C                   MOVE      ##USR         MILUID
     C                   MOVE      #1REFN        MICORF
     C                   MOVE      'D'           MIRNDN
     C                   MOVE      'N'           MIRNDS
     C                   Z-ADD     WWOPNB        MIOPTN
     C                   MOVEL     WWOPSH        MIOPSH
     C                   WRITE     SECOOFD0
     C                   ELSE                                                   X*5
     C     MAPTYP        IFEQ      'RG'                                         B*6
     C                   CLEAR                   SECORGD0
     C                   MOVE      'D'           MFRECI
     C                   Z-ADD     BJRDNB        MFLCD
     C                   MOVE      'I'           MFCHTP
     C                   MOVE      ##USR         MFLUID
     C                   MOVE      #1REFN        MFCORF
     C                   Z-ADD     WWOPNB        MFOPTN
     C                   MOVE      #1SECN        MFNSEC
     C                   MOVE      'D'           MFRNDN
     C                   MOVE      'N'           MFRNDS
     C                   MOVEL     WWOPSH        MFOPSH
     C                   WRITE     SECORGD0
     C                   ELSE                                                   X*6
     C     MAPTYP        IFEQ      'EX'                                         B*7
     C                   CLEAR                   SECOEXD0
     C                   MOVE      'D'           MJRECI
     C                   Z-ADD     BJRDNB        MJLCD
     C                   MOVE      'I'           MJCHTP
     C                   MOVE      ##USR         MJLUID
     C                   MOVE      #1REFN        MJCORF
     C                   Z-ADD     WWOPNB        MJOPTN
     C                   MOVE      'D'           MJRNDN
     C                   MOVE      'N'           MJRNDS
     C                   MOVE      'N'           MJOPT1
     C                   MOVE      'N'           MJOPT2
     C                   MOVE      'N'           MJOPT3
     C                   MOVE      'N'           MJOPT4
     C                   MOVE      'N'           MJOPT5
     C                   MOVE      'N'           MJOPT6
     C                   MOVE      'N'           MJOPT7
     C                   MOVEL     WWOPSH        MJOPSH
     C                   WRITE     SECOEXD0
     C                   ELSE                                                   X*7
     C     MAPTYP        IFEQ      'NF'                                         B*8
     C                   CLEAR                   SECONFD0
     C                   MOVE      'D'           MKRECI
     C                   Z-ADD     BJRDNB        MKLCD
     C                   MOVE      'I'           MKCHTP
     C                   MOVE      ##USR         MKLUID
     C                   MOVE      #1REFN        MKCORF
     C                   Z-ADD     1             MKSEQN
     C                   WRITE     SECONFD0
     C                   ELSE                                                   X*8
     C     MAPTYP        IFEQ      'NC'                                         B*9
     C                   CLEAR                   SECONCD0
     C                   MOVE      'D'           MLRECI
     C                   Z-ADD     BJRDNB        MLLCD
     C                   MOVE      'I'           MLCHTP
     C                   MOVE      ##USR         MLLUID
     C                   MOVE      #1REFN        MLCORF
     C                   WRITE     SECONCD0
     C                   ELSE                                                   X*9            CEU01
     C     MAPTYP        IFEQ      'CC'                                         B*10           CEU01
     C                   CLEAR                   SECOCCD0                                      CEU01
     C                   MOVE      'D'           NARECI                                        CEU01
     C                   Z-ADD     BJRDNB        NALCD                                         CEU01
     C                   MOVE      'I'           NACHTP                                        CEU01
     C                   MOVE      ##USR         NALUID                                        CEU01
     C                   MOVE      #1REFN        NACORF                                        CEU01
     C                   WRITE     SECOCCD0                                                    CEU01
     C/COPY WNCPYSRC,SE7502C038
     C                   ENDIF                                                  E*10           CEU01
     C                   ENDIF                                                  E*9
     C                   ENDIF                                                  E*8
     C                   ENDIF                                                  E*7
     C                   ENDIF                                                  E*6
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P014   : REINITIALISE INDICATORS                              *
      *****************************************************************
      *
     C     P014          BEGSR
      *
      **   REINITIALISE INDICATORS
      *
     C                   MOVE      '0'           *IN28                          Error on Allocation
     C                   MOVE      '0'           *IN29                          Error on Number Opti
     C                   MOVE      '0'           *IN32                          Error on Ex-Date
     C                   MOVE      '0'           *IN33                          Error on Action Type
     C                   MOVE      '0'           *IN34                          Error on Status
     C                   MOVE      '0'           *IN37                          Error on Date Announ
     C                   MOVE      '0'           *IN38                          Error on Reference
     C                   MOVE      '0'           *IN39                          Error on Shortname
     C                   MOVE      '0'           *IN62                          Error on Action
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P015   : CLEAR SFL FIELDS                                     *
      *****************************************************************
      *
     C     P015          BEGSR
      *
      **   INITIALISE SUBFILE RECORD
      *
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      *BLANKS       #1REFN
     C                   MOVE      *BLANKS       #1LEVL                                       CSE020
     C                   MOVE      *BLANKS       #1SECN
     C                   MOVE      *BLANKS       #1COAT
     C                   MOVE      *BLANKS       #1COAN
     C                   MOVE      *BLANKS       #1EXDT
     C                   MOVE      *BLANKS       #1ALEF
     C                   MOVE      *BLANKS       #1NBOP
     C                   MOVE      *BLANKS       #1GSTS
      *
      **   INITIALISE HIDDEN SUBFILE FIELDS
      *
     C                   MOVE      *BLANKS       #FIELD
     C                   MOVE      *BLANKS       #1PTYP
     C                   MOVE      *BLANKS       #1TDVD
      *
     C                   MOVE      *BLANKS       #2SEL
     C                   MOVE      *BLANKS       #2COAN
     C                   MOVE      *BLANKS       #2EXDT
     C                   MOVE      *BLANKS       #2ALEF
     C                   MOVE      *BLANKS       #1MPRF                                       CSE020
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * P016  : LOAD SFL FIELDS                                       *
      *****************************************************************
      *
     C     P016          BEGSR
      *
      **   INITIALISE SUBFILE RECORD
      *
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      MACORF        #1REFN
     C                   MOVE      MALEVL        #1LEVL                                       CSE020
     C                   MOVE      MASESN        #1SECN
     C                   MOVE      MACOAT        #1COAT
     C                   MOVE      MAPTYP        #1PTYP
     C                   MOVE      MATDVD        #1TDVD
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C                   MOVE      MAPREF        #1MPRF                                       CSE020
     C                   ENDIF                                                                CSE020
      *
     C     MACOAN        IFNE      *ZEROS
     C                   Z-ADD     MACOAN        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1COAN
     C                   ELSE
     C                   MOVE      *BLANKS       #1COAN
     C                   ENDIF
      *
     C     MACOEX        IFNE      *ZEROS
     C                   Z-ADD     MACOEX        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1EXDT
     C                   ELSE
     C                   MOVE      *BLANKS       #1EXDT
     C                   ENDIF
      *
     C     MAALEF        IFNE      *ZEROS
     C                   Z-ADD     MAALEF        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1ALEF
     C                   ELSE
     C                   MOVE      *BLANKS       #1ALEF
     C                   ENDIF
      *
     C                   MOVE      MANBOP        #1NBOP
     C                   MOVE      MASTAT        #1GSTS
      *                                                                                       CSE016
     C                   MOVE      *BLANKS       #1SRNM                                       CSE016
      *                                                                                       CSE016
      ** Retrieve security description                                                        CSE016
      *                                                                                       CSE016
     C     #1SECN        CHAIN     SECTYZ1                            89                      CSE016
     C     *IN89         IFEQ      *OFF                                                       CSE016
      *                                                                                       CSE016
      ** Format security report description                                                   CSE016
      *                                                                                       CSE016
     C     #1SECN        IFNE      *BLANKS                                                    CSE016
      *                                                                                       CSE016
     C                   CALLB     'ZSDESC'                                                   CSE016
     C                   PARM      SRPN          PSRPN                                        CSE016
     C                   PARM                    PSFN1                                        CSE016
     C                   PARM                    PSFN2                                        CSE016
     C                   PARM                    CPNR                                         CSE016
     C                   PARM                    MATY                                         CSE016
     C                   PARM                    SCPP                                         CSE016
     C                   PARM                    SCPD                                         CSE016
     C                   PARM      BVRIDF        PRSFD                                        CSE016
     C                   PARM                    SCPI                                         CSE016
     C                   PARM                    PRNME                                        CSE016
     C                   PARM                    PFNM1                                        CSE016
     C                   PARM                    PFNM2                                        CSE016
     C                   PARM                    PFNM3                                        CSE016
      *                                                                                       CSE016
     C                   EVAL      #1SRNM = PRNME                                             CSE016
      *                                                                                       CSE016
     C                   ENDIF                                                                CSE016
      *                                                                                       CSE016
     C                   ENDIF                                                                CSE016
      *
      **   INITIALISE HIDDEN SUBFILE FIELDS
      *
     C                   MOVE      MAJOBN        WAJOBN           10
     C                   MOVE      MAUSER        WAUSER           10
     C                   Z-ADD     MAJNBR        WAJNBR            6 0
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      WAJOBN        MAJOBN
     C                   MOVE      WAUSER        MAUSER
     C                   Z-ADD     WAJNBR        MAJNBR
     C                   MOVE      *BLANKS       #2SEL
     C                   MOVE      #1COAN        #2COAN
     C                   MOVE      #1EXDT        #2EXDT
     C                   MOVE      #1ALEF        #2ALEF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * P017  : REINITIALISE POSITION/SELECTION FIELDS                *
      *****************************************************************
      *
     C     P017          BEGSR
      *
     C                   MOVE      *BLANKS       #REFN
     C                   MOVE      *BLANKS       #SECN
     C                   MOVE      *BLANKS       #EXDT
     C                   MOVE      *BLANKS       #COAT
     C                   MOVE      *BLANKS       #STAT
      *
     C                   MOVE      *BLANKS       #3REFN
     C                   MOVE      *BLANKS       #3SECN
     C                   MOVE      *BLANKS       #3EXDT
     C                   MOVE      *BLANKS       #3STAT
     C                   MOVE      *BLANKS       #3COAT
      *
     C                   MOVE      '0'           *IN50
     C                   MOVE      '0'           *IN51
     C                   MOVE      '0'           *IN52
     C                   MOVE      '0'           *IN86
     C                   MOVE      '0'           *IN69
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P018  : PROCESS 'FULL DETAILS' SCREEN                         *
      *****************************************************************
      *
     C     P018          BEGSR
      *
      **   SETUP THE DISPLAY FIELDS
      *                                                                   136420
     C                   MOVE      *BLANKS       #1BLKR                                        13642
     C     MAPTYP        IFEQ      'CC'                                                        13642
     C     #1REFN        CHAIN     SECOCCL0                           89                       13642
      *                                                                   136420
     C     *IN89         IFEQ      '0'                                                         13642
     C     NABLKR        ANDNE     *ZEROS                                                      13642
     C                   MOVE      NABLKR        #1BLKR                                        13642
     C                   ENDIF                                                                 13642
      *                                                                                       CSE020
      ** Display Parent reference field if MAPREF is not blanks                               CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     MAPREF        ANDNE     *BLANKS                                                    CSE020
     C                   MOVE      MAPREF        #1PREF                                       CSE020
     C                   MOVE      '1'           *IN53                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      '0'           *IN53                                        CSE020
     C                   ENDIF                                                                CSE020
      *                                                                   136420
     C                   ENDIF                                                                 13642
      *
     C                   MOVE      MATDVD        #1TDVD
      *
     C     MACOPD        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MACOPD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1COPD
     C                   ELSE                                                   X*1
     C                   MOVE      #1ALEF        #1COPD
     C                   ENDIF                                                  E*1
      *
     C     MATDDT        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MATDDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1TDDT
     C                   ELSE                                                   X*1
     C                   MOVE      #1ALEF        #1TDDT
     C                   ENDIF                                                  E*1
      *
     C     MAEVDT        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MAEVDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1EVDT
     C                   ELSE                                                   X*1
     C                   MOVE      #1EXDT        #1EVDT
     C                   ENDIF                                                  E*1
      *
     C     MACPNB        IFEQ      *ZEROS                                       B*1
     C                   MOVE      *BLANKS       #1CPNB
     C                   ELSE                                                   X*1
     C                   MOVE      MACPNB        #1CPNB
     C                   ENDIF                                                  E*1
      *
     C     MASHMD        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MASHMD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1SHMD
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1SHMD
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      MALTBS        #1LTBS
      *
      **   ACCESS SECURITY DETAILS TO RETRIEVE NUMBER OF DECIMALS ON THE SECURIT
      *
     C     MASESN        CHAIN     SECTYZ1                            89
      *
     C     MAOCPV        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAOCPV        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1OCPV
     C                   MOVE      ZOUT21        WFLD17           17
     C                   MOVEL     WFLD17        #1OCPV
     C                   ELSE
     C                   MOVE      *BLANKS       #1OCPV
     C                   ENDIF
      *
     C     MANCPV        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MANCPV        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1NCPV
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1NCPV
     C                   ELSE
     C                   MOVE      *BLANKS       #1NCPV
     C                   ENDIF
      *
     C     MAONML        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAONML        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1ONML
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1ONML
     C                   ELSE
     C                   MOVE      *BLANKS       #1ONML
     C                   ENDIF
      *
     C     MANNML        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MANNML        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1NNML
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1NNML
     C                   ELSE
     C                   MOVE      *BLANKS       #1NNML
     C                   ENDIF
      *
     C     MACUPC        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MACUPC        ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1CUPC
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1CUPC
     C                   ELSE
     C                   MOVE      *BLANKS       #1CUPC
     C                   ENDIF
      *
     C     MAEXPC        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAEXPC        ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1EXPC
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1EXPC
     C                   ELSE
     C                   MOVE      *BLANKS       #1EXPC
     C                   ENDIF
      *
     C     MACLRD        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MACLRD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1CLRD
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1CLRD
     C                   ENDIF                                                  E*1
      *
     C     MACLRT        IFNE      *ZEROS                                       B*1
     C                   MOVE      MACLRT        #1CLRT
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1CLRT
     C                   ENDIF                                                  E*1
      *
     C     MADLRD        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MADLRD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1DLRD
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1DLRD
     C                   ENDIF                                                  E*1
      *
     C     MADLRT        IFNE      *ZEROS                                       B*1
     C                   MOVE      MADLRT        #1DLRT
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1DLRT
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      MABLOP        #1BLOP
     C                   MOVE      MABLOP        #2BLOP
     C                   MOVE      MABLOS        #1BLOS
     C                   MOVE      MABLOS        #2BLOS
      *
     C     MABFRD        IFNE      *ZEROS                                       B*1
     C                   Z-ADD     MABFRD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1BFRD
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1BFRD
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      #1BFRD        #2BFRD
      *
     C     MABEND        IFNE      *ZEROS                                       B*1
     C     MABEND        ANDNE     *HIVAL                                                      13693
     C                   Z-ADD     MABEND        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1BEND
     C                   ELSE                                                   X*1
     C                   MOVE      *BLANKS       #1BEND
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      #1BEND        #2BEND
      *                                                                                       CGL031
      ** Move relevant file fields to screen fields if CGL031 is enabled.                     CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      #1SETX = MASETX                                            CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   MOVE      MAREFO        #1REFO
     C                   MOVE      MACONR        #1CONR
     C                   MOVE      MADFNR        #1DFNR
     C                   MOVE      MADFCP        #1DFCP
     C                   MOVE      MADFSP        #1DFSP
      *                                                                                       CSE020
      ** Move parent reference field to screen fields.                                        CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     MAPREF        ANDNE     *BLANKS                                                    CSE020
     C                   MOVE      MAPREF        #1PREF                                       CSE020
     C                   MOVE      '1'           *IN53                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      '0'           *IN53                                        CSE020
     C                   ENDIF                                                                CSE020
      *
     C                   MOVE      MANBOP        WNBOP
     C/COPY WNCPYSRC,SE7502C039
      *
     C                   MOVE      '1'           *IN47
      *                                                                                       CSE020
      ** Include F8 for Subordinate Action if CSE020 is installed and                         CSE020
      ** if CA Processing type is allowed to have a child                                     CSE020
      *                                                                                       CSE020
     C                   MOVE      '0'           *IN68                                        CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     #1LEVL        ANDNE     '9'                                                        CSE020
     C     #1PTYP        IFEQ      'FR'                                                       CSE020
     C     #1PTYP        OREQ      'CC'                                                       CSE020
     C     #1PTYP        OREQ      'CR'                                                       CSE020
     C     #1PTYP        OREQ      'DV'                                                       CSE020
     C     #1PTYP        OREQ      'EX'                                                       CSE020
     C     #1PTYP        OREQ      'NC'                                                       CSE020
     C     #1PTYP        OREQ      'OF'                                                       CSE020
     C     #1PTYP        OREQ      'RG'                                                       CSE020
     C                   MOVE      '1'           *IN68                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      '0'           *IN68                                        CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     WWINPT        ANDNE     'Y'                                                        CSE020
     C     *IN68         ANDEQ     '1'                                                        CSE020
     C     *IN61         IFEQ      '1'                                                        CSE020
     C                   MOVE      TXT(7)        ##CTX1                                       CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVE      TXT(8)        ##CTX1                                       CSE020
     C                   ENDIF                                                                CSE020
     C                   ELSE                                                                 CSE020
      *
     C     WWINPT        IFEQ      'Y'                                          B*0            13787
     C                   MOVEA     TXT(6)        ##CTX1                                        13787
     C                   ELSE                                                   X*0            13787
     C     *IN61         IFEQ      '1'                                          B*1
     C                   MOVEA     TXT(4)        ##CTX1
     C                   ELSE                                                   X*1
     C                   MOVEA     TXT(5)        ##CTX1
     C                   ENDIF                                                  E*1
     C                   ENDIF                                                  E*0            13787
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE016
      ** Retrieve security description                                                        CSE016
      *                                                                                       CSE016
     C     #1SECN        CHAIN     SECTYZ1                            89                      CSE016
     C     *IN89         IFEQ      *OFF                                                       CSE016
      *                                                                                       CSE016
      ** Format security report description                                                   CSE016
      *                                                                                       CSE016
     C                   MOVE      *BLANKS       #1SRNM                                       CSE016
      *                                                                                       CSE016
     C     #1SECN        IFNE      *BLANKS                                                    CSE016
      *                                                                                       CSE016
     C                   CALLB     'ZSDESC'                                                   CSE016
     C                   PARM      SRPN          PSRPN                                        CSE016
     C                   PARM                    PSFN1                                        CSE016
     C                   PARM                    PSFN2                                        CSE016
     C                   PARM                    CPNR                                         CSE016
     C                   PARM                    MATY                                         CSE016
     C                   PARM                    SCPP                                         CSE016
     C                   PARM                    SCPD                                         CSE016
     C                   PARM      BVRIDF        PRSFD                                        CSE016
     C                   PARM                    SCPI                                         CSE016
     C                   PARM                    PRNME                                        CSE016
     C                   PARM                    PFNM1                                        CSE016
     C                   PARM                    PFNM2                                        CSE016
     C                   PARM                    PFNM3                                        CSE016
      *                                                                                       CSE016
     C                   EVAL      #1SRNM = PRNME                                             CSE016
      *                                                                                       CSE016
     C                   ENDIF                                                                CSE016
      *                                                                                       CSE016
     C                   ENDIF                                                                CSE016
      *
     C                   MOVE      'Y'           ERROR             1
     C                   MOVE      '1'           *IN84
      *
      **  Determine fields to protect depending of the Status and the Final Allo
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN16
     C                   MOVE      '0'           *IN17
     C                   MOVE      '0'           *IN18
     C                   MOVE      '0'           *IN19
      *
      **  LS=Final Allocation Stock          (*IN15)
      **  LY=Final Allocation Cash and Stock (*IN16)
      **  S =Stock Authorised                (*IN17)
      **  X =Fully Authorised (Cash & Stock) (*IN18)
      **  C =Completed                       (*IN18 + *IN19)
      **  R =Reversed                        (*IN18 + *IN19)
     C     #1STAT        IFEQ      'L'                                          B*1
     C     #1FINA        IFEQ      'S'                                          B*2
     C                   MOVE      '1'           *IN15
     C                   ELSE                                                   X*2
     C     #1FINA        IFEQ      'Y'                                          B*3
     C                   MOVE      '1'           *IN16
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ELSE                                                   X*1
     C     #1STAT        IFEQ      'S'                                          B*2
     C                   MOVE      '1'           *IN17
     C                   ELSE                                                   X*2
     C     #1STAT        IFEQ      'X'                                          B*3
     C                   MOVE      '1'           *IN18
     C                   ELSE                                                   X*3
     C     #1STAT        IFEQ      'C'                                          B*4
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN18
     C                   MOVE      '1'           *IN19
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   DO WHILE F12 OR F3 IS NOT PRESSED AND NO ERROR
      *
     C     *INKC         DOWEQ     '0'                                          B*1
     C     *INKL         ANDEQ     '0'
     C     ERROR         ANDEQ     'Y'
     C/COPY WNCPYSRC,SE7502C040
      *
      **   IF 'NUMBER OF OPTIONS' IS NOT 01
      **   NON PROTECT THE FIELDS 'ACCEPT OFFER', 'REFUSE OFFER', 'OPTION NARRAT
      **                          'DEFAULT CASH', 'DEFAULT STOCK', 'DEFAULT FOR
      *
     C                   MOVE      WNBOP         W1NBOP
      *
     C     W1NBOP        IFNE      1                                            B*2
     C                   MOVE      '0'           *IN26
     C                   ELSE                                                   X*2
     C                   MOVE      '1'           *IN26
     C                   ENDIF                                                  E*2
      *
      **   SETUP SCREEN TIME
      *
     C                   TIME                    ##TME                          Screen time.
      *
      **   EXECUTE SCREEN FORMAT
      *
     C/COPY WNCPYSRC,SE7502C041
     C                   WRITE     #MSGCTL
     C                   WRITE     SE7502F1
     C                   EXFMT     SE7502F3
     C*****                MOVE '0'       *IN15                    137879 137884
     C*****                MOVE '0'       *IN16                    137879 137884
     C*****                MOVE '0'       *IN17                    137879 137884
     C*****                MOVE '0'       *IN18                    137879 137884
     C*****                MOVE '0'       *IN19                    137879 137884
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C/COPY WNCPYSRC,SE7502C042
      *
     C                   MOVE      'N'           ERROR
      *                                                                                       CSE020
      ** Process Subordinate Action if F8 pressed.                                            CSE020
      *                                                                                       CSE020
     C     CSE020        IFEQ      'Y'                                                        CSE020
     C     *INKH         ANDEQ     '1'                                                        CSE020
     C     *IN68         ANDEQ     '1'                                                        CSE020
     C                   MOVE      'Y'           ERROR                                        CSE020
     C                   CALLB     'SE7502N'                                                  CSE020
     C                   PARM                    MACORF                                       CSE020
     C                   PARM                    MACOEX                                       CSE020
     C                   PARM                    ACTION                                       CSE020
     C                   PARM                    #1SECN                                       CSE020
     C                   PARM                    #1STAT                                       CSE020
     C                   PARM                    #1FINA                                       CSE020
     C                   PARM                    #1SEL                                        CSE020
     C                   PARM                    #1PTYP                                       CSE020
     C                   PARM                    PRTCD             1                          CSE020
      *                                                                                       CSE020
     C     PRTCD         IFEQ      'E'                                                        CSE020
      *                                                                                       CSE020
     C     MMPTYP        IFEQ      'NF'                                                       CSE020
     C                   MOVEL     NARR(2)       DBKEY            29                          CSE020
     C                   ELSE                                                                 CSE020
     C     MMPTYP        IFEQ      'NC'                                                       CSE020
     C                   MOVEL     NARR(3)       DBKEY                                        CSE020
     C                   ELSE                                                                 CSE020
     C     MMPTYP        IFEQ      'CC'                                                       CSE020
     C                   MOVEL     NARR(7)       DBKEY                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   MOVEL     NARR(1)       DBKEY                                        CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
     C                   MOVEL     '009'         DBASE             3 0                        CSE020
     C                   MOVEL     *BLANKS       DBFILE           10                          CSE020
     C                   EXSR      *PSSR                                                      CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
      ** If Return Code is equal to '2', '3'                                                  CSE020
      *                                                                                       CSE020
     C     PRTCD         IFEQ      '3'                                                        CSE020
      *                                                                                       CSE020
      ** Access to ER Reference file with current reference                                   CSE020
      *                                                                                       CSE020
     C     #1REFN        CHAIN     SECORFL0                           88                      CSE020
      *                                                                                       CSE020
     C     *IN88         IFEQ      '0'                                                        CSE020
     C                   MOVE      *BLANKS       MAJOBN                                       CSE020
     C                   MOVE      *BLANKS       MAUSER                                       CSE020
     C                   Z-ADD     *ZEROS        MAJNBR                                       CSE020
      *                                                                                       CSE020
     C     MACHTP        IFNE      'R'                                                        CSE020
     C     MASTAT        ANDNE     'R'                                                        CSE020
     C     MASTAT        ANDNE     'C'                                                        CSE020
     C                   MOVE      'D'           MARECI                                       CSE020
     C                   Z-ADD     BJRDNB        MALCD                                        CSE020
     C                   MOVE      'A'           MACHTP                                       CSE020
     C                   MOVE      ##USR         MALUID                                       CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
     C                   UPDATE    SECORFD0                                                   CSE020
     C                   MOVE      FIELD         #FIELD                                       CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
      ** Commitment Instruction                                                               CSE020
      *                                                                                       CSE020
     C                   COMMIT                                                               CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
     C     PRTCD         IFEQ      '3'                                                        CSE020
     C                   MOVE      '1'           *INKC                                        CSE020
     C                   ELSE                                                                 CSE020
     C     WWINPT        IFEQ      'Y'                                                        CSE020
     C                   MOVE      '1'           *INKL                                        CSE020
     C                   ENDIF                                                                CSE020
     C     PRTCD         IFEQ      '1'                                                        CSE020
     C                   MOVE      '0'           WIN45                                        CSE020
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                                CSE020
      *                                                                                       CSE020
     C                   ELSE                                                                 CSE020
      *
      **   IF CMD11 PRESSED
      *
     C     *INKK         IFEQ      '1'                                          B*2
     C     *INKC         OREQ      '0'                                                         13787
     C     *INKL         ANDEQ     '0'                                                         13787
     C     WWINPT        ANDEQ     'Y'                                                         13787
      *                                                                   155622
      **   VALIDATE DETAILS AND UPDATE FILE IF NO ERROR                   155622
      *                                                                   155622
     C     *IN61         IFEQ      '0'                                          B*3            15562
     C                   EXSR      P019                                                        15562
     C                   ENDIF                                                  E*3            15562
      *
      **   VIEW/CHANGE OPTION(S)
      *
     C     ERROR         IFEQ      'N'                                          B*3            15562
     C/COPY WNCPYSRC,SE7502C043
     C                   EXSR      P023
     C/COPY WNCPYSRC,SE7502C044
     C                   ENDIF                                                  E*3            15562
     C                   ELSE                                                   X*2
      *
      **   IF ALL INPUT FIELDS ARE NOT PROTECTED
      *
     C     *IN61         IFEQ      '0'                                          B*3
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      **   VALIDATE DETAILS AND UPDATE FILE IF NO ERROR
      *
     C                   EXSR      P019
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C/COPY WNCPYSRC,SE7502C045
     C                   ENDIF                                                                CSE020
     C                   ENDDO                                                  E*1
      *                                                                   137884
     C                   MOVE      '0'           *IN15                                         13788
     C                   MOVE      '0'           *IN16                                         13788
     C                   MOVE      '0'           *IN17                                         13788
     C                   MOVE      '0'           *IN18                                         13788
     C                   MOVE      '0'           *IN19                                         13788
      *
      **   SETUP CORRECTLY THE COMMAND KEYS AVAILABLE
      *
     C                   MOVEA     TXT(3)        ##CTX1
      *
     C                   MOVE      '0'           *IN47
      *
      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
      *
     C/COPY WNCPYSRC,SE7502C046
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C/COPY WNCPYSRC,SE7502C047
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P019  : VALIDATE 'FULL DETAILS' SCREEN AND UPDATE FILE        *
      *****************************************************************
      *
     C     P019          BEGSR
      *
      **   ACCESS SECURITY DETAILS WITH CURRENT SECURITY SHORTNAME
      *
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      **   INITIALISE ERROR INDICATORS
      *
     C                   EVAL      *IN07 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN13
     C                   MOVE      '0'           *IN14
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN42
     C                   MOVE      '0'           *IN49
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C                   MOVE      '0'           *IN67
     C                   MOVE      '0'           *IN70
     C                   MOVE      '0'           *IN71
     C                   MOVE      '0'           *IN72
     C                   MOVE      '0'           *IN73
     C                   MOVE      '0'           *IN74
     C                   MOVE      '0'           *IN76
     C                   MOVE      '0'           *IN77
     C                   MOVE      '0'           *IN78
     C                   MOVE      '0'           *IN79
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   MOVE      '0'           *IN85
      *
     C                   Z-ADD     *ZEROS        WCOPD             5 0
     C                   Z-ADD     *ZEROS        WTDDT             5 0
     C                   Z-ADD     *ZEROS        WEVDT             5 0
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WEXDT             5 0
      *
     C                   MOVE      #1ALEF        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WALEF             5 0
      *
      **   IF 'PAYMENT DATE' IS NOT BLANK
      *
     C     #1COPD        IFNE      *BLANKS                                      B*1
      *
     C                   MOVE      #1COPD        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF 'PAYMENT DATE IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00038'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   Z-ADD     ZDAYNO        WCOPD             5 0
      *
      **   IF 'PAYMENT DATE' IS BEFORE THE 'EX-DATE'
      *
     C     WCOPD         IFLT      WEXDT                                        B*3
     C     WEXDT         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
      **   IF 'PAYMENT DATE' IS BEFORE THE 'ALLOCATION EFFECTIVE DATE'
      *
     C     WCOPD         IFLT      WALEF                                        B*3
     C     WALEF         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
      **   IF 'PAYMENT DATE' IS GREATER OR EQUAL TO THE MATURITY DATE OF THE SEC
      *
     C     WCOPD         IFGE      MATY                                         B*3
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00217'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'TRADE DATE' IS NOT BLANK
      *
     C     #1TDDT        IFNE      *BLANKS                                      B*1
      *
     C                   MOVE      #1TDDT        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF 'TRADE DATE IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00301'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   Z-ADD     ZDAYNO        WTDDT             5 0
      *
      **   IF 'TRADE DATE' IS GREATER THAN THE 'ALLOCATION EFFECTIVE DATE'
      *
     C     WTDDT         IFGT      WALEF                                        B*3
     C     WALEF         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00212'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
      **   IF 'TRADE DATE' MUST BE LOWER THAN THE MATURITY DATE OF THE SECURITY
      *
     C     WTDDT         IFGE      MATY                                         B*3
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00218'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
      **   IF 'TRADE DATE' MUST BE GREATER OR EQUAL THAN SE BACK VALUE PERIOD
      *
     C     WTDDT         IFLT      WBACKD                                       B*3
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00219'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'EVENT DATE' IS NOT BLANK
      *
     C     #1EVDT        IFNE      *BLANKS                                      B*1
      *
     C                   MOVE      #1EVDT        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF 'EVENT DATE IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN49                          Reverse image
     C                   MOVEL     'CO00211'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   Z-ADD     ZDAYNO        WEVDT             5 0
      *
      **   IF 'PAYMENT DATE' IS BEFORE 'EVENT DATE'
      *
     C     WCOPD         IFLT      WEVDT                                        B*3
     C     WCOPD         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00216'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
      **   IF 'EVENT DATE' MUST NOT BE BEFORE 'EX-DATE'
      *
     C     WEVDT         IFLT      WEXDT                                        B*3
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN49                          Reverse image
     C                   MOVEL     'CO00213'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
      **   IF 'EVENT DATE' MUST BE LOWER THAN MATURITY DATE OF THE SECURITY
      *
     C     WEVDT         IFGE      MATY                                         B*3
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN49                          Reverse image
     C                   MOVEL     'CO00220'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'TRADE/VALUE DATE POSITION' IS ENTERED
      *
     C     #1TDVD        IFNE      *BLANKS                                      B*1
      *
      **   'TRADE/VALUE DATE POSITION' MUST BE EQUAL TO 'T' OR 'V'
      *
     C     #1TDVD        IFNE      'T'                                          B*2
     C     #1TDVD        ANDNE     'V'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN66                          Reverse image
     C                   MOVEL     'CO00037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ELSE                                                   X*1
     C                   MOVE      'T'           #1TDVD
     C                   ENDIF                                                  E*1
      *
      **   IF 'COUPON NUMBER' IS ENTERED
      *
     C     #1CPNB        IFNE      *BLANKS                                      B*1
      *
      **   CHECK IT'S A VALID NUMERIC FIELD
      *
     C     DIGITS        CHECK     #1CPNB:1      N                 1 0    89
      *
      **   IF IT'S NOT A VALID NUMERIC FIELD
      *
     C     *IN89         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN67                          Reverse image
     C                   MOVEL     'CO00040'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'SHAREHOLDERS MEETING DATE' IS ENTERED
      *
     C     #1SHMD        IFNE      *BLANKS                                      B*1
      *
     C                   MOVE      #1SHMD        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF 'SHAREHOLDERS MEETING DATE' IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN70                          Reverse image
     C                   MOVEL     'CO00043'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'LETTER TO BE SENT' HAS BEEN ENTERED
      *
     C     #1LTBS        IFNE      *BLANKS                                      B*1
      *
      **   'LETTER TO BE SENT' MUST BE EQUAL TO 'Y' OR 'N'
      *
     C     #1LTBS        IFNE      'Y'                                          B*2
     C     #1LTBS        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN71                          Reverse image
     C                   MOVEL     'CO00044'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ELSE                                                   X*1
     C                   MOVE      'N'           #1LTBS
     C                   ENDIF                                                  E*1
      *
      **   IF 'OLD CAPITAL VALUE' HAS BEEN ENTERED
      *
     C     #1OCPV        IFNE      *BLANKS                                      B*1
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1OCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVEL     'CO00129'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN20
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'NEW CAPITAL VALUE' HAS BEEN ENTERED
      *
     C     #1NCPV        IFNE      *BLANKS                                      B*1
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1NCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVEL     'CO00130'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN21
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'OLD NOMINAL VALUE' HAS BEEN ENTERED
      *
     C     #1ONML        IFNE      *BLANKS                                      B*1
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1ONML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVEL     'CO00131'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN22
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'NEW NOMINAL VALUE' HAS BEEN ENTERED
      *
     C     #1NNML        IFNE      *BLANKS                                      B*1
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1NNML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVEL     'CO00132'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN23
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'MARKET CUM PRICE' HAS BEEN ENTERED
      *
     C     #1CUPC        IFNE      *BLANKS                                      B*1
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1CUPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVEL     'CO00133'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN24
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'MARKET EX PRICE' HAS BEEN ENTERED
      *
     C     #1EXPC        IFNE      *BLANKS                                      B*1
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1EXPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVEL     'CO00134'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN31
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'CUSTOMER LAST REPLY DATE' HAS BEEN ENTERED
      *
     C     #1CLRD        IFNE      *BLANKS                                      B*1
      *
     C                   MOVE      #1CLRD        ZDATE
     C                   EXSR      ZDATE1
      *
      **   'CUSTOMER LAST REPLY DATE' MUST BE A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN83                          Reverse image
     C                   MOVEL     'CO00059'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'CUSTOMER LAST REPLY TIME' HAS BEEN ENTERED
      *
     C     #1CLRT        IFNE      *BLANKS                                      B*1
      *
      **   NO ENTRY ALLOWED WHEN 'CUSTOMER LAST REPLY DATE' IS NOT ENTERED
      *
     C     #1CLRD        IFEQ      *BLANKS                                      B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN13                          Reverse image
     C                   MOVEL     'CO00062'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
      *
     C                   MOVEL     #1CLRT        WWHOUR            2 0
     C                   MOVE      #1CLRT        WWMISE            4
     C                   MOVEL     WWMISE        WWMINS            2 0
     C                   MOVE      WWMISE        WWSECS            2 0
      *
      **   'CUSTOMER LAST REPLY TIME' MUST BE A VALID TIME FORMAT
      *
     C     WWHOUR        IFGT      23                                           B*3
     C     WWHOUR        ORLT      0
     C     WWMINS        ORGT      59
     C     WWMINS        ORLT      0
     C     WWSECS        ORGT      59
     C     WWSECS        ORLT      0
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN13                          Reverse image
     C                   MOVEL     'CO00061'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'DEPOT LAST REPLY DATE' HAS BEEN ENTERED
      *
     C     #1DLRD        IFNE      *BLANKS                                      B*1
      *
     C                   MOVE      #1DLRD        ZDATE
     C                   EXSR      ZDATE1
      *
      **   'DEPOT LAST REPLY DATE' MUST BE A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN85                          Reverse image
     C                   MOVEL     'CO00060'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'DEPOT LAST REPLY TIME' HAS BEEN ENTERED
      *
     C     #1DLRT        IFNE      *BLANKS                                      B*1
      *
      **   NO ENTRY ALLOWED WHEN 'DEPOT LAST REPLY DATE' IS NOT ENTERED
      *
     C     #1DLRD        IFEQ      *BLANKS                                      B*2
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN14                          Reverse image
     C                   MOVEL     'CO00064'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
      *
     C                   MOVEL     #1DLRT        WWHOUR            2 0
     C                   MOVE      #1DLRT        WWMISE            4
     C                   MOVEL     WWMISE        WWMINS            2 0
     C                   MOVE      WWMISE        WWSECS            2 0
      *
      **   'CUSTOMER LAST REPLY TIME' MUST BE A VALID TIME FORMAT
      *
     C     WWHOUR        IFGT      23                                           B*3
     C     WWHOUR        ORLT      0
     C     WWMINS        ORGT      59
     C     WWMINS        ORLT      0
     C     WWSECS        ORGT      59
     C     WWSECS        ORLT      0
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN14                          Reverse image
     C                   MOVEL     'CO00063'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'BLOCK SECURITY' HAS BEEN ENTERED
      *
     C     #1BLOS        IFNE      *BLANKS                                      B*1
      *
      **   'BLOCK SECURITY' MUST BE EQUAL TO 'E', 'W' OR 'N'
      *
     C     #1BLOS        IFNE      'E'                                          B*2
     C     #1BLOS        ANDNE     'W'
     C     #1BLOS        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN42                          Reverse image
     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ELSE                                                   X*1
     C                   MOVE      'N'           #1BLOS
     C                   ENDIF                                                  E*1
      *
      **   IF 'BLOCK POSITION' HAS BEEN ENTERED
      *
     C     #1BLOP        IFNE      *BLANKS                                      B*1
      *
      **   'BLOCK POSITION' MUST BE EQUAL TO 'E', 'W' OR 'N'
      *
     C     #1BLOP        IFNE      'E'                                          B*2
     C     #1BLOP        ANDNE     'W'
     C     #1BLOP        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN72                          Reverse image
     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ELSE                                                   X*1
     C                   MOVE      'N'           #1BLOP
     C                   ENDIF                                                  E*1
      *
     C     #1BLOP        IFEQ      'E'                                          B*1
     C     #1BLOP        ANDEQ     'W'
     C     #1BLOS        OREQ      'E'
     C     #1BLOS        ANDEQ     'W'
      *
     C     #1BFRD        IFEQ      *BLANKS                                      B*2
     C                   MOVE      #1EXDT        #1BFRD
     C                   MOVE      #1EXDT        #2BFRD
     C                   ENDIF                                                  E*2
      *
     C     #1BEND        IFEQ      *BLANKS                                      B*2
     C                   MOVE      #1ALEF        #1BEND
     C                   MOVE      #1ALEF        #2BEND
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C                   Z-ADD     *ZEROS        W1BFRD            5 0
      *
      **   IF 'BLOCK FROM DATE' HAS BEEN ENTERED
      *
     C     #1BFRD        IFNE      *BLANKS                                      B*1
      *
      **   'BLOCK FROM DATE' MUST NOT BEEN ENTERED IF BLOCK INDICATORS 'N'
      *
     C     #1BLOP        IFEQ      'N'                                          B*2
     C     #1BLOS        ANDEQ     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00046'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
      *
     C                   MOVE      #1BFRD        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        W1BFRD
      *
      **   IF 'BLOCK FROM DATE' IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*3
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00048'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*3
      *
      **   'BLOCK FROM DATE' MUST BE GREATER THAN RUN DATE
      *
     C     ZDAYNO        IFLE      BJRDNB                                       B*4
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00050'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ELSE                                                   X*1
      *
      **   'BLOCK FROM DATE' MUST BE ENTERED IF BLOCK POSITION IS 'E' OR 'W
      *
     C     #1BLOP        IFEQ      'E'                                          B*2
     C     #1BLOP        OREQ      'W'
     C     #1BLOS        OREQ      'E'
     C     #1BLOS        OREQ      'W'
     C     #1BEND        IFEQ      *BLANKS                                      B*3            13693
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00243'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3            13693
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF 'BLOCK END DATE' HAS BEEN ENTERED
      *
     C     #1BEND        IFNE      *BLANKS                                      B*1
      *
      **   'BLOCK END DATE' MUST NOT BEEN ENTERED IF BLOCK INDICATORS 'N'
      *
     C     #1BLOP        IFEQ      'N'                                          B*2
     C     #1BLOS        ANDEQ     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00047'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
      *
     C                   MOVE      #1BEND        ZDATE
     C                   EXSR      ZDATE1
      *
      **   IF 'BLOCK END DATE' IS NOT A VALID DATE FORMAT
      *
     C     *IN99         IFEQ      '1'                                          B*3
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00049'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*3
      *
      **   'BLOCK END DATE' MUST BE GREATER THAN RUN DATE/FROM DATE
      **   AND BEFORE MATURITY DATE OF THE SECURITY
      *
     C     ZDAYNO        IFLE      BJRDNB                                       B*4
     C     ZDAYNO        ORLE      W1BFRD
     C     ZDAYNO        ORGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00051'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
     C                   ELSE                                                   X*1
      *
      **   'BLOCK END DATE' MUST BE ENTERED IF BLOCK POSITION IS 'E' OR 'W'
      *
     C     #1BLOP        IFEQ      'E'                                          B*2
     C     #1BLOP        OREQ      'W'
     C     #1BLOS        OREQ      'E'
     C     #1BLOS        OREQ      'W'
     C     #1BFRD        IFEQ      *BLANKS                                      B*3            13693
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00244'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3            13693
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
                                                                                              CGL031
      ** Validate Subject to European Tax if CGL031 is enabled.                               CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
     C                   IF        #1SETX = *BLANK                                            CGL031
                                                                                              CGL031
     C                   IF        #1COAT = 'DI'                                              CGL031
     C                   EVAL      #1SETX = SETX                                              CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
      ** Subject to European Tax is mandatory.                                                CGL031
                                                                                              CGL031
     C                   EVAL      ERROR = 'Y'                                                CGL031
     C                   EVAL      *IN07 = *ON                                                CGL031
     C                   EVAL      ZAMSID = 'SEA0907'                                         CGL031
     C                   EXSR      ZASNMS                                                     CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        #1SETX <> 'Y' AND                                          CGL031
     C                             #1SETX <> 'N'                                              CGL031
                                                                                              CGL031
      ** Subject to European Tax must be 'Y' or 'N'.                                          CGL031
                                                                                              CGL031
     C                   EVAL      ERROR = 'Y'                                                CGL031
     C                   EVAL      *IN07 = *ON                                                CGL031
     C                   EVAL      ZAMSID = 'SEA0908'                                         CGL031
     C                   EXSR      ZASNMS                                                     CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      **   IF 'NUMBER OF OPTIONS' GREATER THAN 1
      *
     C     *IN26         IFEQ      '0'                                          B*1
      *
      **   'REFUSE OFFER' MUST BE EQUAL TO 'Y' OR 'N'
      *
     C     #1REFO        IFNE      'Y'                                          B*2
     C     #1REFO        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN76                          Reverse image
     C                   MOVEL     'CO00053'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
      *
      **   VALIDATE 'CUSTOMER OPTION NARRATIVE'
      *
     C     #1CONR        IFEQ      *BLANKS                                      B*2
      *
      **   'CUSTOMER OPTION NARRATIVE' MANDATORY IF REFUSE OFFER 'Y'
      *
     C     #1REFO        IFEQ      'Y'                                          B*3
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN77                          Reverse image
     C                   MOVEL     'CO00054'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
      *
     C                   ELSE                                                   X*2
      *
      **   'CUSTOMER OPTION NARRATIVE' MUST REFER TO A VALID LIVE CODE
      *
     C     #1CONR        CHAIN     SECONAL0                           89
     C     *IN89         IFEQ      '1'                                          B*3
     C     MNRECI        ORNE      'D'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN77                          Reverse image
     C                   MOVEL     'CO00055'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   'DEFAULT FOR NO REPLY' MUST BE EQUAL TO ONE OF THE CUSTOMER OPTIONS
      *
     C     #1DFNR        IFNE      '1'                                          B*2
     C     #1DFNR        ANDNE     '2'
     C     #1DFNR        ANDNE     '3'
     C     #1DFNR        ANDNE     '4'
     C     #1DFNR        ANDNE     '5'
     C     #1DFNR        ANDNE     '6'
     C     #1DFNR        ANDNE     '7'
     C     #1DFNR        ANDNE     '8'
     C     #1DFNR        ANDNE     '9'
     C     #1DFNR        ANDNE     ' '
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN78                          Reverse image
     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   MOVE      #1REFN        KCORF
     C                   Z-ADD     *ZEROS        KOPTN
     C                   MOVE      #1DFNR        KOPTN
      *
     C     #1PTYP        IFNE      'NC'                                         B*3
     C     #1PTYP        ANDNE     'NF'
     C     #1PTYP        ANDNE     'CC'                                                        CEU01
     C                   EXSR      P024
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN89
     C                   ENDIF                                                  E*3
      *
     C     *IN89         IFEQ      '1'                                          B*3
     C     #1PTYP        OREQ      'NC'
     C     #1DFNR        ANDNE     '1'
     C     #1PTYP        OREQ      'NF'
     C     #1DFNR        ANDNE     '1'
     C     #1PTYP        OREQ      'CC'                                                        CEU01
     C     #1DFNR        ANDNE     '1'                                                         CEU01
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN78                          Reverse image
     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   'DEFAULT FOR CASH PREFERRED' MUST BE EQUAL TO ONE OF THE CUSTOMER OPT
      *
     C     #1DFCP        IFNE      '1'                                          B*2
     C     #1DFCP        ANDNE     '2'
     C     #1DFCP        ANDNE     '3'
     C     #1DFCP        ANDNE     '4'
     C     #1DFCP        ANDNE     '5'
     C     #1DFCP        ANDNE     '6'
     C     #1DFCP        ANDNE     '7'
     C     #1DFCP        ANDNE     '8'
     C     #1DFCP        ANDNE     '9'
     C     #1DFCP        ANDNE     ' '
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN79                          Reverse image
     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   MOVE      #1REFN        KCORF
     C                   Z-ADD     *ZEROS        KOPTN
     C                   MOVE      #1DFCP        KOPTN
      *
     C     #1PTYP        IFNE      'NC'                                         B*3
     C     #1PTYP        ANDNE     'NF'
     C     #1PTYP        ANDNE     'CC'                                                        CEU01
     C                   EXSR      P024
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN89
     C                   ENDIF                                                  E*3
      *
     C     *IN89         IFEQ      '1'                                          B*3
     C     #1PTYP        OREQ      'NC'
     C     #1DFCP        ANDNE     '1'
     C     #1PTYP        OREQ      'NF'
     C     #1DFCP        ANDNE     '1'
     C     #1PTYP        OREQ      'CC'                                                        CEU01
     C     #1DFCP        ANDNE     '1'                                                         CEU01
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN79                          Reverse image
     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
      **   'DEFAULT FOR STOCK PREFERRED' MUST BE EQUAL TO ONE OF THE CUSTOMER OP
      *
     C     #1DFSP        IFNE      '1'                                          B*2
     C     #1DFSP        ANDNE     '2'
     C     #1DFSP        ANDNE     '3'
     C     #1DFSP        ANDNE     '4'
     C     #1DFSP        ANDNE     '5'
     C     #1DFSP        ANDNE     '6'
     C     #1DFSP        ANDNE     '7'
     C     #1DFSP        ANDNE     '8'
     C     #1DFSP        ANDNE     '9'
     C     #1DFSP        ANDNE     ' '
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN82                          Reverse image
     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE                                                   X*2
     C                   MOVE      #1REFN        KCORF
     C                   Z-ADD     *ZEROS        KOPTN
     C                   MOVE      #1DFSP        KOPTN
      *
     C     #1PTYP        IFNE      'NC'                                         B*3
     C     #1PTYP        ANDNE     'NF'
     C     #1PTYP        ANDNE     'CC'                                                        CEU01
     C                   EXSR      P024
     C                   ELSE                                                   X*3
     C                   MOVE      '0'           *IN89
     C                   ENDIF                                                  E*3
      *
     C     *IN89         IFEQ      '1'                                          B*3
     C     #1PTYP        OREQ      'NC'
     C     #1DFSP        ANDNE     '1'
     C     #1PTYP        OREQ      'NF'
     C     #1DFSP        ANDNE     '1'
     C     #1PTYP        OREQ      'CC'                                                        CEU01
     C     #1DFSP        ANDNE     '1'                                                         CEU01
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN82                          Reverse image
     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
      **   IF NO ERROR DETECTED
      *
     C     ERROR         IFEQ      'N'                                          B*1
     C/COPY WNCPYSRC,SE7502C063
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
      *
     C     *INKK         IFEQ      '0'                                          B*2            15668
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   ENDIF                                                  E*2            15668
      *
     C                   Z-ADD     WCOPD         MACOPD
     C                   Z-ADD     WTDDT         MATDDT
     C                   MOVE      #1TDVD        MATDVD
     C                   Z-ADD     WCOPD         MACOPD
     C                   Z-ADD     WTDDT         MATDDT
     C                   Z-ADD     WEVDT         MAEVDT
     C                   MOVE      #1CPNB        MACPNB
      *
     C                   MOVE      #1SHMD        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MASHMD
      *
     C                   MOVE      #1LTBS        MALTBS
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1OCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        WOUT15           15 0
      *
     C     ZFSIGN        IFEQ      '+'                                          B*1
     C                   Z-ADD     WOUT15        MAOCPV
     C                   ELSE                                                   X*1
     C                   Z-SUB     WOUT15        MAOCPV
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1NCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        WOUT15
      *
     C     ZFSIGN        IFEQ      '+'                                          B*1
     C                   Z-ADD     WOUT15        MANCPV
     C                   ELSE                                                   X*1
     C                   Z-SUB     WOUT15        MANCPV
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1ONML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        WOUT15
      *
     C     ZFSIGN        IFEQ      '+'                                          B*1
     C                   Z-ADD     WOUT15        MAONML
     C                   ELSE                                                   X*1
     C                   Z-SUB     WOUT15        MAONML
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1NNML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        WOUT15
      *
     C     ZFSIGN        IFEQ      '+'                                          B*1
     C                   Z-ADD     WOUT15        MANNML
     C                   ELSE                                                   X*1
     C                   Z-SUB     WOUT15        MANNML
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     #1CUPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MACUPC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     #1EXPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAEXPC
      *
     C                   MOVE      #1CLRD        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MACLRD
      *
     C                   MOVE      #1CLRT        MACLRT
      *
     C                   MOVE      #1DLRD        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MADLRD
      *
     C                   MOVE      #1DLRT        MADLRT
     C                   MOVE      #1BLOS        MABLOS
     C                   MOVE      #1BLOP        MABLOP
      *
     C                   MOVE      #1BFRD        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MABFRD
      *
     C     #1BEND        IFNE      *BLANKS                                                     13693
     C                   MOVE      #1BEND        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        MABEND
     C                   ELSE                                                                  13693
     C     #1BLOS        IFEQ      'E'                                                         13693
     C     #1BLOS        OREQ      'W'                                                         13693
     C     #1BLOP        OREQ      'E'                                                         13693
     C     #1BLOP        OREQ      'W'                                                         13693
     C                   Z-ADD     *HIVAL        MABEND                                        13693
     C                   ELSE                                                                  13693
     C                   Z-ADD     *ZEROS        MABEND                                        13693
     C                   ENDIF                                                                 13693
     C                   ENDIF                                                                 13693
      *                                                                                       CGL031
      ** Move relevant screen fields to file fields if CGL031 is enabled.                     CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      MASETX = #1SETX                                            CGL031
     C                   ELSE                                                                 CGL031
     C                   EVAL      MASETX = *BLANK                                            CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   MOVE      #1REFO        MAREFO
     C                   MOVE      #1CONR        MACONR
     C                   MOVE      #1DFNR        MADFNR
     C                   MOVE      #1DFCP        MADFCP
     C                   MOVE      #1DFSP        MADFSP
      *
      **   BLOCKING PROCESSING
      *
     C     #1BLOS        IFNE      #2BLOS                                       B*2
     C     #1BFRD        ORNE      #2BFRD
     C     #1BEND        ORNE      #2BEND
     C                   EXSR      P020
     C                   ENDIF                                                  E*2
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
      **   ADD COMMITMENT INSTRUCTION
      *
     C                   COMMIT
      *
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P020  : BLOCKING PROCESSING                                   *
      *****************************************************************
      *
     C     P020          BEGSR
      *
      **   ACCESS BLOCKING FILE WITH THE CORPORATE ACTION REFERENCE
      *
     C     MACORF        CHAIN     SECOBKL2                           89
      *
      **   IF BLOCK EXISTS, REVERSE THE CURRENT BLOCKING RECORD
      *
     C     *IN89         IFEQ      '0'                                          B*1
     C                   MOVE      '*'           MURECI
     C                   UPDATE    SECOBKD2
     C                   ENDIF                                                  E*1
      *                                                                   149983
      **   ACCESS BLOCKING FILE WITH THE CORPORATE ACTION REFERENCE       149983
      *                                                                   149983
     C     MACORF        CHAIN     SECOBKL2                           89                       14998
      *                                                                   149983
      **   IF BLOCK EXISTS, REVERSE THE CURRENT BLOCKING RECORD           149983
      *                                                                   149983
     C     *IN89         IFEQ      '0'                                          B*1            14998
     C                   MOVE      '*'           MURECI                                        14998
     C                   UPDATE    SECOBKD2                                                    14998
     C                   ENDIF                                                  E*1            14998
      *
      **   CREATE THE NEW BLOCKING RECORD IF BLOCK POSITION 'E' OR'W'
      *
     C     MABLOS        IFEQ      'E'                                          B*1
     C     MABLOS        OREQ      'W'
     C                   MOVE      'D'           MURECI
     C                   Z-ADD     BJRDNB        MULCD
     C                   MOVE      'I'           MUCHTP
     C                   MOVE      ##USR         MULUID
     C                   MOVE      BVBRCD        MUBRCD
     C**********         Z-ADD     *ZEROS        MUCNUM                                       CSD027
     C                   EVAL      MUCNUM = *BLANKS                                           CSD027
     C                   MOVE      *BLANKS       MUPTFR
     C                   MOVE      'P'           MUBLTY
     C                   MOVE      MASESN        MUSESN
     C                   MOVE      MABEND        MUBEDT
     C                   Z-ADD     *ZEROS        MUNOMB
      *
     C                   MOVEL     MACOAT        WWBNAR            9
     C                   MOVE      MACORF        WWBNAR
     C                   MOVEL     WWBNAR        MUBNAR
      *
     C                   Z-ADD     1             MUSEQN
     C                   MOVE      MABFRD        MUBSTT
     C                   MOVE      MABLOS        MUBEWI
     C                   MOVE      MACORF        MUCORF
     C                   WRITE     SECOBKD2
     C                   MOVE      'S'           MUBLTY                                        14998
     C                   WRITE     SECOBKD2                                                    14998
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P021  : RETRIEVE NEXT AVAILABLE REFERENCE NUMBER              *
      *****************************************************************
      *
     C     P021          BEGSR
      *
      **   SETUP "REFERENCE" FIELD WITH NEXT AVAILABLE NUMBER
      *
     C                   MOVE      WWCORF        #1REFN
     C                   ADD       1             WWCORF
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C***********#1REFN    CHAINSECORFL1             88                   136421
     C     #1REFN        CHAIN     SECORFL9                           88                       13642
      *
      **   IF A RECORD IS FOUND
      *
     C     *IN88         DOWEQ     '0'                                          B*1
      *
     C                   MOVE      WWCORF        #1REFN
     C                   ADD       1             WWCORF
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C***********#1REFN    CHAINSECORFL1             88                   136421
     C     #1REFN        CHAIN     SECORFL9                           88                       13642
     C                   ENDDO                                                  E*1
      *
     C                   MOVE      #1BLOS        #2BLOS
     C                   MOVE      #1BEND        #2BEND
     C                   MOVE      #1BFRD        #2BFRD
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P022  : APPLY ACTION TO ALL OPTIONS                           *
      *****************************************************************
      *
     C     P022          BEGSR
      *
     C     #1PTYP        IFEQ      'DV'                                         B*1
     C     #1REFN        SETLL     SECODVL0
     C     #1REFN        READE     SECODVL0                               89
      *
     C                   ELSE                                                   X*1
     C     #1PTYP        IFEQ      'FR'                                         B*2
     C     #1REFN        SETLL     SECOFRL0
     C     #1REFN        READE     SECOFRL0                               89
      *
     C                   ELSE                                                   X*2
     C     #1PTYP        IFEQ      'CE'                                         B*3
     C     #1REFN        SETLL     SECOCEL0
     C     #1REFN        READE     SECOCEL0                               89
      *
     C                   ELSE                                                   X*3
     C     #1PTYP        IFEQ      'CR'                                         B*4
     C     #1REFN        SETLL     SECOCRL0
     C     #1REFN        READE     SECOCRL0                               89
      *
     C                   ELSE                                                   X*4
     C     #1PTYP        IFEQ      'OF'                                         B*5
     C     #1REFN        SETLL     SECOOFL0
     C     #1REFN        READE     SECOOFL0                               89
      *
     C                   ELSE                                                   X*5
     C     #1PTYP        IFEQ      'RG'                                         B*6
     C     #1REFN        SETLL     SECORGL0
     C     #1REFN        READE     SECORGL0                               89
      *
     C                   ELSE                                                   X*6
     C     #1PTYP        IFEQ      'EX'                                         B*7
     C     #1REFN        SETLL     SECOEXL0
     C     #1REFN        READE     SECOEXL0                               89
      *
     C                   ELSE                                                   X*7
     C     #1PTYP        IFEQ      'NC'                                         B*8
     C     #1REFN        SETLL     SECONCL0
     C     #1REFN        READE     SECONCL0                               89
      *
     C                   ELSE                                                   X*8
     C     #1PTYP        IFEQ      'NF'                                         B*9
     C     #1REFN        SETLL     SECONFL0
     C     #1REFN        READE     SECONFL0                               89
      *                                                                   CEU017
     C                   ELSE                                                   X*9            CEU01
     C     #1PTYP        IFEQ      'CC'                                         B*10           CEU01
     C     #1REFN        SETLL     SECOCCL0                                                    CEU01
     C     #1REFN        READE     SECOCCL0                               89                   CEU01
     C/COPY WNCPYSRC,SE7502C048
     C                   ENDIF                                                  E*10           CEU01
     C                   ENDIF                                                  E*9
     C                   ENDIF                                                  E*8
     C                   ENDIF                                                  E*7
     C                   ENDIF                                                  E*6
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C     *IN89         DOWEQ     '0'                                          B*1
      *
     C     #1PTYP        IFEQ      'DV'                                         B*2
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECODVD0
     C                   ENDIF                                                  E*3
     C     #1REFN        READE     SECODVL0                               89
      *
     C                   ELSE                                                   X*2
      *
     C     #1PTYP        IFEQ      'FR'                                         B*3
      *
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECOFRD0
     C                   ENDIF                                                  E*3
     C     #1REFN        READE     SECOFRL0                               89
      *
     C                   ELSE                                                   X*3
     C     #1PTYP        IFEQ      'CE'                                         B*4
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECOCED0
     C                   ENDIF                                                  E*3
     C     #1REFN        READE     SECOCEL0                               89
      *
     C                   ELSE                                                   X*4
     C     #1PTYP        IFEQ      'CR'                                         B*5
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECOCRD0
     C                   ELSE                                                   X*3
     C                   ENDIF                                                  E*3
     C     #1REFN        READE     SECOCRL0                               89
      *
     C                   ELSE                                                   X*5
     C     #1PTYP        IFEQ      'OF'                                         B*6
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECOOFD0
     C                   ENDIF                                                  E*3
     C     #1REFN        READE     SECOOFL0                               89
      *
     C                   ELSE                                                   X*6
     C     #1PTYP        IFEQ      'RG'                                         B*7
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECORGD0
     C                   ENDIF                                                  E*3
     C     #1REFN        READE     SECORGL0                               89
      *
     C                   ELSE                                                   X*7
      *
     C     #1PTYP        IFEQ      'EX'                                         B*8
     C     #1SEL         IFEQ      'D'                                          B*3
     C                   DELETE    SECOEXD0
     C                   ENDIF                                                  E*3
      *
     C     #1REFN        READE     SECOEXL0                               89
      *
     C                   ELSE                                                   X*8
     C     #1PTYP        IFEQ      'NC'                                         B*9
     C     #1SEL         IFEQ      'D'                                          B*10
     C                   DELETE    SECONCD0
     C                   ENDIF                                                  E*10
     C     #1REFN        READE     SECONCL0                               89
      *
     C                   ELSE                                                   X*9
     C     #1PTYP        IFEQ      'NF'                                         B*10
     C     #1SEL         IFEQ      'D'                                          B*11
     C                   DELETE    SECONFD0
     C                   ENDIF                                                  E*11
     C     #1REFN        READE     SECONFL0                               89
      *                                                                   CEU017
     C                   ELSE                                                   X*10           CEU01
     C     #1PTYP        IFEQ      'CC'                                         B*11           CEU01
     C     #1SEL         IFEQ      'D'                                          B*12           CEU01
      *                                                                   CEU017
     C     NABLKR        IFNE      *ZEROS                                       B*13           CEU01
     C                   Z-ADD     *ZEROS        WCOUNT            5 0                         13787
     C                   MOVE      #1REFN        W1REFN            6 0                         13787
      *                                                                   CEU017
     C     NABLKR        SETLL     SECORSL0                                                    CEU01
     C     NABLKR        READE     SECORSL0                               88                   CEU01
     C     *IN88         DOWEQ     '0'                                          B*14           CEU01
     C                   ADD       1             WCOUNT                                        13787
     C     W1REFN        IFEQ      NCCORF                                       B*15           13787
     C     NCRECI        ORNE      'D'                                                         13787
     C                   DELETE    SECORSD0                                                    CEU01
     C                   SUB       1             WCOUNT                                        13787
     C                   ENDIF                                                  E*15           13787
     C     NABLKR        READE     SECORSL0                               88                   CEU01
     C                   ENDDO                                                  E*14           CEU01
      *                                                                   CEU017
     C     WCOUNT        IFEQ      *ZEROS                                                      13787
     C     NABLKR        CHAIN     SECORBL0                           88                       CEU01
     C     *IN88         IFEQ      '0'                                          B*14           CEU01
     C                   DELETE    SECORBD0                                                    CEU01
     C                   ENDIF                                                  E*14           CEU01
     C                   ENDIF                                                                 13787
     C                   ENDIF                                                  E*13           CEU01
      *                                                                   CEU017
     C                   DELETE    SECOCCD0                                                    CEU01
     C                   ENDIF                                                  E*12           CEU01
     C     #1REFN        READE     SECOCCL0                               89                   CEU01
     C/COPY WNCPYSRC,SE7502C062
     C                   ENDIF                                                  E*11           CEU01
     C                   ENDIF                                                  E*10
     C                   ENDIF                                                  E*9
     C                   ENDIF                                                  E*8
     C                   ENDIF                                                  E*7
     C                   ENDIF                                                  E*6
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
      *
     C                   ENDDO                                                  E*1
      *
     C/COPY WNCPYSRC,SE7502C065
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P023  : VIEW/CHANGE OPTION(S)                                 *
      *****************************************************************
      *
     C     P023          BEGSR
      *
     C                   MOVE      'Y'           ERROR
      *
     C     #1COAT        CHAIN     SECOATL0                           89
      *
     C                   MOVE      *BLANKS       WRTCD
      *
     C                   MOVE      #1EXDT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WEXDAT
      *
     C                   MOVE      *BLANKS       WNBOP
     C                   MOVE      #1NBOP        WNBOP             2
     C                   MOVE      #1NBOP        SNBOP             2
      *
     C     MMPTYP        IFEQ      'NF'                                         B*3
     C                   CALL      'SE7510'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1FINA                         Final Allocation Ind
     C                   PARM                    MMPTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    #1SEL                          Action
     C                   PARM                    WRTCD             1            Return Code
     C/COPY WNCPYSRC,SE7502C049
     C                   ELSE                                                   X*3
      *
     C     MMPTYP        IFEQ      'NC'                                         B*4
     C                   CALL      'SE7511'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1FINA                         Final Allocation Ind
     C                   PARM                    MMPTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    #1SEL                          Action
     C                   PARM                    WRTCD             1            Return Code
     C/COPY WNCPYSRC,SE7502C050
     C                   ELSE                                                   X*4
      *                                                                   CEU017
     C     MMPTYP        IFEQ      'CC'                                         B*5            CEU01
     C                   CALL      'SE7520'                             99                     CEU01
     C                   PARM                    #1REFN                         Ref.           CEU01
     C                   PARM                    #1SECN                         Security       CEU01
     C                   PARM                    #1COAT                         Type           CEU01
     C                   PARM                    #1STAT                         Status         CEU01
     C                   PARM                    #1FINA                         Alloc.         CEU01
     C                   PARM                    MMPTYP                         Proc.          CEU01
     C                   PARM                    WEXDAT            5            Ex-Date        CEU01
     C                   PARM                    #1SEL                          Action         CEU01
     C                   PARM                    WRTCD             1            Return         CEU01
     C                   ELSE                                                   X*5            CEU01
     C/COPY WNCPYSRC,SE7502C051
      *
     C******IN46         IFEQ      '1'                                                 245165 247764
     C**********         MOVE      'X'           WRTCD                                 245165 247764
     C**********         END                                                           245165 247764
      *                                                                         215165
     C                   CALL      'SE7599'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1FINA                         Final Allocation Ind
     C                   PARM                    MMPTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    WNBOP                          Number of Options
     C                   PARM                    #1SEL                          Action
     C                   PARM      'E'           WWEVDP            1            Events or Depots
     C                   PARM                    #1TDVD                         Trade/Value Position
     C                   PARM                    WRTCD             1            Return Code
     C                   PARM      ' '           WWREX             1                           13896
     C/COPY WNCPYSRC,SE7502C052
     C                   ENDIF                                                  E*5            CEU01
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
      *
      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
      **         DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'                                          B*3
     C     WRTCD         OREQ      'E'
      *
     C     MMPTYP        IFEQ      'NF'                                         B*4
     C                   MOVEL     NARR(2)       DBKEY            29
     C                   ELSE                                                   X*4
     C     MMPTYP        IFEQ      'NC'                                         B*5
     C                   MOVEL     NARR(3)       DBKEY
     C                   ELSE                                                   X*5
     C     MMPTYP        IFEQ      'CC'                                         B*6            CEU01
     C                   MOVEL     NARR(7)       DBKEY                                         CEU01
     C                   ELSE                                                   X*6            CEU01
     C                   MOVEL     NARR(1)       DBKEY
     C                   ENDIF                                                  E*6            CEU01
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
      *
     C                   MOVEL     '009'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 09 **
     C                   EXSR      *PSSR                                        *****************
     C                   ENDIF                                                  E*3
      *
      **   IF RETURN CODE IS EQUAL TO '2', '3'
      *
     C     WRTCD         IFEQ      '3'                                          B*3
      *
      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C     *IN88         IFEQ      '0'                                          B*4            13787
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C     MACHTP        IFNE      'R'                                          B*5            13787
     C     MASTAT        ANDNE     'R'                                                         13787
     C     MASTAT        ANDNE     'C'                                                         13787
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
     C                   ENDIF                                                  E*5            13787
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
     C                   ENDIF                                                  E*4            13787
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
     C                   ENDIF                                                  E*3
      *
     C     WRTCD         IFEQ      '3'                                          B*4
     C                   MOVE      '1'           *INKC
     C                   ELSE                                                   X*4            13787
     C     WWINPT        IFEQ      'Y'                                          B*5            13787
     C                   MOVE      '1'           *INKL                                         13787
     C                   ENDIF                                                  E*5            13787
     C                   ENDIF                                                  E*4
      *
     C     WNBOP         IFNE      SNBOP                                        B*3
     C***********        MOVE      '0'           *IN45                                        CSE020
     C                   MOVE      '0'           WIN45                                        CSE020
     C                   ENDIF                                                  E*3
     C/COPY WNCPYSRC,SE7502C053
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P024  : VERIFY IF THE OPTION EXISTS                           *
      *****************************************************************
      *
     C     P024          BEGSR
      *
     C                   MOVE      '0'           *IN89
      *
     C     #1PTYP        IFEQ      'DV'                                         B*1
     C     KEY6          CHAIN     SECODVL0                           89
      *
     C                   ELSE                                                   X*1
     C     #1PTYP        IFEQ      'FR'                                         B*2
     C     KEY6          CHAIN     SECOFRL0                           89
      *
     C                   ELSE                                                   X*2
     C     #1PTYP        IFEQ      'CE'                                         B*3
     C     KEY6          CHAIN     SECOCEL0                           89
      *
     C                   ELSE                                                   X*3
     C     #1PTYP        IFEQ      'CR'                                         B*4
     C     KEY6          CHAIN     SECOCRL0                           89
      *
     C                   ELSE                                                   X*4
     C     #1PTYP        IFEQ      'OF'                                         B*5
     C     KEY6          CHAIN     SECOOFL0                           89
      *
     C                   ELSE                                                   X*5
     C     #1PTYP        IFEQ      'RG'                                         B*6
     C     KEY6          CHAIN     SECORGL0                           89
      *
     C                   ELSE                                                   X*6
     C     #1PTYP        IFEQ      'EX'                                         B*7
     C     KEY6          CHAIN     SECOEXL0                           89
     C                   ENDIF                                                  E*7
     C                   ENDIF                                                  E*6
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P025  : CHECK THAT NO POSITION EXISTS ON DEPOT POSITIONS FILE *
      *****************************************************************
      *
     C     P025          BEGSR
      *
     C                   MOVE      '0'           *IN89
      *
     C     #1SEL         IFEQ      'E'                                          B*1
     C     #1REFN        CHAIN     SECODPL1                           89
     C                   ELSE                                                   X*1
     C     #1SEL         IFEQ      'V'                                          B*2
     C     #1REFN        CHAIN     SECOALL1                           89
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C     *IN89         IFEQ      '1'                                          B*1
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00256'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*1
      *
     C     #1SEL         IFEQ      'N'                                          B*1
     C     #1SECN        CHAIN     DPOSS                              89
      *
     C     *IN89         IFEQ      '0'                                          B*2
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00255'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * R001 : POSITION INTO ER REFERENCE FILE                        *
      *****************************************************************
      *
     C     R001          BEGSR
      *
      **   FIRST TIME PROCESSING
      *
     C******IN45*        IFEQ      '0'                                          B*1           CSE020
     C     WIN45         IFEQ      '0'                                                        CSE020
     C     WDMNO         IFEQ      'Y'                                                        CSE020
     C                   Z-ADD     1             W#RRN             6 0                        CSE020
     C     W#RRN         SETLL     SECORFPM                                                   CSE020
     C                   ELSE                                                                 CSE020
     C************LOVAL    SETLLSECORFL1                                  136421
     C     *HIVAL        SETLL     SECORFL9                                                    13642
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                  E*1
      *
      **   ACCESS MUST BE DONE BY 'REFERENCE'
      *
     C     *IN55         IFEQ      '1'                                          B*1
      *
      **   IF ROLLUP
      *
     C     *IN27         IFEQ      '1'                                          B*2
     C***********KREFN     SETGTSECORFL1                                  136421
     C     WDMNO         IFEQ      'Y'                                                        CSE020
     C     W#RRN         SETLL     SECORFPM                                                   CSE020
     C                   ELSE                                                                 CSE020
     C     KREFN         SETGT     SECORFL9                                                    13642
     C                   ENDIF                                                                CSE020
     C                   ELSE                                                   X*2
     C***********KREFN     SETLLSECORFL1                                  136421
     C     WDMNO         IFEQ      'Y'                                                        CSE020
     C     W#RRN         SETLL     SECORFPM                                                   CSE020
     C                   ELSE                                                                 CSE020
     C     KREFN         SETLL     SECORFL9                                                    13642
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                  E*2
      *
     C                   ELSE                                                   X*1
      *
      **   ACCESS MUST BE DONE BY 'SECURITY' AND 'EX-DATE'
      *
     C******IN53*        IFEQ      '1'                                          B*2           CSE020
     C     WIN53         IFEQ      '1'                                          B*2           CSE020
      *
      **   IF ROLLUP
      *
     C     *IN27         IFEQ      '1'                                          B*3
     C     KEY1          SETGT     SECORFL3
     C                   ELSE                                                   X*3
     C     KEY1          SETLL     SECORFL3
     C                   ENDIF                                                  E*3
      *
     C                   ELSE                                                   X*2
      *
      **   ACCESS MUST BE DONE BY 'EX-DATE' AND 'SECURITY'
      *
     C     *IN54         IFEQ      '1'                                          B*3
      *
      **   IF ROLLUP
      *
     C     *IN27         IFEQ      '1'                                          B*4
     C     KEY2          SETGT     SECORFL4
     C                   ELSE                                                   X*4
     C     KEY2          SETLL     SECORFL4
     C                   ENDIF                                                  E*4
      *
     C                   ELSE                                                   X*3
      *
      **   IF ROLLUP IN AMEND/ENQUIRY MODE
      *
     C     *IN27         IFEQ      '1'                                          B*4
      *
     C     *IN43         IFEQ      '1'                                          B*5
     C     *IN61         OREQ      '1'
     C***********KREFN     SETGTSECORFL1                                  136421
     C     WDMNO         IFEQ      'Y'                                                        CSE020
     C     W#RRN         SETLL     SECORFPM                                                   CSE020
     C                   ELSE                                                                 CSE020
     C     KREFN         SETGT     SECORFL9                                                    13642
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * R002 : READ NEXT RECORD OF THE ER REFERENCE FILE              *
      *****************************************************************
      *
     C     R002          BEGSR
      *
      **   ACCESS MUST BE DONE BY 'REFERENCE'
      *
     C     *IN55         IFEQ      '1'                                          B*1
     C******IN45*        OREQ      '0'                                                        CSE020
     C     WIN45         OREQ      '0'                                                        CSE020
     C************         READ SECORFL1                 30               136421
     C     WDMNO         IFEQ      'Y'                                                        CSE020
     C                   READ      SECORFPM                               30                  CSE020
     C                   ADD       1             W#RRN                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   READ      SECORFL9                               30                   13642
     C                   ENDIF                                                                CSE020
     C                   ELSE                                                   X*1
      *
      **   ACCESS MUST BE DONE BY 'SECURITY' AND 'EX-DATE' AND 'REFERENCE'
      *
     C******IN53*        IFEQ      '1'                                          B*2           CSE020
     C     WIN53         IFEQ      '1'                                          B*2           CSE020
     C                   READ      SECORFL3                               30
     C                   ELSE                                                   X*2
      *
      **   ACCESS MUST BE DONE BY 'EX-DATE' AND 'SECURITY' AND 'REFERENCE'
      *
     C     *IN54         IFEQ      '1'                                          B*3
     C                   READ      SECORFL4                               30
     C                   ELSE                                                   X*3
      *
      **   IF ROLLUP IN AMEND/ENQUIRY MODE
      *
     C     *IN27         IFEQ      '1'                                          B*4
      *
     C     *IN43         IFEQ      '1'                                          B*5
     C     *IN61         OREQ      '1'
     C************         READ SECORFL1                 30               136421
     C     WDMNO         IFEQ      'Y'                                                        CSE020
     C                   READ      SECORFPM                               30                  CSE020
     C                   ADD       1             W#RRN                                        CSE020
     C                   ELSE                                                                 CSE020
     C                   READ      SECORFL9                               30                   13642
     C                   ENDIF                                                                CSE020
     C                   ENDIF                                                  E*5
     C                   ENDIF                                                  E*4
     C                   ENDIF                                                  E*3
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C                   ENDSR
      ****************************************************************
     C/COPY WNCPYSRC,SE7502C054
      /EJECT
      *****************************************************************
      * *PSSR - TO PROCESS ABNORMAL END OF PROGRAM                    *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** UPDATE LDA WITH ERROR INFORMATION
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     DBFILE        WWFILE
     C                   MOVEL     DBKEY         WWKEY
     C                   MOVEL     DBPGM         WWPGM
     C                   MOVEL     DBASE         WWASE
     C                   OUT       LDA
      *
      **   ROLLBACK CHANGES, PRINT DUMP AND CANCEL PROGRAM
      *
     C                   ROLBK
     C                   DUMP
      *
      **   TRY TO RELEASE CORPORATE ACTION BY ACCESS TO ER REFERENCE FILE
      **   IF CURRENT ER REFERENCE IS NOT BLANK
      *
     C     #1REFN        IFNE      *BLANKS                                      B*1
     C     #1REFN        SETLL     SECORFL0
     C                   READ      SECORFL0                               89
      *
      **   IF THE RECORD EXISTS
      *
     C     *IN89         IFEQ      '0'                                          B*2
      *
     C/COPY WNCPYSRC,SE7502C055
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
      **   UPDATE THE RECORD
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
     C/COPY WNCPYSRC,SE7502C056
      *
      **   COMMITMENT INSTRUCTION
      *
     C                   COMMIT
     C                   ENDIF                                                  E*2
     C                   ENDIF                                                  E*1
      *
     C/COPY WNCPYSRC,SE7502C057
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C/COPY WNCPYSRC,SE7502C058
     C                   CALL      'DBERRCTL'
     C/COPY WNCPYSRC,SE7502C059
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *  ZASNMS : SEND MESSAGE TO PROGRAM'S MESSAGE QUEUE            *
      ****************************************************************
      *
     C     ZASNMS        BEGSR
      *
      **   message file specified use PMSGF
      *
     C                   MOVEL     PMSGF         ZAMSGF
     C/COPY WNCPYSRC,SE7502C060
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
      **   Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file
     C                   MOVEL     *BLANK        ZAMSID                         Message id.
     C/COPY WNCPYSRC,SE7502C061
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **
      **   ZDATE1 SR. TO VALIDATE DATES SUBMITTED AND
      **              CONVERT TO A NUMBER OF DAYS.
      **
      **   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
      **
     C     ZDATE1        BEGSR                                                  *** ZDATE1 ***
      **
      **   CLEAR DAY NUMBER. RESET ERROR INDICATOR
     C                   Z-ADD     0             ZDAYNO            5 0
     C                   SETOFF                                       99
      **
      **   CALCULATION TO DEFINE INPUT DATE FIELD.
     C                   Z-ADD     ZDATE         ZDATE             6 0
      **
      **   GET INDIVIDUAL DAY, MONTH AND YEAR FIELDS.
     C                   MOVE      ZDATE         ZYEAR             2 0
     C  N98              MOVEL     ZDATE         ZDAY              2 0
     C   98              MOVEL     ZDATE         ZMTH              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C  N98              MOVEL     ZWRK4         ZMTH
     C   98              MOVEL     ZWRK4         ZDAY
      **
      **   ENSURE MONTH IS VALID. BYPASS IF ERROR
     C     ZMTH          IFLE      0
     C     ZMTH          ORGT      12
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
      **   ENSURE DAY IS VALID. BYPASS IF ERROR
     C     ZDAY          IFLE      0
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
      **   CHECK FOR 30 DAY MONTHS. BYPASS IF ERROR
     C     ZMTH          IFEQ      4
     C     ZMTH          OREQ      6
     C     ZMTH          OREQ      9
     C     ZMTH          OREQ      11
      **
     C     ZDAY          IFGT      30
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
     C                   ELSE
      **
      **   CHECK FOR 31 DAY MONTHS (ALL OTHERS BUT FEB). BYPASS IF ERROR
     C     ZDAY          IFGT      31
     C     ZMTH          ANDNE     2
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
     C                   END
      **
      **   CHECK FOR LEAP YEAR: REMAINDER WILL BE ZERO IF IT IS A LEAP YR
     C     ZYEAR         ADD       28            ZYEAR
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0
      **
      **   IF FEBUARY FURTHER VALIDATE DAY.
     C     ZMTH          IFEQ      2
      **
      **   INVALID IF GREATER THAN 28 AND NOT A LEAP YEAR
     C     ZLY           IFGT      0
     C     ZDAY          ANDGT     28
     C                   SETON                                        99
     C                   GOTO      ZDEND1                                       BYPASS IF ERROR
     C                   END
      **
      **   INVALID IF GREATER THAN 29 AND A LEAP YEAR - BYPASS IF ERROR
     C     ZLY           IFEQ      0
     C     ZDAY          ANDGT     29
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
     C                   END
      **
      **   DETERMINE NUMBER OF DAYS FROM 31/12/1971.
      **
      **   MULTIPLY NO. OF FOUR-YEAR SPANS, BY NO. OF DAYS IN SPAN
     C     ZLYR          MULT      1461          ZDAYNO
      **
      **   IF NOT A LEAP YEAR, ADD APPROPRIATE NO. OF DAYS FOR EXTRA
      **   YEARS USING REMAINDER FIELD (IE. 1, 2 OR 3 X 356)
     C     ZLY           IFGT      0
     C     ZDAYNO        ADD       ZYDY(ZLY)     ZDAYNO
     C                   END
      **
      **   IF IT IS A LEAP YEAR, AND LATER THAN FEBRUARY, ADD ONE FOR
      **   29TH OF FEB
     C     ZLY           IFEQ      0
     C     ZMTH          ANDGT     2
     C     ZDAYNO        ADD       1             ZDAYNO
     C                   END
      **
      **   ADD APPROPRIATE NUMBER OF DAYS FOR THE MONTH NUMBER
     C     ZDAYNO        ADD       ZMDY(ZMTH)    ZDAYNO
      **
      **   ADD NUMBER OF DAYS IN MONTH
     C     ZDAYNO        ADD       ZDAY          ZDAYNO
      **
     C     ZDEND1        ENDSR                                                  * ZDEND1 ENDSR*
      **
      ********************************************************************
      **
      **   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
      **
      **   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
      **
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
      **
      **   CLEAR LEAP YEAR WORK FIELD.
     C                   MOVE      'N'           ZLEAP             1
      **
      **   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
      **
      **   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
      **
      **   DETERMINE YEAR NUMBER.
      **
      **   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
      **
      **   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
      **                                                   DAYS
      **   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
      *
     C     ZWRK2         SUB       1             ZWRK2
      **
      **   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
      **
      **   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
      **
      **   DETERMINE MONTH NUMBER.
      **
      **   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
      **
      **   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
      *
     C     ZWRK2         SUB       1             ZWRK2
      **
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
      **
      **   DETERMINE DAY OF MONTH.
      **
      **   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
      **
      **   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
      **
      **   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
      **
      **   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
      **
      **   FORMAT ALPHA DATE, DDMMMYY.
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
      **
     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
      **
      **
      ********************************************************************
      /EJECT
      ********************************************************************
      *    SUBROUTINE- ZNCD
      *    DETERMINE NEXT COUPON DATE
      *
      **
      **  INPUT - CD ARRAY - COUPON DATES - SECTYD SECURITY FILE
      **          CR ARRAY - RATE/PAYT INDICS - SECTYD SECURITY FILE
      **          FCPN - FIRST COUPON DATE - SECTYD SECURITY FILE
      **          MATY - MATURITY DATE - SECTYD SECURITY FILE
      **          ECD - EVENT CONTROL DTAE - ZEVCD PROCESS
      **          *IN98 - DATE FORMAT - FROM TABTC10 RECORD VIA ZSYSTM
      **
      **  OUTPUT - NCD (5,0) - NEXT COUPON DATE
      **
      **  CALLS  - ZDATE1
      **           ZDATE2
      ********************************************************************
      *
     C     ZNCD          BEGSR                                                  *** ZNCD   ***
      *
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         ZZECD4            4 0
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZZECD4        ZZWRKD
     C                   MOVE      ZZECD4        ZZWRKM
     C                   Z-ADD     ZZWRKD        ZZECD4
     C                   MOVEL     ZZWRKM        ZZECD4
     C                   END
      *
      * IF DATE FORMAT IS DDMMYY TURN ROUND ARRAY OF COUPON DATES TO MMDD
     C     *IN98         IFEQ      '0'
     C                   DO        12            X                 2 0
     C                   MOVE      CD(X)         ZZWRKM            2 0
     C                   MOVEL     CD(X)         ZZWRKD            2 0
     C                   Z-ADD     ZZWRKD        CD(X)
     C                   MOVEL     ZZWRKM        CD(X)
     C                   END
     C                   END
      * GET YEAR FOR ECD
     C                   MOVE      ZDATE         ZECDYR            2 0
      *
      * FIND NEXT COUPON DATE FROM ARRAYS -
      *  IF RATE/PAYT INDS ALL BLANK NCD = MATURITY DATE
     C                   Z-ADD     MATY          NCD               5 0
     C     CRDS          IFNE      *BLANKS
      *  IF RATE/PAYT INDS NOT ALL BLANK -
      *    SEARCH FOR NEXT HIGHEST COUPON
     C                   MOVE      '0'           ZFOUND            1
     C                   DO        12            X
     C     CR(X)         IFEQ      'P'
     C     CR(X)         OREQ      'C'
     C     ZZECD4        IFLE      CD(X)
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZNCD00
     C                   END
     C                   END
     C                   END
      *      FOUND - ADD ECD'S YY TO FORM DATE
     C     ZNCD00        TAG                                                    ZNCD00 TAG
     C     ZFOUND        IFEQ      '1'
     C                   Z-ADD     ZECDYR        ZDATE
     C                   MOVEL     CD(X)         ZDATE
      *      NOT FOUND - USE FIRST COUPON
      *                  ADD NEXT YEAR'S YY TO FORM DATE
     C                   ELSE
     C                   DO        12            X
     C     CR(X)         IFEQ      'P'
     C     CR(X)         OREQ      'C'
     C                   Z-ADD     ZECDYR        ZDATE
     C                   ADD       1             ZDATE
     C                   MOVEL     CD(X)         ZDATE
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZNCD01
     C                   END
     C                   END
     C                   END
     C     ZNCD01        TAG                                                    ZNCD01 TAG
      *
      * CONVERT DATE TO DAY NO USING ZDATE1
      * (NOT DONE IF NO RATE/PAYT IND IS P OR C)
      * IF DDMMYY FORMAT TURN ROUND TO MMDDYY
     C     ZFOUND        IFEQ      '1'
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZDATE         ZZWRK             4 0
     C                   MOVE      ZZWRK         ZZWRKM
     C                   MOVEL     ZZWRK         ZZWRKD
     C                   Z-ADD     ZZWRKD        ZZWRK
     C                   MOVEL     ZZWRKM        ZZWRK
     C                   MOVEL     ZZWRK         ZDATE
     C                   END
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        NCD
     C                   END
      *
      * IF NCD > MATURITY DATE , RESET NCD = MATURITY DATE
     C     NCD           IFGT      MATY
     C                   Z-ADD     MATY          NCD
     C                   END
     C                   END
      *
      * If the First Coupon Date is not zero, then
      * IF NCD < 1ST COUPON DATE , RESET NCD = 1ST COUPON DATE
      *
     C     FCPN          IFNE      *ZEROS
     C     NCD           ANDLT     FCPN
     C                   Z-ADD     FCPN          NCD
     C                   END
      *
      * IF DATE FORMAT IS DDMMYY TURN BACK ARRAY OF COUPON DATES TO DD/MM
     C     *IN98         IFEQ      '0'
     C                   DO        12            X                 2 0
     C                   MOVEL     CD(X)         ZZWRKM            2 0
     C                   MOVE      CD(X)         ZZWRKD            2 0
     C                   Z-ADD     ZZWRKM        CD(X)
     C                   MOVEL     ZZWRKD        CD(X)
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*/COPY ZSRSRC,ZALIGNZ2
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  ZALIGNZ2 - To validate and right align numeric fields        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Any changes made to this /COPY member may also need to be    *
      *  incorporated in ZALIGNZ2L.                                   *
      *                                                               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. Xnnnnn  *CREATE    Date ddmmmyy               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
     C********************************************************************
     C**
     C**   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
     C**
     C     ZALIGN        BEGSR                                                  *** ZALIGN ***
     C**
     C                   SETOFF                                       929399
     C**
     C**   SAVE INPUT FIELD IN ARRAY, ZA1.
     C                   MOVEA     ZFIELD        ZA1
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD           16
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
     C**
     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
     C     ZADIG         ADD       ZADEC         ZZ                2 0
     C     ZZ            COMP      15                                 99
     C   99              GOTO      ZAEND
     C**
     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
     C     ZATAG1        TAG                                                    ** ZATAG1 TAG *
     C     ZX            ADD       1             ZX
     C**
     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND
     C**
     C**
     C**   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'M'                                    96
     C   96              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      9                                  99
     C   99              GOTO      ZAEND
     C                   END
     C**
     C**   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'T'                                    97
     C   97              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      12                                 99
     C   99              GOTO      ZAEND
     C                   END
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZA1
     C   96
     COR 97              MOVE      ' '           ZA1(ZX)
     C**
     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2
     C**
     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND                                        NOT NUMERIC
     C**
     C**   STORE DIGITS IN ARRAY AND HOW MANY.
     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
     C**   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93
     C**
     C     ZX            COMP      16                                   94      CHECK IF ALL
     C   94              GOTO      ZATAG1
     C**
     C     ZATAG2        TAG                                                    ** ZATAG2 TAG *
     C**
     C**   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
     C   96ZZ            ADD       6             ZZ
     C**
     C**   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
     C   97ZZ            ADD       3             ZZ
     C**
     C**   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
     C**
     C**   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
     C**
     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
     C**
     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
     C  N93              Z-ADD     ZY            ZZ
     C**
     C**   CHECK FOR EMBEDDED BLANKS.
     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND                                        EMBEDDED BLANK
     C**
     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4                                       NO TRAILING
     C**                                                   BLANKS.
     C**   FILL THE TRAILING BLANKS WITH ZEROS.
     C     ZY            ADD       ZX            ZZ
     C     ZATAG3        TAG                                                    ** ZATAG3 TAG *
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3
     C**
     C**   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
     C     ZATAG4        TAG                                                    ** ZATAG4 TAG *
     C                   MOVE      '0'           ZA1
     C                   Z-ADD     16            ZX
     C     ZATAG5        TAG                                                    ** ZATAG5 TAG *
     C     ZY            COMP      0                                      94
     C   94              GOTO      ZATAG6
     C                   MOVE      ZA2(ZY)       ZA1(ZX)
     C     ZY            SUB       1             ZY
     C     ZX            SUB       1             ZX
     C                   GOTO      ZATAG5
     C     ZATAG6        TAG                                                    ** ZATAG6 TAG *
     C**
     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
     C                   MOVEA     ZA1           ZFIELD
     C**
     C                   SETOFF                                       9697
     C**
     C     ZAEND         ENDSR                                                  * ZAEND ENDSR *
     C**
     C**
     C********************************************************************
      /EJECT
     C*/COPY ZSRSRC,ZASIGNZ2
     C********************************************************************
     C**                                                                 *
     C** ZASIGN subroutine to validate and right-align signed numeric    *
     C** fields                                                          *
     C**     Input fields:   ZFLD17 17/                                  *
     C**                     ZSDIG  2/0                                  *
     C**                     ZSDEC  1/0                                  *
     C**                     ZSDCSP 1                                    *156689
     C**                                                                 *
     C**     Arrays:         ZS3    17/1/                                *
     C**                     ZS4    15/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT15 15/                                  *
     C**                     ZFSIGN  1/                                  *
     C**                                                                 *
     C** ID F  C  H  L    FUNCTION OF INDICATORS
     C**
     C**       90         Decimal point found
     C**       91         Blank character found
     C**       92         After 1st time pass
     C**       93         Decimal point processed
     C**       95         No trailing blanks after decimal point position
     C**       96         Character 'M' found
     C**       97         Character 'T' found
     C**       99         SR ended abnormally - data invalid
     C**                                                                 *
     C********************************************************************
     C*                                                                  *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     C*  LAST AMEND NO. 156689             DATE  08MAR99                 *
     C*  PREV AMEND NO. S01176             DATE 17/08/88                 *
     C*                                                                  *
     C*------------------------------------------------------------------*
     C*                                                                  *
     C*  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR    *
     C*  S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                     *S01176
     C*                                                                  *
     C********************************************************************
     C**
     CSR   ZASIGN        BEGSR                                                  *** ZASIGN ***
     C**
     C                   SETOFF                                       929399
     C**
     C**   SAVE INPUT FIELD IN ARRAY, ZS3.
     C**
     C                   MOVEA     ZFLD17        ZS3
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C**
     C                   Z-ADD     ZSDIG         ZSDIG             2 0
     C                   Z-ADD     ZSDEC         ZSDEC             1 0
     C**                                                                  156689
     C**   DECIMAL SEPARATOR                                              156689
     C     ZSDCSP        IFEQ      *BLANK                                                      15668
     C                   MOVEL     '.'           ZSDCSP            1                           15668
     C                   ENDIF                                                                 15668
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C**
     C                   MOVE      ' '           ZS4
     C                   MOVEA     ZS4           ZFLD17           17
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
     C                   MOVE      ' '           ZFSIGN            1
     C**
     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
     C**
     C     ZSDIG         ADD       ZSDEC         ZSINT             2 0
     C     ZSINT         CABGT     15            ZSEND                99
     C**
     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
     C**
     C                   DO        17            ZX
     C**
     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
     C**
     C***********ZS3,ZX    COMP '.'                      90               156689
     C     ZS3(ZX)       COMP      ZSDCSP                                 90                   15668
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZSEND
     C**
     C**   Check for 'M' constant. Error if not followed by '+', '-' or
     C**   blank.
     C**
     C     ZS3(ZX)       COMP      'M'                                    96
     C     *IN96         IFEQ      '1'
     C     ZX            CABGT     9             ZSEND                99
     C                   ADD       1             ZX
     C     ZS3(ZX)       IFNE      ' '
     C     ZS3(ZX)       ANDNE     '+'
     C     ZS3(ZX)       ANDNE     '-'
     C                   SETON                                        99
     C                   GOTO      ZSEND
     C                   END
     C                   SUB       1             ZX
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C**
     C** Fetch next arry element to check for '+' or '-' and bypass
     C** embedded blank edit as 'M' now replaced by ' '
     C**
     C                   ADD       1             ZX
     C                   END
     C**
     C**   Check for 'T' constant. Error if not followed by '+', '-' or
     C**   blank.
     C**
     C     ZS3(ZX)       COMP      'T'                                    97
     C     *IN97         IFEQ      '1'
     C     ZX            CABGT     12            ZSEND                99
     C                   ADD       1             ZX
     C     ZS3(ZX)       IFNE      ' '
     C     ZS3(ZX)       ANDNE     '+'
     C     ZS3(ZX)       ANDNE     '-'
     C                   SETON                                        99
     C                   GOTO      ZSEND
     C                   END
     C                   SUB       1             ZX
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C**
     C** Fetch next arry element to check for '+' or '-' and bypass
     C** embedded blank edit as 'T' now replaced by ' '
     C**
     C                   ADD       1             ZX
     C                   END
     C**
     C**   Check for '-' constant. Error if not followed by blank
     C**
     C     ZS3(ZX)       IFEQ      '-'
     C     ZX            IFLT      17
     C                   ADD       1             ZX
     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
     C                   SUB       1             ZX
     C                   END
     C**
     C** Place '-' in output sign field
     C**
     C                   MOVE      '-'           ZFSIGN
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C**
     C                   END
     C**
     C**   Check for '+' constant. Error if not followed by blank
     C**
     C     ZS3(ZX)       IFEQ      '+'
     C                   ADD       1             ZX
     C     ZX            IFLE      17                                                          S0117
     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
     C                   END                                                                   S0117
     C                   SUB       1             ZX
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C                   END
     C**
     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C**
     C   96
     COR 97              SUB       1             ZX
     C     ZS3(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZSTAG1
     C**
     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C**
     C  N90
     CANN91ZS3(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZS3(ZX)       COMP      '9'                                99
     C   99              GOTO      ZSEND
     C**
     C**   STORE DIGITS IN ARRAY AND HOW MANY.
     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
     C**   ZSINT, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C**
     C  N90
     CANN91              ADD       1             ZY                   92
     C     ZY            IFLE      15                                                          S0117
     C  N90
     CANN91              MOVE      ZS3(ZX)       ZS4(ZY)
     C                   END                                                                   S0117
     C   90              Z-ADD     ZY            ZSINT                93  93
     C**
     C** End of array read loop.
     C**
     C                   END
     C**
     C     ZSTAG1        TAG                                                    ** ZSTAG1 TAG *
     C**
     C**   IF 'M' SPECIFIED, MULTIPLY ZS3 BY 1 MILLION
     C**
     C     *IN96         IFEQ      '1'
     C                   ADD       6             ZSINT
     C                   ADD       6             ZSDIG
     C                   END
     C**
     C**   IF 'T' SPECIFIED, MULTIPLY ZS3 BY 1 THOUSAND
     C**
     C     *IN97         IFEQ      '1'
     C                   ADD       3             ZSINT
     C                   ADD       3             ZSDIG
     C                   END
     C**
     C**   IF CONSTANT SPECIFIED, MULTIPLY BY RESPECTIVE AMOUNT
     C**
     C   96              DO        6
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
     C**
     C   97              DO        3
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
     C**
     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZSINT
     C**
     C  N93              Z-ADD     ZY            ZSINT
     C**
     C**   CHECK FOR EMBEDDED BLANKS.
     C**
     C                   MOVE      *BLANKS       ZFLD17
     C   91
     CAN 92              MOVEA     ZS3(ZX)       ZFLD17
     C   91
     CAN 92ZFLD17        CABNE     ' '           ZSEND                9999
     C**
     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C**
     C     ZSINT         COMP      ZSDIG                              99
     C     ZY            SUB       ZSINT         ZX
     C  N99ZSDEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZSEND
     C   95              GOTO      ZSTAG2
     C**
     C**   FILL THE TRAILING BLANKS WITH ZEROS.
     C**
     C                   DO        ZX
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
     C**
     C**   RIGHT-ALIGN THE VALUE BY MOVING TO ARRAY, ZS5.
     C**
     C     ZSTAG2        TAG                                                    ** ZSTAG2 TAG *
     C                   MOVE      '0'           ZS5
     C                   Z-ADD     15            ZX
     C                   Z-ADD     16            ZY
     C                   DO        16
     C     ZS4(ZY)       IFNE      ' '
     C                   MOVE      ZS4(ZY)       ZS5(ZX)
     C                   SUB       1             ZX
     C                   END
     C                   SUB       1             ZY
     C                   END
     C**
     C**   Replace leading blanks with zeros.
     C**
     C                   Z-ADD     1             ZX
     C                   DO        15
     C     ZS5(ZX)       IFEQ      ' '
     C                   MOVE      '0'           ZS5(ZX)
     C                   ADD       1             ZX
     C                   ELSE
     C                   GOTO      ZSTAG3
     C                   END
     C                   END
     C**
     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFLD17.
     C**
     C     ZSTAG3        TAG                                                    ** ZSTAG3 TAG *
     C                   MOVEA     ZS5           ZOUT15           15
     C**
     C**   If output sign field is not -ive, make +ive.
     C**
     C     ZFSIGN        IFNE      '-'
     C                   MOVE      '+'           ZFSIGN
     C                   END
     C**
     C                   SETOFF                                       9697
     C**
     CSR   ZSEND         ENDSR                                                  * ZSEND ENDSR *
     C*****************************************************************
      /EJECT
     C*/COPY ZSRSRC,ZSEDITZ3
     C********************************************************************
     C********************************************************************
     C**                                                                 *
     C** ZSEDIT subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('J', 'L' or blank)              *
     C**                                                                 *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    21/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT21 21                                   *
     C**                                                                 *
     CSR   ZSEDIT        BEGSR                                                  **  ZSEDIT   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT21           21
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(21)
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        WORK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     22            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      22
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT21
     C*
     CSR                 ENDSR
     C*****************************************************************
      /EJECT
     C*/COPY ZSRSRC,ZACCH
      /EJECT
      *****************************************************************
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. 154799             Date 24Feb99               *
      *   Prev Amend No 115603                Date 23APR97
      *---------------------------------------------------------------*
      *  154799 - Array index error                                   *
      *           Restore DGJDNB and DGDDNB from ZSJAN and ZSDCM as   *
      *           they may have been changed by other SR(ZF2C).       *
      *           Applied fix 115603.                                 *
      *   115603  - ARRAY INDEX ERROR
      *             RESTORE DGJDNB AND DGDDNB FROM ZSJAN AND ZSDCM AS THEY MAY
      *             HAVE BEEN CHANGED BY OTHER SR(ZF2C)
      *****************************************************************
     C     ZACCH         BEGSR
      *
      * This standard sub-routine is to be used in conjunction with
      * the holiday standard sub-routines. Its function is to
      * determine if the access program AOHOLS0 needs to be called and
      * sets up the holiday record appropriately. It is common to all
      * the new holiday sub-routines, but should only be included in
      * a program once, using /COPY.
      *
      *
      * If stored parameters from last call are not within the same
      * bounds - ie. same ccy/location and date is within 1st. Jan &
      * 31st. Dec of current holiday record - continue processing.
      *
      **
      *Define input parameters
      **
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3
     C                   MOVE      ZOPTN         ZOPTN             7
     C*
     C     ZOPTN         IFEQ      '*FREE  '                                      IF 2
     C*
     C                   CALL      'AOHOLS0'
     C                   PARM      *BLANK        RTNCD
     C                   PARM                    ZOPTN
     C                   PARM      ZCCY          ZZCCY
     C                   PARM      ZLOC          ZZLOC
     C                   PARM      ZDAYNO        ZZDYNO
     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B
     C*
     C                   ELSE                                                                  S0119
     C*
     C     ZCCY          IFNE      ZSCCY                                        IF 1
     C     ZLOC          ORNE      ZSLOC                                         OR
     C     ZDAYNO        ORLT      ZSJAN                                         OR
     C     ZDAYNO        ORGT      ZSDCM                                         OR
      *
      * Get appropriate holiday record
      *
     C                   CALL      'AOHOLS0'
     C                   PARM      *BLANK        RTNCD
     C                   PARM                    ZOPTN
     C                   PARM      ZCCY          ZZCCY
     C                   PARM      ZLOC          ZZLOC
     C                   PARM      ZDAYNO        ZZDYNO            5 0
     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B
      *
      * If no record was found, assume all days in year are working
      * days.
      *
     C     RTNCD         IFEQ      '*NRF   '                                      IF 2
      *
     C                   MOVE      *ALL' '       ZHL
      *
      * Save 1st. Jan/31st. Dec dates as input date as we cannot say
      * anything about this year in future calls.
      *
     C                   Z-ADD     ZDAYNO        ZSJAN
     C                   Z-ADD     ZDAYNO        ZSDCM
      *
     C                   ELSE                                                     ELSE 2
      *
      * Save 1st. Jan/31st. Dec for future calls
      *
     C                   Z-ADD     DGJDNB        ZSJAN
     C                   Z-ADD     DGDDNB        ZSDCM
      *
      * Left adjust the holiday array over FEB 29th if the
      * holiday record is not for a leap year.
      *
     C                   MOVE      DGYRNB        Z@YR              4 0
     C     Z@YR          DIV       4             Z@WK1             4 0
     C                   MVR                     Z@WK2             4 0
     C*
     C     Z@WK2         IFNE      0
     C*
     C                   MOVEA     ZHL           ZHL1
     C                   MOVEA     ZHL1(61)      ZHL(60)
     C*
     C                   END
     C*
     C                   END                                                      FI 2
      *
      * Save currency and location for future calls. Need to save
      * return code as well.
      *
     C                   MOVE      ZCCY          ZSCCY
     C                   MOVE      ZLOC          ZSLOC
     C                   MOVE      RTNCD         ZSRTN
      *
     C                   ELSE                                                   ELSE 1
      *
      * Move saved return code back again as there may have been no
      * record found last time.
      *
     C**********           Z-ADDZSJAN     DGJDNB                          115603
     C**********           Z-ADDZSDCM     DGDDNB                          115603
     C                   Z-ADD     ZSJAN         DGJDNB                                        15479
     C                   Z-ADD     ZSDCM         DGDDNB                                        15479
     C                   MOVE      ZSRTN         RTNCD
      *
     C                   END                                                    FI 1
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
     C*/COPY ZSRSRC,ZCHKH
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  ZCHKH - Check if Holiday for Ccy/Locn                        *
      *                                                               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. 151295  *CREATE    Date ddmmmyy               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  151295 - Problems authorising repayment schedules.           *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
     C     ZCHKH         BEGSR
      **
      *Define input parameters
      **
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3
      **
      *Define output parameter
      **
     C                   MOVE      ZIND          ZIND              1
      *
      * Standard sub-routine to determine if a MIDAS day no. is a
      * holiday or working day for a given currency and (optionally)
      * location.
      * NB. This sub-routine must be used in conjunction with ZACCH.
      *
      * Access holiday record.
      *
      *
     C                   MOVE      '*SETGT '     ZOPTN
     C                   EXSR      ZACCH
      *
      * If no record was found then all days for year are assumed to be
      * working days, so set holiday indicator appropriately.
      *
     C     RTNCD         IFEQ      '*NRF   '                                    IF 1
      *
     C                   MOVE      'W'           ZIND
      *
     C                   ELSE                                                   ELSE 1
      *
      * Subtract 1st. Jan date from given date and add 1 to give the
      * nth day in the year (ZINDX).
      *
     C     ZDAYNO        IFGT      ZSJAN                                                       15129
     C     ZDAYNO        SUB       ZSJAN         ZINDX                                         15129
     C                   ADD       1             ZINDX                                         15129
     C                   ELSE                                                                  15129
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
     C                   ENDIF                                                                 15129
      *
      * Move the nth day in the year value to the holiday indicator
      *
     C                   MOVE      ZHL(ZINDX)    ZIND
      *
      * If holiday indicator is 'X' change to 'H' to show holiday
      *
     C     ZIND          IFEQ      'X'                                           IF 2
     C                   MOVE      'H'           ZIND
     C                   ELSE
     C                   MOVE      'W'           ZIND
     C                   END                                                     FI 2
      *
     C                   END                                                    FI 1
      *
     C                   ENDSR
      *
      *****************************************************************
      * End of /COPY ZCHKH                                            *
      *****************************************************************
      /EJECT
      *
     C/EJECT
      *****************************************************************
**CTDATA ZYDY
0366073110961461
**CTDATA ZMDY
000031059090120151181212243273304334365
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA TXT
F3=Exit  F5=Refresh Screen  F11=View Option(s) Rollup/Rolldown
F3=Exit  F5=Refresh Screen  F9=Go to 'Change' Mode  Rollup/Rolldown
F3=Exit  F5=Refresh Screen  F9=Go to 'Add' Mode  Rollup/Rolldown
F3=Exit  F11=View Option(s)  F12=Previous
F3=Exit  F11=Change Option(s)  F12=Previous
F3=Exit  F12=Previous
F3=Exit  F11=View Option(s)    F12=Previous  F8=Subordinate Action                            CSE020
F3=Exit  F11=Change Option(s)  F12=Previous  F8=Subordinate Action                            CSE020
F3=Exit  F5=Refresh  F9=Go to 'Add' Mode  Rollup/Rolldown  F12=Parent Action                  CSE020
F3=Exit  F5=Refresh  F9=Go to Change Mode  Rollup/Rolldown  F12=Parent Action                 CSE020
**CTDATA NARR
ERROR CALL PGM 'SE7599'
ERROR CALL PGM 'SE7510'
ERROR CALL PGM 'SE7511'
OPTION SHORTNAME NUMBER
ERROR CALL PGM 'SE7512'
ERROR CALL PGM 'SE7514'
ERROR CALL PGM 'SE7520'                                                   CEU017
ERROR CALL PGM 'SE7533'
ERROR CALL PGM 'SE7540'
