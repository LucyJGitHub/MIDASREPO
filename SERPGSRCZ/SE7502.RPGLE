000100200529     H DEBUG
000200200529      *****************************************************************
000300200529/*STD *  RPGBASEMOD                                                   *
000400200529/*EXI *  TEXT('Midas SE Corporate actions events maintenance')        *
000500200529/*OVRF*: OVRDBF FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)              : *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SE7502 - SE Corporate Actions Events Maintenance             *
001100200529      *                                                               *
001200200529      *  (c) Finastra International Limited 2001                      *
001300200529      *                                                               *
001600200619      *  Last Amend No. MD046248           Date 27Oct17               *
001700200619      *  Prev Amend No. CLE134             Date 01Aug12               *
001800200529      *                 CER059             Date 19Jul10               *
001900200529      *                 CER020             Date 19May08               *
002000200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002100200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002200200529      *                 247764             Date 12Jun07               *
002300200529      * Midas Plus 1.4 Base ------------------------------------------*
002400200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002500200529      *                 CSD031             Date 10Apr06               *
002600200529      *                 CSD027             Date 28Dec05               *
002700200529      *                 CGL031             Date 05Jul04               *
002800200529      *                 CSE071             Date 19Jul05               *
002900200529      *                 215168             Date 26Mar03               *
003000200529      *                 215165             Date 24Mar03               *
003100200529      *                 BUG2686            Date 31May04               *
003200200529      *                 CGL029             Date 01Sep03               *
003300200529      *                 208241             Date 17Jan03               *
003400200529      * Midas Release 4 --------------- Base -------------------------*
003500200529      *                 190204             Date 31May01               *
003600200529      *                 CSE016             Date 10Jan01               *
003700200529      * Midas DBA 3.05 -----------------------------------------------*
003800200529      * Midas DBA 3.04 -----------------------------------------------*
003900200529      * Midas DBA 3.03 -----------------------------------------------*
004000200529      *                 CSE020             Date 21Mar00               *
004100200529      * Midas DBA 3.02 -----------------------------------------------*
004200200529      * Midas DBA 3.00 ---------------- Base -------------------------*
004300200529      *                 156687             Date 08Mar99               *
004400200529      *                 155622             Date 22Feb99               *
004500200529      *                 148743             Date 25Nov98               *
004600200529      *                 137884             Date 20Jul98               *
004700200529      *                 149983             Date 10Dec98               *
004800200529      *                 138962             Date 13Aug98               *
004900200529      *                 137879             Date 01Jul98               *
005000200529      *                 136933             Date 25Jun98               *
005100200529      *                 136930             Date 17Jun98               *
005200200529      *                 136428             Date 15Jun98               *
005300200529      *                 136420             Date 11Jun98               *
005400200529      *                 136421             Date 08JUN98               *
005500200529      *                 136419             Date 05Jun98               *
005600200529      *                 CEU017             Date 24Feb98               *
005700200529      *                 CSE007             Date 01Aug97               *
005800200529      *                                                               *
005900200529      *---------------------------------------------------------------*
006000200529      *                                                               *
006400200529      *  MD046248 - Finastra Rebranding                               *
006500200529      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
006600200529      *  CER059 - German Feature Upgrade to Delhi                     *
006700200529      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
006800200529      *           Midas Plus (Recompile)                              *
006900200529      *  247764 - Database Error on Corporate Action Screen.  Apply   *
007000200529      *           UBS-MAD local fix 221720.                           *
007100200529      *  221720 - Looping and other numerous problems caused by fix   *
007200200529      *           215165. Fix is to revert fix 215165 and create a new*
007300200529      *           fix for that error.                                 *
007400200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
007500200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
007600200529      *  CGL031 - Taxation of Savings Income                          *
007700200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
007800200529      *  215168 - Not able to '?' on security and corporate action    *
007900200529      *           type field. Fix is to call SE0043 and SE7501S if '?'*
008000200529      *           is issued in these fields.                          *
008100200529      *  215165 - No Option shortname If option = 1 in Input          *
008200200529      *  BUG2686- Check whether lock job is active then update        *
008300200529      *           file SECOFRPD if not.                               *
008400200529      *  CGL029 - Increase Account Code to 10 digits                  *
008500200529      *  208241 - Recompiled over changed /CPY ZSDESCZ3.              *
008600200529      *  190204 - Recompiled due to changes in PF/SECODVPD.           *
008700200529      *  CSE016 - Extended Security Descriptions                      *
008800200529      *  CSE020 - Corporate Actions Domino Effect Processing          *
008900200529      *  156687 - Corporate Actions: Keep the lock on reference when  *
009000200529      *           pressing F11 - Change Option(s).                    *
009100200529      *  155622 - Corporate Actions:                                  *
009200200529      *           1. Review setup of default values for fields Market *
009300200529      *              Cum Price and Market Ex-Price.                   *
009400200529      *           2. General Information Screen not validated in input*
009500200529      *  148743 - Corporate Actions: Add Rights Tradable fields to    *
009600200529      *           link 'FR' Corporate Action with 'EX' Corporate      *
009700200529      *           Action.                                             *
009800200529      *  137884 - Corporate Actions: Cash fields can be changed even  *
009900200529      *           if the Corporate action is stock authorised.        *
010000200529      *  149983 - EMU: Block OLD Security for Sale as well            *
010100200529      *  138962 - Corporate Actions: various errors:                  *
010200200529      *           1. When Corporate Type Exercises and Conversion     *
010300200529      *              linked to Dividend Events or Right Issues was    *
010400200529      *              creatyed using amendments on Dividend Events or  *
010500200529      *              Rights Issues Option, this new Corporate         *
010600200529      *              Exercises and Conversions did not appeared, so   *
010700200529      *              refresh subfile with using new parameter         *
010800200529      *              transmited between programs.                     *
010900200529      *           2. Review Reverse processing: reverse CO Blocked    *
011000200529      *              Positions.                                       *
011100200529      *           3. When a Corporate Action type 'DV' or 'RG' is     *
011200200529      *              linked with a Corporate Action type 'EX':        *
011300200529      *              - Delete of 'DV' or 'RG' only authorised if 'EX' *
011400200529      *                is deleted.                                    *
011500200529      *              - Reverse of 'DV' or 'RG' only authorised if     *
011600200529      *                'EX' linked is reversed.                       *
011700200529      *              - When user want to delete or reverse an 'EX', a *
011800200529      *                warning message is send on confirmation screen *
011900200529      *                to inform that this CO is linked to a 'DV' or  *
012000200529      *                'RG' and setup 'Rights' fields of 'DV' or 'RG' *
012100200529      *                if status neither 'C' nor 'X' nor 'S'.         *
012200200529      *           4. Correct bad command line in Confirmation screen, *
012300200529      *              F11 not allowed, only F3 and F12 allowed.        *
012400200529      *  137879 - Amend Review from processing, if Status and/or CO   *
012500200529      *           Type selected and roll up, the next pages shown all *
012600200529      *           Status and/or CO Type.                              *
012700200529      *         - When F9 key is pressed after an enquiry of a ref.   *
012800200529      *           with status 'R' or 'C', all fields in subfile was   *
012900200529      *           protect.                                            *
013000200529      *         - Review 'Deletion' and 'Reversal' processing for     *
013100200529      *           Currency Change Events (Processing Type 'CC').      *
013200200529      *         - When entering a new Corporate Action using F9 from  *
013300200529      *           the maintenance screen, ENTER should take you to the*
013400200529      *           general details screen, NOT back to the maintenance *
013500200529      *           screen.                                             *
013600200529      *  136933 - Block OLD Security from the allocation effective    *
013700200529      *           Date when generating the 'CC' events.               *
013800200529      *  136930 - EMU and Corporate Actions: various errors:          *
013900200529      *           - Amend selection if Review from Reference,         *
014000200529      *             Security and Ex-Date fields blanks and Review     *
014100200529      *             from CO Type and/or Status entered: nothing was   *
014200200529      *             selected, reposition at beginning of file.        *
014300200529      *  136428 - Recompile due to addition of Days Basis and Divisor *
014400200529      *           Basis field in SECORBPD.                            *
014500200529      *  136420 - Add the link between the Bulk Reference and the     *
014600200529      *           Corporate Action Reference(s) linked to the Bulk    *
014700200529      *  136421 - To show the the action in decsending order, so that *
014800200529      *           the latest action always on top.                    *
014900200529      *  136419 - Multiple securities can be redenominated in one     *
015000200529      *           New Security. Input of Currency Events (CC) now     *
015100200529      *           not allowed in 'Corporate Action Events Maintenance'*
015200200529      *           program                                             *
015300200529      *  CEU017 - Securities Redenomination Euro Changes              *
015400200529      *  CSE007 - Corporate Actions.                                  *
015500200529      *                                                               *
015600200529      *****************************************************************
015700200529      /EJECT
015800200529      *
015900200529      **   MA - SE CORPORATE ACTIONS References - Upd Idx
016000200529     FSECORFL0  UF A E           K DISK
016100200529     F                                     INFSR(*PSSR)
016200200529     F                                     COMMIT
016300200529      *
016400200529      **   MU - SE CORPORATE ACTIONS Blocked Positions
016500200529     FSECOBKL1  UF   E           K DISK
016600200529     F                                     INFSR(*PSSR)
016700200529     F                                     COMMIT
016800200529      *
016900200529      **  MQ - SE CORPORATE ACTIONS Customer/Book Reply
017000200529     FSECOREL0  UF A E           K DISK
017100200529     F                                     INFSR(*PSSR)
017200200529     F                                     COMMIT
017300200529      *
017400200529      **  MP - SE CORPORATE ACTIONS Reply History file-Detail
017500200529     FSECORHL0  UF A E           K DISK    INFSR(*PSSR)
017600200529     F                                     COMMIT
017700200529      *
017800200529      **   MU - SE CORPORATE ACTIONS Blocked Positions
017900200529     FSECOBKL2  UF A E           K DISK
018000200529     F                                     RENAME(SECOBKD0:SECOBKD2)
018100200529     F                                     INFSR(*PSSR)
018200200529     F                                     COMMIT
018300200529      *
018400200529      **   MA - SE CORPORATE ACTIONS References - Rtv Idx
018500200529     F*SECORFL1IF*E***********K********DISK                               136421
018600200529     FSECORFL9  IF   E           K DISK                                         136421
018700200529     F                                     RENAME(SECORFD0:SECORFD1)
018800200529     F                                     INFSR(*PSSR)
018900200529      *
019000200529      **   MA - SE CORPORATE ACTIONS References - Rtv Idx by SESN+COEX+CORF
019100200529     FSECORFL3  IF   E           K DISK
019200200529     F                                     RENAME(SECORFD0:SECORFD3)
019300200529     F                                     INFSR(*PSSR)
019400200529      *
019500200529      **   MA - SE CORPORATE ACTIONS References - Rtv Idx by COEX+SESN+CORF
019600200529     FSECORFL4  IF   E           K DISK
019700200529     F                                     RENAME(SECORFD0:SECORFD4)
019800200529     F                                     INFSR(*PSSR)
019900200529      *
020000200529      **   Securities Details
020100200529     FSECTYZ1   IF   E           K DISK
020200200529     F                                     INFSR(*PSSR)
020300200529      *                                                                   155622
020400200529      **   Market Prices                                                  155622
020500200529     FPRICM     IF   E           K DISK                                         155622
020600200529     F                                     INFSR(*PSSR)                         155622
020700200529      *
020800200529      **   Investment Types Details
020900200529     FINVTP     IF   E           K DISK
021000200529     F                                     INFSR(*PSSR)
021100200529      *
021200200529      **   Security Events by Type
021300200529     FSECED     IF   E           K DISK
021400200529     F                                     INFSR(*PSSR)
021500200529      *
021600200529      **   MM - SE CORPORATE ACTIONS Types
021700200529     FSECOATL0  IF   E           K DISK
021800200529     F                                     INFSR(*PSSR)
021900200529      *
022000200529      **   MN - SE Option Narrative Code
022100200529     FSECONAL0  IF   E           K DISK
022200200529     F                                     INFSR(*PSSR)
022300200529      *
022400200529      **   MA - SE CORPORATE ACTIONS Reference Number
022500200529     FSECORFPA  UF A E           K DISK
022600200529     F                                     INFSR(*PSSR)
022700200529     F                                     COMMIT
022800200529      *
022900200529      **   MB - SE CORPORATE ACTIONS Depots - Rtv Idx
023000200529     FSECODPL1  IF   E           K DISK
023100200529     F                                     RENAME(SECODPD0:SECODPD1)
023200200529     F                                     INFSR(*PSSR)
023300200529      *
023400200529      **   SE Depot Positions by Security
023500200529     FDPOSS     IF   E           K DISK
023600200529     F                                     RENAME(DPOSNDF:DPOSSDF)
023700200529     F                                     INFSR(*PSSR)
023800200529      *
023900200529      **   MC - SE CORPORATE ACTIONS Allocation - Rtv Idx
024000200529     FSECOALL1  IF   E           K DISK
024100200529     F                                     RENAME(SECOALD0:SECOALDU)
024200200529     F                                     INFSR(*PSSR)
024300200529      *
024400200529      **   MB - SE CORPORATE ACTIONS Depots - Upd Idx
024500200529     FSECODPL0  UF A E           K DISK
024600200529     F                                     INFSR(*PSSR)
024700200529     F                                     COMMIT
024800200529      *
024900200529      **   MS - SE CORPORATE ACTIONS Depots Reference
025000200529     FSECODRL1  IF   E           K DISK
025100200529     F                                     RENAME(SECODRD0:SECODRD1)
025200200529     F                                     INFSR(*PSSR)
025300200529      *
025400200529      **   MC - SE CORPORATE ACTIONS Allocation - Upd Idx
025500200529     FSECOALL0  UF A E           K DISK
025600200529     F                                     INFSR(*PSSR)
025700200529     F                                     COMMIT
025800200529      *
025900200529      **   Midas Corporate Actions - Depots Update index
026000200529     FSECODRL0  UF A E           K DISK
026100200529     F                                     INFSR(*PSSR)
026200200529     F                                     COMMIT
026300200529      *
026400200529      **   MD - SE Corporate Actions - Dividends Events
026500200529     FSECODVL0  UF A E           K DISK
026600200529     F                                     INFSR(*PSSR)
026700200529     F                                     COMMIT
026800200529      *
026900200529      **   ME - SE Corporate Actions - Free Allocations
027000200529     FSECOFRL0  UF A E           K DISK
027100200529     F                                     INFSR(*PSSR)
027200200529     F                                     COMMIT
027300200529      *
027400200529      **   MG - SE Corporate Actions - Capital Events
027500200529     FSECOCEL0  UF A E           K DISK
027600200529     F                                     INFSR(*PSSR)
027700200529     F                                     COMMIT
027800200529      *
027900200529      **   MH - SE Corporate Actions - Merger
028000200529     FSECOCRL0  UF A E           K DISK
028100200529     F                                     INFSR(*PSSR)
028200200529     F                                     COMMIT
028300200529      *
028400200529      **   MI - SE Corporate Actions - Exchange Offers
028500200529     FSECOOFL0  UF A E           K DISK
028600200529     F                                     INFSR(*PSSR)
028700200529     F                                     COMMIT
028800200529      *
028900200529      **   MF - SE Corporate Actions - Rights Issues
029000200529     FSECORGL0  UF A E           K DISK
029100200529     F                                     INFSR(*PSSR)
029200200529     F                                     COMMIT
029300200529      *
029400200529      **   MJ - SE Corporate Actions - Exercises and Conversions
029500200529     FSECOEXL0  UF A E           K DISK
029600200529     F                                     INFSR(*PSSR)
029700200529     F                                     COMMIT
029800200529      *
029900200529      **   MK - SE Corporate Actions - Non Financial Events
030000200529     FSECONFL0  UF A E           K DISK
030100200529     F                                     INFSR(*PSSR)
030200200529     F                                     COMMIT
030300200529      *
030400200529      **   ML - SE Corporate Actions - Name Changes
030500200529     FSECONCL0  UF A E           K DISK
030600200529     F                                     INFSR(*PSSR)
030700200529     F                                     COMMIT
030800200529      *                                                                   CEU017
030900200529      **   NA - SE Corporate Actions (EMU) - Currency Changes             CEU017
031000200529     FSECOCCL0  UF A E           K DISK                                         CEU017
031100200529     F                                     INFSR(*PSSR)                         CEU017
031200200529     F                                     COMMIT                               CEU017
031300200529      *                                                                   CEU017
031400200529      **  NB - Securities Redenomination Bulk Details - Updt Index        CEU017
031500200529     FSECORBL0  UF   E           K DISK    COMMIT                               CEU017
031600200529     F                                     INFSR(*PSSR)                         CEU017
031700200529      *                                                                   CEU017
031800200529      **  NC - Securities Redenomination Bulk Securities - Updt           CEU017
031900200529     FSECORSL0  UF   E           K DISK    COMMIT                               CEU017
032000200529     F                                     INFSR(*PSSR)                         CEU017
032100200529      *                                                                   138962
032200200529      ***  MJ - SE Corporate Actions - Exercises and Conversions,         138962
032300200529      ***       Linked Corporate Action Number.                           138962
032400200529      *                                                                   138962
032500200529     FSECOEXL2  IF   E           K DISK    INFSR(*PSSR)                         138962
032600200529     F                                     RENAME(SECOEXD0:SECOEXD2)            138962
032700200529     F/COPY WNCPYSRC,SE7502F001
032800200529      *                                                                                       CSE020
032900200529      **  Securities Corporate Actions - By parent Ref                                        CSE020
033000200529     FSECORFLA  IF   E           K DISK                                                       CSE020
033100200529     F                                     INFSR(*PSSR)                                       CSE020
033200200529      *                                                                                       CSE020
033300200529      **  Securities Corporate Actions - with level field                                     CSE020
033400200529     FSECORFPM  IF   E             DISK    USROPN                                             CSE020
033500200529     F                                     INFSR(*PSSR)                                       CSE020
033600200529      *
033700200529      **   Display file
033800200529     FSE7502DF  CF   E             WORKSTN INFDS(SCRDS)
033900200529     F                                     INFSR(*PSSR)
034000200529     F                                     SFILE(SE7502S0:#1RRN)
034100200529     D*****************************************************************
034200200529      /EJECT
034300200529     D********************************************************************
034400200529      *
034500200529      * ID F  C  H  L    Function of indicators
034600200529      * ---------------------------------------
034700200529      *
034800200529      *   KC : CMD  3 - End of program
034900200529      *   KE : CMD  5 - Reset Screen
035000200529      *   KI : CMD  9 - Go to 'Add' or 'Change' Mode
035100200529      *   KL : CMD 12 - Previous screen
035200200529      *
035300200529      *   LR :    Last record
035400200529      *   U7/U8 : Database error
035500200529      *
035600200529      *   06 : CGL031 Indicator                                                               CGL031
035700200529      *   07 : Reverse Image on 'Subject to European Tax'                                     CGL031
035800200529      *   13 : Reverse Image on 'Customer Last Reply Time'
035900200529      *   14 : Reverse Image on 'Depot    Last Reply Time'
036000200529      *   15 : LS=Final Allocation Stock
036100200529      *   16 : LY=Final Allocation Cash and Stock
036200200529      *   17 : S =Stock Authorised
036300200529      *   18 : X =Fully Authorised (Cash & Stock)
036400200529      *   20 : Reverse Image on 'Old Capital Value'
036500200529      *   21 : Reverse Image on 'New Capital Value'
036600200529      *   22 : Reverse Image on 'Old Nominal Value'
036700200529      *   23 : Reverse Image on 'New Nominal Value'
036800200529      *   24 : Reverse Image on 'Market Cum Price'
036900200529      *   26 : Number of options is 01
037000200529      *   27 : Rollup subfile
037100200529      *   28 : Error indicator (Subfile Field)
037200200529      *   29 : Error indicator
037300200529      *   30 : End of Subfile
037400200529      *   31 : Reverse Image on 'Market Ex Price'
037500200529      *   32 : Error indicator
037600200529      *   33 : Error indicator
037700200529      *   35 : Protect/Non-display fields for processing type 'CC'        CEU017
037800200529      *   37 : Error indicator
037900200529      *   38 : Error indicator
038000200529      *   39 : Error indicator
038100200529      *
038200200529      *   40 : Confirm REVERSAL or DELETION
038300200529      *   41 : Confirm AUTHORISATION
038400200529      *   42 : Reverse Image on 'Block Security'
038500200529      *
038600200529      *   43 : 'AMEND' Mode if *ON
038700200529      *        'ADD  ' Mode if *OFF
038800200529      *   44 : Error indicator
038900200529      *   45 : "First" Time Processing
039000200529      *   46 : Command Key pressed
039100200529      *   47 : Confirmation Screen or 'Full Details' Screen
039200200529      *   48 : Protect 'Allocation Effective Date'
039300200529      *   49 : Reverse Image on 'Event Date'
039400200529      *
039500200529      *   50 : Error indicator (Position Field)
039600200529      *   51 : Error indicator
039700200529      *   52 : Error indicator
039800200529      *
039900200529      *   53 : Access by Security Shortname and Ex-date
040000200529      *   54 : Access by Ex-date and Security Shortname
040100200529      *   55 : Access by Reference Number
040200200529      *
040300200529      *   56 : Protect 'Position/Selection' Fields
040400200529      *   57 : Protect and non-display 'Action'
040500200529      *   58 : Protect Security Shortname', 'Action Type', 'Number of Options',
040600200529      *   59 : Protect 'Ex-date' field
040700200529      *
040800200529      *   60 : Reverse Image on 'Trade Date'
040900200529      *   61 : Enquiry Mode
041000200529      *   62 : Error indicator (Action)
041100200529      *   63 : Protect 'Ex-date' fields
041200200529      *   64 : Report Mode
041300200529      *   65 : Reverse Image on 'Payment Date'
041400200529      *   66 : Reverse Image on 'Trade/Value Date Position'
041500200529      *   67 : Reverse Image on 'Coupon Number'
041600200529      *   68 : Protect 'Final Allocation' field
041700200529      *   69 : Error indicator (Selection Field)
041800200529      *   70 : Reverse Image on 'ShareHolders Meeting Date'
041900200529      *   71 : Reverse Image on 'Letter to be Sent'
042000200529      *   72 : Reverse Image on 'Block Positions'
042100200529      *   73 : Reverse Image on 'Block From Date'
042200200529      *   74 : Reverse Image on 'Block To   Date'
042300200529      *   75 : Protect 'Date of Announcement'
042400200529      *   76 : Reverse Image on 'Refuse Offer'
042500200529      *   77 : Reverse Image on 'Customer Option Narrative Code'
042600200529      *   78 : Reverse Image on 'Default no Reply'
042700200529      *   79 : Reverse Image on 'Default for Cash Preferred'
042800200529      *
042900200529      *   80 : Display Subfile control
043000200529      *   81 : Display Subfile
043100200529      *   82 : Reverse Image on 'Default for Stock Preferred'
043200200529      *   83 : Reverse Image on 'Customer Last Reply Date'
043300200529      *   84 : Subfile Next Change
043400200529      *   85 : Reverse Image on 'Depot Last Reply Date'
043500200529      *
043600200529      *   87 : Read Change indicator
043700200529      *   88 : Working indicator
043800200529      *   89 : Working indicator
043900200529      *
044000200529      *   90-99 : Used by Standard Subroutines
044100200529      *   98 : Indicator used by subroutine ZDATE1
044200200529      *   99 : Indicator used by subroutine ZDATE1
044300200529      **************************************************************************
044400200529      /EJECT
044500200529      **************************************************************************
044600200529      *
044700200529      * Name of the Subroutines
044800200529      * -----------------------
044900200529      *
045000200529      *       P001  - Initial processing
045100200529      *       P002  - Main processing
045200200529      *       P003  - Termination processing
045300200529      *
045400200529      *       P004  - Clear Subfile
045500200529      *       P005  - Build the subfile for Add Mode
045600200529      *       P006  - Build the subfile for Amend/Enquiry Mode
045700200529      *       P007  - Validate Position/Selection fields
045800200529      *       P008  - Validate subfile records
045900200529      *       P008A - Validate 'Action' field
046000200529      *       P009  - Process 'Action'
046100200529      *       P010  - Process 'Confirmation' screen
046200200529      *       P011  - Process Writing Options with Default Information
046300200529      *       P014  - Initialise error indicators
046400200529      *       P015  - Clear Subfile Fields
046500200529      *       P016  - Load Subfile Fields
046600200529      *       P017  - Reinitialise Position/selection fields
046700200529      *       P018  - Process 'Full details' screen
046800200529      *       P019  - Validate 'Full details' screen and update file
046900200529      *       P020  - Blocking Processing
047000200529      *       P021  - Retrieve Next Available Reference Number
047100200529      *       P022  - Apply Action to all Options
047200200529      *       P023  - View/Change Option(s)
047300200529      *
047400200529      *       R001  - Position into the File
047500200529      *       R002  - Read next record in File
047600200529      *
047700200529      *       *PSSR - "Standard" Database error processing
047800200529      *
047900200529      * Name of the Standard Subroutines
048000200529      * --------------------------------
048100200529      *
048200200529      *       ZNCD   - Determine Next Coupon Date
048300200529      *       ZDATE1 - Dates Validation and Conversion
048400200529      *       ZDATE2 - Dates Validation and Conversion
048500200529      *       ZASNMS - Send Message to Program's message queue
048600200529      *       ZSEDIT - Insert a decimal point and sign into a numeric field
048700200529      *                and blank out leading zeros
048800200529      *       ZALIGN - To validate and right-align numeric fields
048900200529      *
049000200529      ********************************************************************
049100200529      /EJECT
049200200529      ********************************************************************
049300200529      *
049400200529      **   ARRAYS USED BY ZDATE1
049500200529      *
049600200529     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
049700200529     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
049800200529     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
049900200529      *
050000200529      **   FOR COMPILATION - COPYRIGHT INSERTION
050100200529      *
050200200529      *
050300200529      **   STORE THE EIGHT GROUP EACH CUSTOMER IS ASSOCIATED
050400200529      *
050500200529     D CGRP            S              1    DIM(9)                               CUSTOMER GROUP
050600200529     D AGRP            S              1    DIM(9)                               ACCOUNT COMMISS.
050700200529      *
050800200529      *
050900200529     D*****               TXT     1   5 78               COMMAND KEYS     137879
051000200529     D*TXT*******      S             78    DIM(6) CTDATA PERRCD(1)  COMMAND KEYS       137879 CSE020
051100200529     D TXT             S             78    DIM(11) CTDATA PERRCD(1)                           CSE020
051200200529      *
051300200529     D*/COPY ZSRSRC,ZALIGNZ1
051400200529     D ZA1             S              1    DIM(16)                              ZALIGN SR. ARRAY
051500200529     D ZA2             S              1    DIM(16)                              ZALIGN SR. ARRAY
051600200529     D*/COPY ZSRSRC,ZASIGNZ1
051700200529     D*
051800200529     D ZS3             S              1    DIM(17)                              ZASIGN SR. ARRAY
051900200529     D ZS4             S              1    DIM(16)                              ZASIGN SR. ARRAY
052000200529     D ZS5             S              1    DIM(15)                              ZASIGN SR. ARRAY
052100200529     D*
052200200529     D*/COPY ZSRSRC,ZSEDITZ1
052300200529     D ZS2             S              1    DIM(21)
052400200529      *
052500200529     D NARR            S             27    DIM(9) CTDATA PERRCD(1)              NARRATIVE
052600200529      *
052700200529     D*/COPY ZSRSRC,ZHOLE
052800200529     D ZHL1            S              1    DIM(366)
052900200529      *
053000200529      * Arrays to split holiday fields into 1-bit elements
053100200529      *
053200200529                                                                                              CSE016
053300200529      ** Parameter declaration of ZSDESC                                                      CSE016
053400200529                                                                                              CSE016
053500200529     D PSRPN           S             20A                                                      CSE016
053600200529     D PSFN1           S             30A                                                      CSE016
053700200529     D PSFN2           S             30A                                                      CSE016
053800200529     D PRSFD           S              1A                                                      CSE016
053900200529     D PRNME           S             41A                                                      CSE016
054000200529     D PFNM1           S             30A                                                      CSE016
054100200529     D PFNM2           S             50A                                                      CSE016
054200200529     D PFNM3           S             50A                                                      CSE016
054300200529      *                                                                                       215168
054400200529     D WSECN           S             10A                                                      215168
054500200529     D WCOAT           S              2A                                                      215168
054600200529     D WREDSP          S              1A                                                      215168
054700200529     D CSE010          S              1A                                                      215168
054800200529                                                                                              CGL031
054900200529      ** Access Object Parameters                                                             CGL031
055000200529     D PRetCde         S              7A                                                      CGL031
055100200529     D POption         S              7A                                                      CGL031
055200200529     D PSARD           S              6A                                                      CGL031
055300200529                                                                                              CGL031
055400200529      ** Switchable Features                                                                  CGL031
055500200529     D CGL031          S              1A                                                      CGL031
055600200529      *
055700200529      ********************************************************************
055800200529      /EJECT
055900200529      ********************************************************************
056000200529      *
056100200529      **   PROGRAM DATA STRUCTURE
056200200529      *
056300200529     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
056400200529      *
056500200529      **   FILE INFORMATION DATA STRUCTURE
056600200529      *
056700200529     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
056800200529      *
056900200529      **   FILE RECORD DATA STRUCTURE
057000200529      *
057100200529     D FIELD         E DS                  EXTNAME(SECORFPD)
057200200529      *
057300200529      ** External DS for Switchable Feature Details                                           CSE020
057400200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE020
057500200529      *                                                                                       CSE020
057600200529     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE020
057700200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE020
057800200529      *                                                                                       CSE020
057900200529     D SCRDS           DS
058000200529     D  DSPNUM               197    205
058100200529     D  CPFPOS               378    379B 0
058200200529      *
058300200529      **   DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
058400200529      *
058500200529     D CPYR@#          DS
058600200529     D  CPY@                   1     80
058700200529     D                                     DIM(1) CTDATA PERRCD(1)
058800200529     D  CPY@##                 1     20
058900200529      *
059000200529      **   DATA STRUCTURE FOR DATABASE ERROR
059100200529      *
059200200529     D LDA             DS           256
059300200529     D  WWLOT                132    183
059400200529     D  WWFILE               132    141
059500200529     D  WWKEY                142    170
059600200529     D  WWPGM                171    180
059700200529     D  WWASE                181    183  0
059800200529     D  PGMNAM               184    189
059900200529      *
060000200529     D DIGITS          C                   CONST('0123456789')
060100200529      *
060200200529     D CDDS            DS
060300200529     D  CD01                   1      4  0
060400200529     D  CD02                   5      8  0
060500200529     D  CD03                   9     12  0
060600200529     D  CD04                  13     16  0
060700200529     D  CD05                  17     20  0
060800200529     D  CD06                  21     24  0
060900200529     D  CD07                  25     28  0
061000200529     D  CD08                  29     32  0
061100200529     D  CD09                  33     36  0
061200200529     D  CD10                  37     40  0
061300200529     D  CD11                  41     44  0
061400200529     D  CD12                  45     48  0
061500200529     D  CD                     1     48  0
061600200529     D                                     DIM(12)                              CD01-12 ARRAY
061700200529     D CRDS            DS
061800200529     D  CR01                   1      1
061900200529     D  CR02                   2      2
062000200529     D  CR03                   3      3
062100200529     D  CR04                   4      4
062200200529     D  CR05                   5      5
062300200529     D  CR06                   6      6
062400200529     D  CR07                   7      7
062500200529     D  CR08                   8      8
062600200529     D  CR09                   9      9
062700200529     D  CR10                  10     10
062800200529     D  CR11                  11     11
062900200529     D  CR12                  12     12
063000200529     D  CR                     1     12
063100200529     D                                     DIM(12)                              CR01-12 ARRAY
063200200529     D LOCKDS          DS
063300200529     D  WUSER                  1     10
063400200529     D  WJOBN                 11     20
063500200529      *
063600200529     D ZMUSER          DS            17
063700200529      ** Data area ZMUSER
063800200529     D  BVBRCD                11     13
063900200529      *
064000200529      ***  Data structure used to send data to message ID CO00600:        138962
064100200529      ***  Linked Corporate Action Number and Processing Type.            138962
064200200529      *                                                                   138962
064300200529     D REFLIN          DS                                                       138962
064400200529     D  WWLNKR                 1      6                                         138962
064500200529     D  WWPTYP                 7      8                                         138962
064600200529     D RUNDAT        E DS
064700200529      **  Standard Data Area Layout for System flags and Run Date
064800200529      *
064900200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
065000200529      **  Data structure for bank details
065100200529      *
065200200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
065300200529      **  Data structure for branch details
065400200529      *
065500200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
065600200529      **  Data structure for securities trading details
065700200529      *
065800200529     D DSSDY         E DS                  EXTNAME(DSSDY)
065900200529      **  Long data structure for access objects
066000200529      *
066100200529     I/COPY WNCPYSRC,SE7502I001
066200200529     D*/COPY ZSRSRC,ZHOLI
066300200529     D ZHOLDS          DS
066400200529      *
066500200529      * Data structure defined over holiday file fields
066600200529      *
066700200529     D  DGCYCD                 1      3
066800200529     D  DGLCCD                 4      6
066900200529     D  DGYRNB                 7     10  0
067000200529     D  DGJDNB                11     13P 0
067100200529     D  DGDDNB                14     16P 0
067200200529     D  ZDS1                  17    202
067300200529     D  ZDS2                 203    382
067400200529     D  ZHL                   17    382
067500200529     D                                     DIM(366)
067600200529      *
067700200529      *
067800200529     D ZVARS           DS
067900200529      *
068000200529      * Data structure to define variables used in holiday sub-routines
068100200529      *
068200200529     D  ZIND                   1      1
068300200529     D  ZINDX                  2      4  0
068400200529     D  ZDAYNO                 5      7P 0
068500200529     D  ZDYNBR                 8     10P 0
068600200529     D  ZNRDYS                11     12  0
068700200529     D  @ZWRDY                13     14  0
068800200529      *
068900200529     D  ZCCY                  15     17
069000200529     D  ZLOC                  18     20
069100200529     D  @ZWRKI                15     20
069200200529      *
069300200529     D  ZSCCY                 21     23
069400200529     D  ZSLOC                 24     26
069500200529     D  ZSWEXX                27     30  0
069600200529     D  ZSJAN                 31     33P 0
069700200529     D  ZSDCM                 34     36P 0
069800200529     D  RTNCD                 37     43
069900200529     D  @ZWRKO                21     43
070000200529      *
070100200529     D  ZOPTN                 44     50
070200200529     D  ZZCCY                 51     53
070300200529     D  ZZLOC                 54     56
070400200529     D  ZZDYNO                57     59P 0
070500200529     D  ZSRTN                 60     66
070600200529     D*/COPY ZSRSRC,ZSEDITZ2
070700200529     D                 DS
070800200529     D  WORK15                 1     15  0
070900200529     D  ZS1                    1     15  0
071000200529     D                                     DIM(15)
071100200529      *
071200200529     *********************************************************************
071300200529      /EJECT
071400200529      ********************************************************************
071500200529      **    P R O G R A M   S T A R T
071600200529      ********************************************************************
071700200529      *
071800200529      **   INITIAL PROCESSING
071900200529      *
072000200529     C                   EXSR      P001
072100200529      *
072200200529      **   MAIN PROCESSING
072300200529      *
072400200529     C/COPY WNCPYSRC,SE7502C006
072500200529     C                   EXSR      P002
072600200529     C/COPY WNCPYSRC,SE7502C007
072700200529      *
072800200529      **   TERMINATION PROCESSING
072900200529      *
073000200529     C                   EXSR      P003
073100200529      *
073200200529      ********************************************************************
073300200529      **    P R O G R A M     E N D
073400200529      ********************************************************************
073500200529      /EJECT
073600200529      *****************************************************************
073700200529      * P001   : INITIAL PROCESSING                                   *
073800200529      *****************************************************************
073900200529      *
074000200529     C     P001          BEGSR
074100200529      *
074200200529      **  Copyright statement
074300200529      *
074400200529     C                   MOVEA     CPY@          ACT@             80
074500200529     C                   MOVE      '0'           WIN45             1                          CSE020
074600200529     C                   MOVE      'N'           WOPEN             1                          CSE020
074700200529     C                   MOVE      '0'           WIN53             1                          CSE020
074800200529      *
074900200529      **  Read in DTAARA/RUNDAT
075000200529      *
075100200529     C     *DTAARA       DEFINE                  RUNDAT
075200200529     C                   IN        RUNDAT
075300200529      *
075400200529      **  Read in DTAARA/ZMUSER
075500200529      *
075600200529     C     *DTAARA       DEFINE                  ZMUSER
075700200529     C                   IN        ZMUSER
075800200529      *
075900200529      **   KEY FIELDS
076000200529      *
076100200529     C     KEY1          KLIST
076200200529     C                   KFLD                    KSECN            10
076300200529     C                   KFLD                    KEXDT             5 0
076400200529     C                   KFLD                    KREFN             6
076500200529      *
076600200529     C     KEY2          KLIST
076700200529     C                   KFLD                    KEXDT
076800200529     C                   KFLD                    KSECN
076900200529     C                   KFLD                    KREFN
077000200529      *
077100200529     C     KEY3          KLIST
077200200529     C                   KFLD                    KNMCY
077300200529     C                   KFLD                    KSITP
077400200529      *
077500200529     C     KEY4          KLIST
077600200529     C                   KFLD                    KSECN
077700200529     C                   KFLD                    KEXDT
077800200529      *
077900200529     C     KEY5          KLIST
078000200529     C                   KFLD                    KSECN            10
078100200529     C                   KFLD                    KEXDT             5 0
078200200529     C                   KFLD                    KTYPE             2
078300200529      *
078400200529     C     KEY6          KLIST
078500200529     C                   KFLD                    KCORF             6
078600200529     C                   KFLD                    KOPTN             2 0
078700200529      *                                                                   155622
078800200529     C     KEY7          KLIST                                                                 15562
078900200529     C                   KFLD                    KSECN                                         15562
079000200529     C                   KFLD                    KEXDT                                         15562
079100200529      *
079200200529      **   ENTRY PARAMETERS
079300200529      **   RECEIVE 'ACTION CODE' TO DETERMINE THE PROCESSING MODE
079400200529      **   VALUE CAN BE 'E' FOR ENQUIRY, 'A' FOR UPDATE OR 'R' FOR REPORT
079500200529      *
079600200529     C     *ENTRY        PLIST
079700200529     C                   PARM                    ACTION            1
079800200529     C/COPY WNCPYSRC,SE7502C008
079900200529     C                   PARM                    P#MBR            10                          CSE020
080000200529      *
080100200529      **   INITIALISE KEY AND WORKING FIELDS
080200200529      *
080300200529     C                   MOVE      *BLANKS       WWLOT
080400200529     C                   MOVEL     'SE7502'      DBPGM            10
080500200529      *
080600200529     C                   MOVE      *BLANKS       #3REFN
080700200529     C                   MOVE      *BLANKS       #3SECN
080800200529     C                   MOVE      *BLANKS       #3EXDT
080900200529     C                   MOVE      *BLANKS       #3STAT
081000200529     C                   MOVE      *BLANKS       #3COAT
081100200529      *
081200200529     C                   Z-ADD     0             WWRRN             4 0          SAVE RCD.NBR.
081300200529      *
081400200529      **   SETUP SCREEN TIME
081500200529      *
081600200529     C                   TIME                    ##TME             6 0          Screen time.
081700200529      *
081800200529      **   ACCESS TO BANK DETAILS TO RETRIEVE THE MIDAS RUN DATE
081900200529      *
082000200529     C                   CALL      'AOBANKR0'
082100200529     C                   PARM      *BLANKS       WLRTCD            7
082200200529     C                   PARM      '*FIRST'      WLOPTN            7
082300200529     C     SDBANK        PARM      SDBANK        DSSDY
082400200529      *
082500200529      **   IF RECORD NOT FOUND
082600200529      *
082700200529     C     WLRTCD        IFNE      *BLANKS
082800200529     C                   MOVEL     '001'         DBASE             3 0          *****************
082900200529     C                   MOVE      'SDBANKPD'    DBFILE           10            * DB ERROR 01   *
083000200529     C                   MOVEL     *BLANKS       DBKEY            29            *****************
083100200529     C                   EXSR      *PSSR
083200200529     C                   ENDIF
083300200529      *
083400200529     C                   MOVE      BJMRDT        ##MRDT                         MIDAS RUN DATE
083500200529      *
083600200529      **   DETERMINE DATE FORMAT
083700200529      *
083800200529     C     BJDFIN        IFEQ      'M'
083900200529     C                   MOVE      '1'           *IN98
084000200529     C                   ENDIF
084100200529      *
084200200529      **   ACCESS TO SECURITIES TRADING DATA TO RETRIEVE THE BACK VALUE PERIOD
084300200529      *
084400200529     C                   CALL      'AOSTRDR0'
084500200529     C                   PARM      *BLANKS       WLRTCD
084600200529     C                   PARM      '*FIRST'      WLOPTN
084700200529     C     SDSTRD        PARM      SDSTRD        DSSDY
084800200529      *
084900200529      **   IF RECORD IS NOT FOUND
085000200529      *
085100200529     C     WLRTCD        IFNE      *BLANKS
085200200529     C                   MOVEL     '002'         DBASE                          *****************
085300200529     C                   MOVE      'SDSTRDPD'    DBFILE                         * DB ERROR 02   *
085400200529     C                   MOVEL     *BLANKS       DBKEY                          *****************
085500200529     C                   EXSR      *PSSR
085600200529     C                   ENDIF
085700200529      *
085800200529      **   CALCULATE RETENTION PERIODS
085900200529      *
086000200529     C                   Z-ADD     *ZEROS        WK3N              3 0
086100200529     C     31            MULT      BVROPS        WK3N
086200200529     C     BJRDNB        SUB       WK3N          RTNPOS            5 0
086300200529      *
086400200529     C                   Z-ADD     *ZEROS        WK3N
086500200529     C     31            MULT      BVROST        WK3N
086600200529     C     BJRDNB        SUB       WK3N          RTNTRD            5 0
086700200529      *
086800200529      **  Access SDBRCHPD using the default user branch
086900200529      *
087000200529     C**********         CALL      'AOBRCHR0'                                                 CGL029
087100200529     C                   CALL      'AOBRCHR1'                                                 CGL029
087200200529     C                   PARM      *BLANKS       WLRTCD
087300200529     C                   PARM      '*KEY   '     WLOPTN
087400200529     C                   PARM      BVBRCD        WLBRCH            3
087500200529     C     SDBRCH        PARM      SDBRCH        DSSDY
087600200529      *
087700200529      **  Check if error occurred
087800200529      *
087900200529     C     WLRTCD        IFNE      *BLANKS
088000200529     C                   MOVEL     '003'         DBASE                          *****************
088100200529     C                   MOVE      'SDBRCHPD'    DBFILE                         * DB ERROR 03   *
088200200529     C                   MOVEL     *BLANKS       DBKEY                          *****************
088300200529     C                   MOVEL     BVBRCD        DBKEY
088400200529     C                   EXSR      *PSSR
088500200529     C                   ENDIF
088600200529      *                                                                                       CSE020
088700200529      ** Check if CA Domino Effect Enhancement is installed                                   CSE020
088800200529      *                                                                                       CSE020
088900200529     C                   MOVE      'N'           CSE020            1                          CSE020
089000200529     C                   CALL      'AOSARDR0'                                                 CSE020
089100200529     C                   PARM      *BLANKS       WLRTCD                                       CSE020
089200200529     C                   PARM      '*VERIFY'     WLOPTN                                       CSE020
089300200529     C                   PARM      'CSE020'      WSARD             6                          CSE020
089400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE020
089500200529      *                                                                                       CSE020
089600200529     C     WLRTCD        IFNE      *BLANKS                                                    CSE020
089700200529     C     WLRTCD        ANDNE     '*NRF   '                                                  CSE020
089800200529     C                   MOVEL     '004'         DBASE                          ************  CSE020
089900200529     C                   MOVE      'SCSARDPD'    DBFILE                         * DBERR 04 *  CSE020
090000200529     C                   MOVEL     *BLANKS       DBKEY                          ************  CSE020
090100200529     C                   MOVEL     'CSE020'      DBKEY                                        CSE020
090200200529     C                   EXSR      *PSSR                                                      CSE020
090300200529     C                   ELSE                                                                 CSE020
090400200529     C     WLRTCD        IFEQ      *BLANKS                                                    CSE020
090500200529     C                   MOVE      'Y'           CSE020                                       CSE020
090600200529     C                   ELSE                                                                 CSE020
090700200529     C                   MOVE      'N'           CSE020                                       CSE020
090800200529     C                   ENDIF                                                                CSE020
090900200529     C                   ENDIF                                                                CSE020
091000200529      *                                                                                       CSE020
091100200529      ** Check if SE Transactions Enhancements is installed                                   215168
091200200529      *                                                                                       215168
091300200529     C                   CALL      'AOSARDR0'                                                 215168
091400200529     C                   PARM      *BLANKS       WLRTCD                                       215168
091500200529     C                   PARM      '*VERIFY'     WLOPTN                                       215168
091600200529     C                   PARM      'CSE010'      WSARD             6                          215168
091700200529      *                                                                                       215168
091800200529     C     WLRTCD        IFEQ      *BLANKS                                                    215168
091900200529     C                   MOVE      'Y'           CSE010                                       215168
092000200529     C                   ELSE                                                                 215168
092100200529     C                   MOVE      'N'           CSE010                                       215168
092200200529     C                   ENDIF                                                                215168
092300200529                                                                                              CGL031
092400200529      ** Check if CGL031 is enabled.                                                          CGL031
092500200529                                                                                              CGL031
092600200529     C                   CALL      'AOSARDR0'                                                 CGL031
092700200529     C                   PARM      *BLANKS       PRetCde                                      CGL031
092800200529     C                   PARM      '*VERIFY'     POption                                      CGL031
092900200529     C                   PARM      'CGL031'      PSARD                                        CGL031
093000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
093100200529                                                                                              CGL031
093200200529     C                   EVAL      CGL031 = 'N'                                               CGL031
093300200529     C                   EVAL      *IN60 = *OFF                                               CGL031
093400200529                                                                                              CGL031
093500200529     C                   IF        PRetCde = *BLANKS                                          CGL031
093600200529     C                   EVAL      CGL031 = 'Y'                                               CGL031
093700200529     C                   EVAL      *IN06 = *ON                                                CGL031
093800200529     C                   ELSE                                                                 CGL031
093900200529                                                                                              CGL031
094000200529     C                   IF        PRetCde <> *BLANKS                                         CGL031
094100200529     C     *LOCK         IN        LDA                                                        CGL031
094200200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
094300200529     C                   EVAL      DBKey = 'CGL031'                                           CGL031
094400200529     C                   EVAL      DBase = 101                                                CGL031
094500200529     C                   OUT       LDA                                                        CGL031
094600200529     C                   ENDIF                                                                CGL031
094700200529                                                                                              CGL031
094800200529     C                   ENDIF                                                                CGL031
094900200529      *                                                                                       215168
095000200529      **   CALCULATE THE SE BACKVALUE DATE
095100200529      *
095200200529     C     BJRDNB        SUB       BVBVP         WBACKD            5 0
095300200529      *
095400200529      **   IF THE 'ACTION' PARAMETER IS EQUAL TO 'E' OR 'R'
095500200529      **   SETON INDICATOR FOR ENQUIRY MODE OR REPORT MODE
095600200529      *
095700200529     C     ACTION        IFEQ      'E'                                          B*1
095800200529     C     ACTION        OREQ      'R'
095900200529     C                   MOVE      '1'           *IN61
096000200529     C                   MOVEA     TXT(1)        ##CTX1
096100200529      *
096200200529     C     ACTION        IFEQ      'R'                                          B*2
096300200529     C                   MOVE      '1'           *IN64
096400200529     C                   ENDIF                                                  E*2
096500200529     C                   ENDIF                                                  E*1
096600200529      *
096700200529      **   IF THE 'ACTION' PARAMETER IS EQUAL TO 'A'
096800200529      **   SETON INDICATOR FOR 'UPDATE' MODE
096900200529      *
097000200529     C     ACTION        IFEQ      'A'                                          B*1
097100200529     C/COPY WNCPYSRC,SE7502C009
097200200529      *
097300200529      **   ACCESS THE ER REFERENCES FILE TO SEE IF THERE IS RECORD IN THE FILE
097400200529      *
097500200529     C************LOVAL    SETLLSECORFL1                                  136421
097600200529     C************         READ SECORFL1                 89               136421
097700200529     C     *HIVAL        SETGT     SECORFL9                                                    13642
097800200529     C                   READ      SECORFL9                               89                   13642
097900200529      *
098000200529      **   IF RECORD IS NOT FOUND, SETON THE INDICATOR OF 'ADD MODE'
098100200529      *
098200200529     C     *IN89         IFEQ      '1'                                          B*2
098300200529     C                   MOVE      '0'           *IN43
098400200529     C                   MOVEA     TXT(2)        ##CTX1
098500200529      *
098600200529      **   IF RECORD IS NOT FOUND, SETON THE INDICATOR OF 'AMEND MODE'
098700200529      *
098800200529     C                   ELSE                                                   X*2
098900200529     C                   MOVE      '1'           *IN43
099000200529     C                   MOVEA     TXT(3)        ##CTX1
099100200529     C                   ENDIF                                                  E*2
099200200529     C                   ENDIF                                                  E*1
099300200529      *
099400200529      **   ONLY TO DECLARE THE FILE IN 'ADD' MODE
099500200529      *
099600200529     C     *IN99         IFEQ      '0'                                          B*1
099700200529     C     *IN99         ANDEQ     '1'
099800200529     C                   WRITE     SECODRD0
099900200529     C                   WRITE     SECODPD0
100000200529     C                   WRITE     SECOALD0
100100200529     C                   WRITE     SECORED0
100200200529     C                   WRITE     SECORHD0
100300200529     C                   ENDIF                                                  E*1
100400200529      *
100500200529      **   RETRIEVE NEXT REFERENCE NUMBER
100600200529      *
100700200529     C     *LOVAL        SETLL     SECORFPA
100800200529     C                   READ(N)   SECORFPA                               89
100900200529      *
101000200529      **   IF RECORD NOT FOUND
101100200529      *
101200200529     C     *IN89         IFEQ      '1'
101300200529     C                   MOVE      'D'           MXRECI
101400200529     C                   Z-ADD     BJRDNB        MXLCD
101500200529     C                   MOVE      'I'           MXCHTP
101600200529     C                   MOVE      ##USR         MXLUID
101700200529     C                   MOVE      '000001'      MXCORF
101800200529     C                   WRITE     SECORFP0
101900200529     C                   ENDIF
102000200529      *
102100200529     C                   MOVE      MXCORF        WWCORF            6 0
102200200529     C                   MOVE      MXCORF        W1CORF            6 0
102300200529      *
102400200529      **   SELECT THE PROGRAM MSGQ FOR ERROR MSG
102500200529      *
102600200529     C                   MOVEL     '*'           TOPQ             10
102700200529     C                   MOVEL     '*PRV'        TOPRQ             5
102800200529     C                   MOVEL     'SEUSRMSG'    PMSGF            10
102900200529      *
103000200529      **   FILL IN FIELDS FOR SUBROUTINE ZASNMS
103100200529      *
103200200529     C                   MOVEL     'SE7502'      ZAPGM            10            Message queue
103300200529     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10            Message file
103400200529     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
103500200529     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
103600200529     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
103700200529     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
103800200529      *
103900200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
104000200529      *
104100200529     C/COPY WNCPYSRC,SE7502C010
104200200529     C                   CALL      'Y2CLMSC'
104300200529     C                   PARM      ##PGM         ZAPGM            10
104400200529     C                   PARM      '*SAME'       ZAPGRL            5
104500200529      *
104600200529     C                   WRITE     #MSGCTL
104700200529      *
104800200529     C/COPY WNCPYSRC,SE7502C001
104900200529      *
105000200529     C                   ENDSR
105100200529      *****************************************************************
105200200529      /EJECT
105300200529      *****************************************************************
105400200529      * P002   : MAIN PROCESSING                                      *
105500200529      *****************************************************************
105600200529      *
105700200529     C     P002          BEGSR
105800200529      *
105900200529      **   WHILE CMD3 NOT PRESSED
106000200529      *
106100200529     C     *INKC         DOWEQ     '0'                                          B*1
106200200529      *
106300200529      **   IF IT'S THE FIRST TIME PROCESSING OR F5 IS PRESSED
106400200529      *
106500200529     C******IN45*        IFEQ      '0'                                          B*2           CSE020
106600200529     C     WIN45         IFEQ      '0'                                                        CSE020
106700200529     C     *INKE         OREQ      '1'
106800200529     C     WWREX         OREQ      'Y'                                                         13896
106900200529      *
107000200529     C***********        MOVE      '0'           *IN53                                        CSE020
107100200529     C                   MOVE      '0'           WIN53                                        CSE020
107200200529     C                   MOVE      '0'           *IN54
107300200529     C                   MOVE      '0'           *IN55
107400200529     C                   MOVE      ' '           WWREX                                         13896
107500200529      *
107600200529      **   IF IT'S NOT THE ENQUIRY MODE
107700200529      *
107800200529     C     *IN61         IFEQ      '0'                                          B*3
107900200529      *
108000200529      **   IT IT'S THE 'AMEND' MODE, BUILD THE FIRST SUBFILE PAGE
108100200529      *
108200200529     C     *IN43         IFEQ      '1'                                          B*4
108300200529     C***********        MOVE      '0'           *IN45                                        CSE020
108400200529     C                   MOVE      '0'           WIN45             1                          CSE020
108500200529      *
108600200529      **   CLEAR SUBFILE
108700200529      *
108800200529     C                   EXSR      P004
108900200529      *
109000200529      **   PROTECT ON 'POSITION/SELECTION' FIELDS *OFF
109100200529      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *OFF
109200200529      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *ON
109300200529      *
109400200529     C                   MOVE      '0'           *IN56
109500200529     C                   MOVE      '0'           *IN57
109600200529     C                   MOVE      '1'           *IN58
109700200529      *
109800200529      **   INITIALISE ERROR INDICATORS
109900200529      *
110000200529     C                   EXSR      P014
110100200529      *
110200200529      **   REINITIALISE POSITION/SELECTION FIELDS
110300200529      *
110400200529     C                   EXSR      P017
110500200529      *
110600200529      **   SET KEY FIELDS WITH BLANKS OR ZEROS
110700200529      *
110800200529     C                   MOVE      *BLANKS       KREFN
110900200529     C                   MOVE      *BLANKS       KSECN
111000200529     C                   Z-ADD     *ZEROS        KEXDT
111100200529      *
111200200529      **   BUILD THE FIRST SUBFILE PAGE
111300200529      *
111400200529     C                   EXSR      P006
111500200529     C                   ELSE                                                   X*4
111600200529      *
111700200529      **   IT IT'S THE 'ADD' MODE, BUILD A BLANK SUBFILE
111800200529      *
111900200529     C                   EXSR      P004
112000200529      *
112100200529      **   PROTECT ON 'POSITION/SELECTION' FIELDS *ON
112200200529      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *ON
112300200529      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *OFF
112400200529      *
112500200529     C                   MOVE      '1'           *IN56
112600200529     C                   MOVE      '1'           *IN57
112700200529     C                   MOVE      '0'           *IN58
112800200529      *
112900200529      **   INITIALISE ERROR INDICATORS
113000200529      *
113100200529     C                   EXSR      P014
113200200529      *
113300200529      **   BUILD A BLANK SUBFILE
113400200529      *
113500200529     C                   EXSR      P005
113600200529     C                   Z-ADD     1             #1RRN
113700200529     C                   ENDIF                                                  E*4
113800200529      *
113900200529      **   IF IT'S THE ENQUIRY MODE
114000200529      *
114100200529     C                   ELSE                                                   X*3
114200200529     C***********        MOVE      '0'           *IN45                                        CSE020
114300200529     C                   MOVE      '0'           WIN45                                        CSE020
114400200529      *
114500200529      **   CLEAR SUBFILE
114600200529      *
114700200529     C                   EXSR      P004
114800200529      *
114900200529      **   REINITIALISE POSITION/SELECTION FIELDS
115000200529      *
115100200529     C                   EXSR      P017
115200200529      *
115300200529      **   INITIALISE ERROR INDICATORS
115400200529      *
115500200529     C                   EXSR      P014
115600200529      *
115700200529      **   SET KEY FIELDS WITH BLANKS OR ZEROS
115800200529      *
115900200529     C                   MOVE      *BLANKS       KREFN
116000200529     C                   MOVE      *BLANKS       KSECN
116100200529     C                   Z-ADD     *ZEROS        KEXDT
116200200529      *
116300200529      **   BUILD THE FIRST SUBFILE PAGE
116400200529      *
116500200529     C                   EXSR      P006
116600200529     C                   ENDIF                                                  E*3
116700200529      *
116800200529     C***********        MOVE      '1'           *IN45                                        CSE020
116900200529     C                   MOVE      '1'           WIN45                                        CSE020
117000200529     C                   ENDIF                                                  E*2
117100200529      *
117200200529      **   IF CMD9 IS PRESSED
117300200529      *
117400200529     C     *IN09         IFEQ      '1'                                          B*2
117500200529      *
117600200529      **  Check if user is authorised to action 'Insert'
117700200529      *
117800200529     C     AGMBIN        IFNE      'Y'
117900200529      *
118000200529      **  If single branch environment
118100200529      *
118200200529     C                   CALL      'ZVACTU'
118300200529     C                   PARM      'I'           WLACTN            1
118400200529     C                   PARM      *ZERO         WLERR             1 0
118500200529      *
118600200529     C     WLERR         IFNE      *ZERO
118700200529     C                   MOVEL     'CO00034'     ZAMSID
118800200529     C                   EXSR      ZASNMS
118900200529     C                   ENDIF
119000200529      *
119100200529     C                   ELSE
119200200529      *
119300200529      **  If multibranching environment
119400200529      *
119500200529     C                   CALL      'ZVACTBU'
119600200529     C                   PARM      'I'           WLACTN            1
119700200529     C                   PARM      BVBRCD        WLBRCH            3
119800200529     C                   PARM      *ZERO         WLERR             1 0
119900200529      *
120000200529     C     WLERR         IFEQ      1
120100200529     C                   MOVEL     'CO00035'     ZAMSID
120200200529     C                   EXSR      ZASNMS
120300200529     C                   ELSE
120400200529     C     WLERR         IFEQ      2
120500200529     C                   MOVEL     'CO00036'     ZAMSID
120600200529     C                   EXSR      ZASNMS
120700200529     C                   ENDIF
120800200529     C                   ENDIF
120900200529      *
121000200529     C                   ENDIF
121100200529      *
121200200529     C     WLERR         IFEQ      *ZERO
121300200529      *
121400200529      **   IT IT'S THE 'AMEND' MODE, BUILD A BLANK SUBFILE
121500200529      *
121600200529     C     *IN43         IFEQ      '1'                                          B*3
121700200529      *
121800200529      **   INITIALISE ERROR INDICATORS
121900200529      *
122000200529     C                   EXSR      P014
122100200529      *
122200200529      **   CLEAR SUBFILE
122300200529      *
122400200529     C                   EXSR      P004
122500200529     C                   MOVEA     TXT(2)        ##CTX1
122600200529      *
122700200529      **   PROTECT ON 'POSITION/SELECTION' FIELDS *ON
122800200529      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *ON
122900200529      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *OFF
123000200529      *
123100200529     C                   MOVE      '1'           *IN56
123200200529     C                   MOVE      '1'           *IN57
123300200529     C                   MOVE      '0'           *IN58
123400200529      *
123500200529     C                   MOVE      '0'           *IN30
123600200529     C                   MOVE      '0'           *IN59
123700200529     C                   MOVE      '0'           *IN63
123800200529     C                   MOVE      '0'           *IN68
123900200529     C                   MOVE      '1'           *IN48
124000200529     C                   MOVE      '0'           *IN75
124100200529      *
124200200529      **   BUILD A BLANK SUBFILE
124300200529      *
124400200529     C                   EXSR      P005
124500200529     C                   Z-ADD     1             #1RRN
124600200529     C                   MOVE      '0'           *IN43
124700200529     C                   ELSE                                                   X*3
124800200529      *
124900200529     C***********        MOVE      '0'           *IN53                                        CSE020
125000200529     C                   MOVE      '0'           WIN53                                        CSE020
125100200529     C                   MOVE      '0'           *IN54
125200200529     C                   MOVE      '0'           *IN55
125300200529      *
125400200529      **   CLEAR SUBFILE
125500200529      *
125600200529     C                   EXSR      P004
125700200529      *
125800200529      **   INITIALISE ERROR INDICATORS
125900200529      *
126000200529     C                   EXSR      P014
126100200529      *
126200200529      **   IT IT'S THE 'ADD' MODE, BUILD A FIRST SUBFILE PAGE
126300200529      **   (BEGINNING AT FIRST INSERTED RECORD)
126400200529      *
126500200529     C                   MOVEA     TXT(3)        ##CTX1
126600200529      *
126700200529      **   PROTECT ON 'POSITION/SELECTION' FIELDS *OFF
126800200529      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *OFF
126900200529      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *ON
127000200529      *
127100200529     C                   MOVE      '0'           *IN56
127200200529     C                   MOVE      '0'           *IN57
127300200529     C                   MOVE      '1'           *IN58
127400200529      *
127500200529     C***********        MOVE      '0'           *IN45                                        CSE020
127600200529     C                   MOVE      '0'           WIN45                                        CSE020
127700200529      *
127800200529      **   BUILD THE FIRST SUBFILE PAGE
127900200529      *
128000200529     C                   EXSR      P006
128100200529     C***********        MOVE      '1'           *IN45                                        CSE020
128200200529     C                   MOVE      '1'           WIN45                                        CSE020
128300200529     C                   MOVE      '1'           *IN43
128400200529     C                   ENDIF                                                  E*3
128500200529      *
128600200529     C                   ENDIF
128700200529      *
128800200529     C                   ENDIF                                                  E*2
128900200529      *
129000200529      **   IF ROLLUP IS PRESSED
129100200529      *
129200200529     C     *IN27         IFEQ      '1'                                          B*2
129300200529     C                   Z-ADD     WWRRN         #1RRN
129400200529      *
129500200529      **   REINITIALISE ERROR INDICATORS
129600200529      *
129700200529     C                   EXSR      P014
129800200529      *
129900200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
130000200529      *
130100200529     C                   CALL      'Y2CLMSC'
130200200529     C                   PARM      ##PGM         ZAPGM            10
130300200529     C                   PARM      '*SAME'       ZAPGRL            5
130400200529      *
130500200529      **   IF IT'S THE 'ADD' MODE ONLY
130600200529      *
130700200529     C     *IN43         IFEQ      '0'                                          B*3
130800200529     C     *IN61         ANDEQ     '0'
130900200529      *
131000200529      **   BUILD A BLANK SUBFILE PAGE
131100200529      *
131200200529     C                   EXSR      P005
131300200529      *
131400200529      **   IF IT'S THE 'AMEND' MODE OR THE 'ENQUIRY' MODE
131500200529      *
131600200529     C                   ELSE                                                   X*3
131700200529      *
131800200529      **   SET KEY FIELDS WITH BLANKS OR ZEROS
131900200529      *
132000200529     C                   MOVE      *BLANKS       KREFN
132100200529     C                   MOVE      *BLANKS       KSECN
132200200529     C                   Z-ADD     *ZEROS        KEXDT
132300200529      *
132400200529      **   BUILD THE NEXT SUBFILE PAGE
132500200529      *
132600200529     C                   EXSR      P006
132700200529     C                   ENDIF                                                  E*3
132800200529     C                   ENDIF                                                  E*2
132900200529      *
133000200529     C                   MOVE      '0'           *IN50                          Error on Reference
133100200529     C                   MOVE      '0'           *IN51                          Error on Security
133200200529     C                   MOVE      '0'           *IN52                          Error on Ex-date
133300200529     C                   MOVE      '0'           *IN69                          Error Type Select.
133400200529     C                   MOVE      '0'           *IN86                          Error Status Select.
133500200529      *
133600200529      **   IF ONE OF THE POSITION/SELECTION FIELDS IS CHANGED
133700200529      *
133800200529     C     #REFN         IFNE      #3REFN                                       B*2
133900200529     C     #SECN         ORNE      #3SECN
134000200529     C     #EXDT         ORNE      #3EXDT
134100200529     C     #COAT         ORNE      #3COAT
134200200529     C     #STAT         ORNE      #3STAT
134300200529      *
134400200529      **   VALIDATE POSITION/SELECTION FIELDS
134500200529      *
134600200529     C                   EXSR      P007
134700200529      *
134800200529      **   IF NO ERROR IS FOUND, BUILD THE FIRST SUBFILE PAGE
134900200529      *
135000200529     C     *IN50         IFEQ      '0'                                          B*3
135100200529     C     *IN51         ANDEQ     '0'
135200200529     C     *IN52         ANDEQ     '0'
135300200529     C     *IN69         ANDEQ     '0'
135400200529     C     *IN86         ANDEQ     '0'
135500200529      *
135600200529      **   CLEAR SUBFILE
135700200529      *
135800200529     C                   EXSR      P004
135900200529      *
136000200529      **   SET KEY FIELDS WITH BLANKS OR ZEROS
136100200529      *
136200200529     C                   MOVE      *BLANKS       KREFN
136300200529     C                   MOVE      *BLANKS       KSECN
136400200529     C                   Z-ADD     *ZEROS        KEXDT
136500200529      *
136600200529      **   BUILD THE FIRST SUBFILE PAGE
136700200529      *
136800200529     C                   EXSR      P006
136900200529      ******                                                              137879
137000200529      *****REINITIALISE*POSITION/SELECTION*FIELDS*(IDEM*FOR*HIDDEN*FIELDS)137879
137100200529      ******                                                              137879
137200200529     C******               MOVE *BLANKS   #REFN                           137879
137300200529     C******               MOVE *BLANKS   #SECN                           137879
137400200529     C******               MOVE *BLANKS   #EXDT                           137879
137500200529     C******               MOVE *BLANKS   #COAT                           137879
137600200529     C******               MOVE *BLANKS   #STAT                           137879
137700200529     C******               MOVE *BLANKS   #3REFN                          137879
137800200529     C******               MOVE *BLANKS   #3SECN                          137879
137900200529     C******               MOVE *BLANKS   #3EXDT                          137879
138000200529     C******               MOVE *BLANKS   #3STAT                          137879
138100200529     C******               MOVE *BLANKS   #3COAT                          137879
138200200529     C                   ENDIF                                                  E*3
138300200529     C                   ELSE                                                                  13787
138400200529     C     *IN81         IFEQ      '0'                                                         13787
138500200529     C                   MOVEL     'CO00001'     ZAMSID                         Message id.    13787
138600200529     C                   EXSR      ZASNMS                                       Send message   13787
138700200529     C                   ENDIF                                                                 13787
138800200529     C                   ENDIF                                                  E*2
138900200529      *
139000200529      **   SETUP SCREEN TIME
139100200529      *
139200200529     C                   TIME                    ##TME                          Screen time.
139300200529      *
139400200529      **   EXECUTE THE SUBFILE CONTROL RECORD
139500200529      *
139600200529     C                   WRITE     #MSGCTL
139700200529     C                   WRITE     SE7502F1
139800200529     C                   EXFMT     SE7502C0
139900200529      *
140000200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
140100200529      *
140200200529     C                   CALL      'Y2CLMSC'
140300200529     C                   PARM      ##PGM         ZAPGM            10
140400200529     C                   PARM      '*SAME'       ZAPGRL            5
140500200529      *
140600200529      **   IF NO FUNCTION IS PRESSED AND ALL POSITION/SELECTION FIELDS UNCHANGED
140700200529      **      VALIDATE ALL SUBFILE RECORDS
140800200529      *
140900200529     C     *IN46         IFEQ      '0'                                          B*2
141000200529     C     #REFN         ANDEQ     #3REFN
141100200529     C     #SECN         ANDEQ     #3SECN
141200200529     C     #EXDT         ANDEQ     #3EXDT
141300200529     C     #COAT         ANDEQ     #3COAT
141400200529     C     #STAT         ANDEQ     #3STAT
141500200529     C     WWCPT         ANDNE     *ZEROS
141600200529      *
141700200529      **   REINITIALIZE ERROR INDICATORS
141800200529      *
141900200529     C                   EXSR      P014
142000200529      *
142100200529     C                   EXSR      P008
142200200529     C                   ENDIF                                                  E*2
142300200529      *
142400200529     C                   ENDDO                                                  E*1
142500200529      *
142600200529     C                   ENDSR
142700200529      *****************************************************************
142800200529      /EJECT
142900200529      *****************************************************************
143000200529      * P003   : TERMINATION PROCESSING                               *
143100200529      *****************************************************************
143200200529      *
143300200529     C     P003          BEGSR
143400200529      *
143500200529      **   ROLLBACK UNCOMMITED CHANGES
143600200529      *
143700200529     C                   ROLBK
143800200529      *
143900200529      **   END OF PROGRAM
144000200529      *
144100200529     C/COPY WNCPYSRC,SE7502C011
144200200529     C                   MOVE      '1'           *INLR
144300200529     C                   RETURN
144400200529      *
144500200529     C                   ENDSR
144600200529      *****************************************************************
144700200529      /EJECT
144800200529      *****************************************************************
144900200529      * P004  - TO CLEAR THE SUBFILE                                  *
145000200529      *****************************************************************
145100200529     C     P004          BEGSR
145200200529      *
145300200529      **   CLEAR SUBFILE
145400200529      *
145500200529     C                   MOVE      '1'           *IN80
145600200529     C                   WRITE     SE7502C0
145700200529     C                   MOVE      '0'           *IN80
145800200529     C                   MOVE      '0'           *IN81
145900200529     C                   Z-ADD     0             #1RRN
146000200529      *
146100200529     C                   ENDSR
146200200529      *****************************************************************
146300200529      /EJECT
146400200529      *****************************************************************
146500200529      * P005   : BUILD THE SUBFILE FOR ADD MODE                       *
146600200529      *****************************************************************
146700200529      *
146800200529     C     P005          BEGSR
146900200529      *
147000200529      **   REINITIALISE POSITION/SELECTION FIELDS (HIDDEN FIELDS ALSO)
147100200529      *
147200200529     C                   EXSR      P017
147300200529      *
147400200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
147500200529      *
147600200529     C                   CALL      'Y2CLMSC'
147700200529     C                   PARM      ##PGM         ZAPGM            10
147800200529     C                   PARM      '*SAME'       ZAPGRL            5
147900200529      *
148000200529      **   LOAD A BLANK SUBFILE PAGE
148100200529      *
148200200529     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
148300200529      *
148400200529      **   INIT SCREEN LINE NUMBER
148500200529      *
148600200529     C                   Z-ADD     0             WWCPT             2 0
148700200529      *
148800200529      **   LOAD SUBFILE
148900200529      *
149000200529     C*****WWCPT         DOWLT     15                                           B*1           CSE016
149100200529     C     WWCPT         DOWLT     7                                                          CSE016
149200200529      *
149300200529     C                   ADD       1             #1RRN                81        SFLRCDNBR
149400200529     C                   ADD       1             WWCPT                          SCREEN LINE NBR
149500200529      *
149600200529      **   CLEAR SFL FIELDS
149700200529      *
149800200529     C                   EXSR      P015
149900200529      *
150000200529      **   ADD RECORD IN SUBFILE
150100200529      *
150200200529     C                   WRITE     SE7502S0
150300200529     C                   ENDDO                                                  E*1
150400200529      *
150500200529      **   SAVE POSITION
150600200529      *
150700200529     C                   Z-ADD     #1RRN         WWRRN                          SAVE SFL.RCD.NBR.
150800200529      *
150900200529     C                   ENDSR
151000200529      *****************************************************************
151100200529      /EJECT
151200200529      *****************************************************************
151300200529      * P006   : BUILD THE SUBFILE FOR AMEND/ENQUIRY MODE             *
151400200529      *****************************************************************
151500200529      *
151600200529     C     P006          BEGSR
151700200529      *
151800200529      **   LOAD A BLANK SUBFILE PAGE
151900200529      *
152000200529     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
152100200529      *
152200200529      **   IF ROLLUP (AMEND/ENQUIRY), SET KEY BY LAST RECORD OF PREVIOUS SCREEN
152300200529      *
152400200529     C     *IN27         IFEQ      '1'                                          B*1
152500200529     C     *IN43         ANDEQ     '1'
152600200529     C     *IN27         OREQ      '1'
152700200529     C     *IN61         ANDEQ     '1'
152800200529      *
152900200529     C     #1RRN         CHAIN     SE7502S0                           88
153000200529     C                   MOVE      #1REFN        KREFN
153100200529     C                   MOVE      #1SECN        KSECN
153200200529      *
153300200529     C                   MOVE      #1EXDT        ZDATE
153400200529     C                   EXSR      ZDATE1
153500200529     C                   Z-ADD     ZDAYNO        KEXDT
153600200529      *
153700200529     C                   ELSE                                                   X*1
153800200529      *
153900200529      **   SET KEY FIELDS BY NEW 'SELECT/POSITION TO' FIELD(S)
154000200529      *
154100200529     C     #REFN         IFNE      *BLANKS                                      B*2
154200200529     C     #SECN         ORNE      *BLANKS
154300200529     C     #EXDT         ORNE      *BLANKS
154400200529     C                   MOVE      #REFN         KREFN
154500200529     C                   MOVE      #SECN         KSECN
154600200529     C                   MOVE      #EXDT         ZDATE
154700200529     C                   EXSR      ZDATE1
154800200529     C                   Z-ADD     ZDAYNO        KEXDT
154900200529     C                   ENDIF                                                  E*2
155000200529      *                                                                   136930
155100200529     C     #REFN         IFEQ      *BLANKS                                                     13693
155200200529     C     #SECN         ANDEQ     *BLANKS                                                     13693
155300200529     C     #EXDT         ANDEQ     *BLANKS                                                     13693
155400200529     C     *IN55         ANDEQ     '1'                                                         13787
155500200529     C******     #COAT     IFNE *BLANKS                            136930 137879
155600200529     C******     #STAT     ORNE *BLANKS                            136930 137879
155700200529     C     CSE020        IFEQ      'N'                                                        CSE020
155800200529     C     CSE020        OREQ      'Y'                                                        CSE020
155900200529     C     #COAT         ANDNE     *BLANKS                                                    CSE020
156000200529     C     CSE020        OREQ      'Y'                                                        CSE020
156100200529     C     #STAT         ANDNE     *BLANKS                                                    CSE020
156200200529     C                   MOVE      *HIVAL        KREFN                                         13693
156300200529     C                   ELSE                                                                 CSE020
156400200529     C                   Z-ADD     1             W#RRN                                        CSE020
156500200529     C                   ENDIF                                                                CSE020
156600200529     C******               ENDIF                                   136930 137879
156700200529     C                   ENDIF                                                                 13693
156800200529      *                                                                   136930
156900200529     C                   ENDIF                                                  E*1
157000200529      *                                                                                       CSE020
157100200529      ** Call SE7502M to write records to SECORFPM to show                                    CSE020
157200200529      ** Interdependencies                                                                    CSE020
157300200529      *                                                                                       CSE020
157400200529     C                   MOVE      'N'           WDMNO             1                          CSE020
157500200529     C     CSE020        IFEQ      'Y'                                                        CSE020
157600200529     C     WIN45         IFEQ      '0'                                                        CSE020
157700200529      *                                                                                       CSE020
157800200529     C     WOPEN         IFEQ      'Y'                                                        CSE020
157900200529     C                   CLOSE     SECORFPM                                                   CSE020
158000200529     C                   MOVE      'N'           WOPEN                                        CSE020
158100200529     C                   ENDIF                                                                CSE020
158200200529     C                   CALLB     'SE7502M'                                                  CSE020
158300200529     C                   PARM                    P#MBR                                        CSE020
158400200529     C                   Z-ADD     1             W#RRN                                        CSE020
158500200529      *                                                                                       CSE020
158600200529     C     WOPEN         IFEQ      'N'                                                        CSE020
158700200529     C                   OPEN      SECORFPM                                                   CSE020
158800200529     C                   MOVE      'Y'           WOPEN                                        CSE020
158900200529     C                   ENDIF                                                                CSE020
159000200529      *                                                                                       CSE020
159100200529     C     CSE020        IFEQ      'Y'                                                        CSE020
159200200529     C     #REFN         ANDEQ     *BLANKS                                                    CSE020
159300200529     C     #SECN         ANDEQ     *BLANKS                                                    CSE020
159400200529     C     #EXDT         ANDEQ     *BLANKS                                                    CSE020
159500200529     C     #COAT         ANDEQ     *BLANKS                                                    CSE020
159600200529     C     #STAT         ANDEQ     *BLANKS                                                    CSE020
159700200529     C                   MOVE      '1'           *IN45                                        CSE020
159800200529     C                   ELSE                                                                 CSE020
159900200529     C                   MOVE      '0'           *IN45                                        CSE020
160000200529     C                   ENDIF                                                                CSE020
160100200529     C                   ENDIF                                                                CSE020
160200200529      *                                                                                       CSE020
160300200529      ** Set flag to 'Y' if CSE020 is installed and all review fields                         CSE020
160400200529      ** are blanks to know if SECORFPM is the file to be used in                             CSE020
160500200529      ** building subfile                                                                     CSE020
160600200529      *                                                                                       CSE020
160700200529     C     #REFN         IFEQ      *BLANKS                                                    CSE020
160800200529     C     #SECN         ANDEQ     *BLANKS                                                    CSE020
160900200529     C     #EXDT         ANDEQ     *BLANKS                                                    CSE020
161000200529     C     #COAT         ANDEQ     *BLANKS                                                    CSE020
161100200529     C     #STAT         ANDEQ     *BLANKS                                                    CSE020
161200200529     C                   MOVE      'Y'           WDMNO                                        CSE020
161300200529     C                   ENDIF                                                                CSE020
161400200529     C                   ENDIF                                                                CSE020
161500200529      *
161600200529      **   POSITION INTO ER REFERENCE FILE
161700200529      *
161800200529     C                   EXSR      R001
161900200529      *
162000200529      **   READ NEXT RECORD OF THE ER REFERENCE FILE
162100200529      *
162200200529     C                   EXSR      R002
162300200529      *
162400200529      **   INIT SCREEN LINE NUMBER
162500200529      *
162600200529     C                   Z-ADD     0             WWCPT             2 0
162700200529     C     CSE020        IFEQ      'Y'                                                        CSE020
162800200529     C     W#RRN         ANDGT     0                                                          CSE020
162900200529     C                   SUB       1             W#RRN                                        CSE020
163000200529     C                   ENDIF                                                                CSE020
163100200529      *
163200200529      **   LOAD SUBFILE
163300200529      *
163400200529     C     *IN30         DOWEQ     '0'                                          B*1
163500200529     C*****WWCPT         ANDLT     15                                                         CSE016
163600200529     C     WWCPT         ANDLT     7                                                          CSE016
163700200529      *
163800200529      **  RETRIEVE THE "HIGHER" STATUS AND FINAL ALLOCATION INDICATOR
163900200529      *
164000200529     C                   MOVE      *BLANKS       #1STAT
164100200529     C                   MOVE      *BLANKS       #1FINA
164200200529     C                   MOVE      'Y'           WFIRST            1
164300200529      *
164400200529     C     MACORF        SETLL     SECODRL1
164500200529     C     MACORF        READE     SECODRL1                               89
164600200529      *                                                                   137879
164700200529     C     *IN89         IFEQ      '1'                                          B*6            13787
164800200529     C                   MOVE      MASTAT        #1STAT                                        13787
164900200529     C                   ENDIF                                                  E*6            13787
165000200529      *
165100200529     C     *IN89         DOWEQ     '0'                                          B*6
165200200529      *
165300200529     C     MSRECI        IFEQ      'D'                                          B*6A
165400200529      *
165500200529     C     WFIRST        IFEQ      'Y'                                          B*7
165600200529     C                   MOVE      MSFAID        #1FINA
165700200529     C                   MOVE      MSCOST        #1STAT
165800200529     C                   MOVE      'N'           WFIRST
165900200529     C                   ELSE                                                   X*7
166000200529      *
166100200529      **  RETRIEVE THE "HIGHER" FINAL ALLOCATION INDICATOR
166200200529      *
166300200529     C     MSFAID        IFEQ      'Y'                                          B*8
166400200529     C                   MOVE      MSFAID        #1FINA
166500200529     C                   ELSE                                                   X*8
166600200529     C     MSFAID        IFEQ      'S'                                          B*9
166700200529     C     #1FINA        ANDEQ     'N'
166800200529     C                   MOVE      MSFAID        #1FINA
166900200529     C                   ENDIF                                                  E*9
167000200529     C                   ENDIF                                                  E*8
167100200529      *
167200200529      **  RETRIEVE THE "HIGHER" STATUS
167300200529      *
167400200529     C     MSCOST        IFEQ      'C'                                          B*8
167500200529     C                   MOVE      MSCOST        #1STAT
167600200529     C                   ELSE                                                   X*8
167700200529     C     MSCOST        IFEQ      'X'                                          B*9
167800200529     C     #1STAT        IFEQ      'S'                                          B10
167900200529     C     #1STAT        OREQ      'L'
168000200529     C     #1STAT        OREQ      'I'
168100200529     C                   MOVE      MSCOST        #1STAT
168200200529     C                   ENDIF                                                  E*10
168300200529     C                   ENDIF                                                  E*9
168400200529      *
168500200529     C     MSCOST        IFEQ      'S'                                          B*9
168600200529     C     #1STAT        IFEQ      'L'                                          B10
168700200529     C     #1STAT        OREQ      'I'
168800200529     C                   MOVE      MSCOST        #1STAT
168900200529     C                   ENDIF                                                  E*10
169000200529     C                   ENDIF                                                  E*9
169100200529      *
169200200529     C     MSCOST        IFEQ      'L'                                          B*9
169300200529     C     #1STAT        ANDEQ     'I'
169400200529     C                   MOVE      MSCOST        #1STAT
169500200529     C                   ENDIF                                                  E*9
169600200529     C                   ENDIF                                                  E*8
169700200529     C                   ENDIF                                                  E*7
169800200529     C                   ENDIF                                                  E*6A
169900200529      *
170000200529     C     MACORF        READE     SECODRL1                               89
170100200529     C                   ENDDO                                                  E*6
170200200529      *
170300200529     C     #1FINA        IFEQ      *BLANKS                                      B*6
170400200529     C     #1STAT        ANDEQ     *BLANKS
170500200529     C                   MOVE      'N'           #1FINA
170600200529     C                   MOVE      'I'           #1STAT
170700200529     C                   ENDIF                                                  E*6
170800200529      *
170900200529      **   IF ONE OF THE 'SELECTION' FIELD IS NOT BLANK
171000200529      **    CHECK IF THE RECORD MUST BE TAKEN OR NOT IN THE SUBFILE
171100200529      *
171200200529     C     #STAT         IFNE      *BLANKS                                      B*2
171300200529      *
171400200529     C     #STAT         IFNE      MASTAT                                       B*3
171500200529     C                   GOTO      TAG1
171600200529     C                   ENDIF                                                  E*3
171700200529      *
171800200529     C                   ENDIF                                                  E*2
171900200529      *
172000200529     C     #COAT         IFNE      *BLANKS                                      B*2
172100200529      *
172200200529     C     #COAT         IFNE      MACOAT                                       B*3
172300200529     C                   GOTO      TAG1
172400200529     C                   ENDIF                                                  E*3
172500200529      *
172600200529     C                   ENDIF                                                  E*2
172700200529      *
172800200529      **   IF AMEND MODE AND CMD 9 NOT PRESSED
172900200529      **   OR IF ADD MODE AND CMD 9 PRESSED
173000200529      *
173100200529     C     *IN43         IFEQ      '1'                                          B*2
173200200529     C     *IN09         ANDEQ     '0'
173300200529     C     *IN43         OREQ      '0'
173400200529     C     *IN09         ANDEQ     '1'
173500200529      *
173600200529      **   IF 'LOCKED BY USER IDENTIFIER' IS NOT BLANK
173700200529      **     PROTECT ALL SUBFILE RECORD FIELDS
173800200529      *
173900200529     C     MAUSER        IFNE      *BLANKS                                      B*3
174000200529     C                   MOVE      '1'           *IN63
174100200529     C                   ELSE                                                   X*3
174200200529     C                   MOVE      '0'           *IN63
174300200529     C                   ENDIF                                                  E*3
174400200529      *
174500200529      **   IF 'CORPORATE ACTION STATUS' IS 'I' OR 'L' AND FINAL INDICATOR 'N'
174600200529      **     NON-PROTECT 'EX-DATE' SUBFILE FIELD
174700200529      *
174800200529     C     #1STAT        IFEQ      'I'                                          B*3
174900200529     C     #1STAT        OREQ      'L'
175000200529     C     #1FINA        ANDEQ     'N'
175100200529     C                   MOVE      '0'           *IN59
175200200529     C                   ELSE                                                   X*3
175300200529     C                   MOVE      '1'           *IN59
175400200529     C                   ENDIF                                                  E*3
175500200529      *
175600200529      **   IF 'CORPORATE ACTION STATUS' IS EQUAL TO S/X/C/R, PROTECT ALLOCATION
175700200529      *
175800200529     C     #1STAT        IFEQ      'S'                                          B*3
175900200529     C     #1STAT        OREQ      'X'
176000200529     C     #1STAT        OREQ      'C'
176100200529     C     #1STAT        OREQ      'R'
176200200529     C                   MOVE      '0'           *IN48
176300200529     C                   ELSE                                                   X*3
176400200529     C                   MOVE      '1'           *IN48
176500200529     C                   ENDIF                                                  E*3
176600200529     C                   ENDIF                                                  E*2
176700200529      *
176800200529     C/COPY WNCPYSRC,SEH00001
176900200529      **   IF 'CORPORATE ACTION STATUS' IS 'C' OR 'R', PROTECT DATE OF ANNOUNCEM
177000200529      *
177100200529     C     #1STAT        IFEQ      'C'                                          B*3
177200200529     C     #1STAT        OREQ      'R'
177300200529     C                   MOVE      '1'           *IN75
177400200529     C                   ELSE                                                   X*3
177500200529     C                   MOVE      '0'           *IN75
177600200529     C                   ENDIF                                                  E*3
177700200529      *
177800200529     C                   ADD       1             #1RRN                81        SFLRCDNBR
177900200529     C                   ADD       1             WWCPT                          SCREEN LINE NBR
178000200529      *
178100200529      **   CLEAR SFL FIELDS
178200200529      *
178300200529     C                   EXSR      P015
178400200529      *
178500200529      **   LOAD SFL FIELDS
178600200529      *
178700200529     C                   EXSR      P016
178800200529      *
178900200529      **   ADD RECORD IN SUBFILE
179000200529      *
179100200529     C                   WRITE     SE7502S0
179200200529      *
179300200529     C     TAG1          TAG
179400200529      *
179500200529      **   READ NEXT RECORD OF THE ER REFERENCE FILE
179600200529      *
179700200529     C                   EXSR      R002
179800200529      *
179900200529      **   END OF DO WHILE
180000200529      *
180100200529     C                   ENDDO                                                  E*1
180200200529      *
180300200529      **   SAVE POSITION
180400200529      *
180500200529     C                   Z-ADD     #1RRN         WWRRN                          SAVE SFL.RCD.NBR.
180600200529      *
180700200529      **   IF IT'S NOT A ROLLUP
180800200529      *
180900200529     C     *IN27         IFEQ      '0'                                          B*1
181000200529     C                   Z-ADD     1             #1RRN
181100200529     C                   ENDIF                                                  E*1
181200200529      *
181300200529      **   IF NO RECORDS FOUND, DISPLAY ERROR MESSAGE
181400200529      **   SEND MESSAGE 'NO DATA TO DISPLAY'
181500200529      *
181600200529     C     WWCPT         IFEQ      *ZEROS                                       B*1
181700200529     C                   MOVEL     'CO00001'     ZAMSID                         Message id.
181800200529     C                   EXSR      ZASNMS                                       Send message
181900200529     C                   ENDIF                                                  E*1
182000200529      *
182100200529     C                   ENDSR
182200200529      *****************************************************************
182300200529      /EJECT
182400200529      *****************************************************************
182500200529      * P007   : VALIDATE POSITION/SELECTION FIELDS                   *
182600200529      *****************************************************************
182700200529      *
182800200529     C     P007          BEGSR
182900200529      *
183000200529     C***********        MOVE      '0'           *IN53                          Access by Sec CSE020
183100200529     C                   MOVE      '0'           WIN53                          Access by Sec CSE020
183200200529     C                   MOVE      '0'           *IN54                          Access by Ex-D. & Se
183300200529     C                   MOVE      '0'           *IN55                          Access by Reference
183400200529     C                   MOVE      '0'           *IN89                          Valid Numeric Field
183500200529      *
183600200529      **   IF REFERENCE NUMBER IS DIFFERENT THEN BLANKS
183700200529      *
183800200529     C     #REFN         IFNE      *BLANKS                                      B*1
183900200529      *
184000200529      **   CHECK IT'S A VALID NUMERIC FIELD
184100200529      *
184200200529     C     DIGITS        CHECK     #REFN:1       N                 1 0    89
184300200529      *
184400200529      **   IF IT'S NOT A VALID NUMERIC FIELD
184500200529      *
184600200529     C     *IN89         IFEQ      '1'                                          B*2
184700200529     C                   MOVE      '1'           *IN50                          Reverse image
184800200529     C                   MOVEL     'CO00004'     ZAMSID                         Message id.
184900200529     C                   EXSR      ZASNMS                                       Send message
185000200529     C                   ENDIF                                                  E*2
185100200529      *
185200200529      **   IF SECURITY OR EX-DATE IS/ARE DIFFERENT THAN BLANKS
185300200529      *
185400200529     C     #SECN         IFNE      *BLANKS                                      B*2
185500200529     C     #EXDT         ORNE      *BLANKS
185600200529     C                   MOVE      '1'           *IN50                          Reverse image
185700200529     C                   MOVEL     'CO00030'     ZAMSID                         Message id.
185800200529     C                   EXSR      ZASNMS                                       Send message
185900200529     C                   ENDIF                                                  E*2
186000200529     C                   ENDIF                                                  E*1
186100200529      *
186200200529      **   IF EX-DATE IS DIFFERENT THAN BLANKS
186300200529      *
186400200529     C     #EXDT         IFNE      *BLANKS                                      B*1
186500200529      *
186600200529      **   VERIFY IF IT'S A VALID DATE FORMAT
186700200529      *
186800200529     C                   MOVE      #EXDT         ZDATE
186900200529     C                   EXSR      ZDATE1
187000200529      *
187100200529      **   IT'S NOT A VALID DATE FORMAT
187200200529      *
187300200529     C     *IN99         IFEQ      '1'                                          B*2
187400200529     C                   MOVE      '1'           *IN52                          Reverse image
187500200529     C                   MOVEL     'CO00006'     ZAMSID                         Message id.
187600200529     C                   EXSR      ZASNMS                                       Send message
187700200529     C                   ENDIF                                                  E*2
187800200529     C                   ENDIF                                                  E*1
187900200529      *
188000200529      **   IF 'TYPE' IS DIFFERENT THAN BLANKS
188100200529      *
188200200529     C     #COAT         IFNE      *BLANKS                                      B*1
188300200529      *
188400200529      **   CORPORATE ACTION TYPE MUST BE A LIVE ACTION TYPE
188500200529      *
188600200529     C     #COAT         CHAIN     SECOATL0                           89
188700200529      *
188800200529     C     *IN89         IFEQ      '1'
188900200529     C     MMRECI        ORNE      'D'
189000200529     C                   MOVE      '1'           *IN69                          Reverse image
189100200529     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
189200200529     C                   EXSR      ZASNMS                                       Send message
189300200529     C                   ENDIF                                                  E*2
189400200529     C                   ENDIF                                                  E*1
189500200529      *
189600200529      **   IF 'STATUS' IS DIFFERENT THAN BLANKS
189700200529      *
189800200529     C     #STAT         IFNE      *BLANKS                                      B*1
189900200529      *
190000200529      **   IF 'STATUS' IS NOT A VALID STATUS (I, L, X, S, C, R)
190100200529      *
190200200529     C     #STAT         IFNE      'I'                                          B*2
190300200529     C     #STAT         ANDNE     'L'
190400200529     C     #STAT         ANDNE     'X'
190500200529     C     #STAT         ANDNE     'S'
190600200529     C     #STAT         ANDNE     'C'
190700200529     C     #STAT         ANDNE     'R'
190800200529     C                   MOVE      '1'           *IN86                          Reverse image
190900200529     C                   MOVEL     'CO00008'     ZAMSID                         Message id.
191000200529     C                   EXSR      ZASNMS                                       Send message
191100200529     C                   ENDIF                                                  E*2
191200200529     C                   ENDIF                                                  E*1
191300200529      *
191400200529      **   IF NO ERROR INDICATOR ON
191500200529      *
191600200529     C     *IN50         IFEQ      '0'                                          B*1
191700200529     C     *IN51         ANDEQ     '0'
191800200529     C     *IN52         ANDEQ     '0'
191900200529     C     *IN69         ANDEQ     '0'
192000200529     C     *IN86         ANDEQ     '0'
192100200529      *
192200200529     C                   MOVE      #REFN         #3REFN
192300200529     C                   MOVE      #COAT         #3COAT
192400200529     C                   MOVE      #STAT         #3STAT
192500200529     C                   MOVE      #EXDT         #3EXDT
192600200529      *
192700200529      **   IF SECURITY FIELD IS SELECTED
192800200529      *
192900200529     C     #SECN         IFNE      *BLANKS                                      B*2
193000200529      *
193100200529     C                   MOVE      #SECN         #3SECN
193200200529      *
193300200529      **   SETON AN INDICATOR TO DETERMINE THAN THE ACCESS IN THE ER REFERENCE
193400200529      **   MUST BE DONE BY SECURITY AND EX-DATE AND REFERENCE
193500200529      *
193600200529     C***********        MOVE      '1'           *IN53                                        CSE020
193700200529     C                   MOVE      '1'           WIN53                                        CSE020
193800200529     C                   MOVE      #EXDT         #3EXDT
193900200529      *
194000200529      **   ELSE, SECURITY FIELD IS LEAVED BLANK
194100200529      *
194200200529     C                   ELSE                                                   X*2
194300200529     C                   MOVE      *BLANKS       #3SECN
194400200529      *
194500200529      **   IF EX-DATE FIELD IS SELECTED, SETON AN INDICATOR TO DETERMINE
194600200529      **   THAN THE ACCESS IN THE ER REFERENCE FILE MUST BE DONE BY EX-DATE
194700200529      **   AND SECURITY FIELDS
194800200529      *
194900200529     C     #EXDT         IFNE      *BLANKS                                      B*3
195000200529     C                   MOVE      #EXDT         #3EXDT
195100200529     C                   MOVE      '1'           *IN54
195200200529      *
195300200529      **   ELSE, SECURITY AND EX-DATE FIELD ARE LEAVED BLANK, SETON AN INDICATOR
195400200529      **   TO DETERMINE THAT THE ACCESS IN THE ER REFERENCE FILE MUST BE DONE
195500200529      **   BY REFERENCE
195600200529      *
195700200529     C                   ELSE                                                   B*3
195800200529     C                   MOVE      *BLANKS       #3EXDT
195900200529     C                   MOVE      '1'           *IN55
196000200529     C                   ENDIF                                                  E*3
196100200529      *
196200200529     C                   ENDIF                                                  E*2
196300200529     C                   ENDIF                                                  E*1
196400200529      *                                                                                       CSE020
196500200529      ** Do not display level column if either Security, Ex-date,                             CSE020
196600200529      ** Type or Status is non-blank.                                                         CSE020
196700200529      *                                                                                       CSE020
196800200529     C     CSE020        IFEQ      'Y'                                                        CSE020
196900200529     C     #REFN         ANDEQ     *BLANKS                                                    CSE020
197000200529     C     #SECN         ANDEQ     *BLANKS                                                    CSE020
197100200529     C     #EXDT         ANDEQ     *BLANKS                                                    CSE020
197200200529     C     #COAT         ANDEQ     *BLANKS                                                    CSE020
197300200529     C     #STAT         ANDEQ     *BLANKS                                                    CSE020
197400200529     C                   MOVE      '1'           *IN45                                        CSE020
197500200529     C                   ELSE                                                                 CSE020
197600200529     C                   MOVE      '0'           *IN45                                        CSE020
197700200529     C                   ENDIF                                                                CSE020
197800200529      *
197900200529     C                   ENDSR
198000200529      *
198100200529      *****************************************************************
198200200529      /EJECT
198300200529      *****************************************************************
198400200529      * P008   : VALIDATE SUBFILE RECORDS                             *
198500200529      *****************************************************************
198600200529      *
198700200529     C     P008          BEGSR
198800200529      *
198900200529     C                   MOVE      'N'           ERMSG             1
199000200529      *
199100200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
199200200529      *
199300200529     C/COPY WNCPYSRC,SE7502C012
199400200529     C                   CALL      'Y2CLMSC'
199500200529     C                   PARM      ##PGM         ZAPGM            10
199600200529     C                   PARM      '*SAME'       ZAPGRL            5
199700200529      *
199800200529      **   READ CHANGED SUBFILE RECORD
199900200529      *
200000200529     C                   READC     SE7502S0                               87
200100200529     C/COPY WNCPYSRC,SE7502C013
200200200529      *
200300200529      **   SETUP THE RRN WITH THE CURRENT CPF'S POSITION WITHIN THE SUBFILE
200400200529      *
200500200529     C     *IN87         IFEQ      '1'                                          B*1
200600200529     C                   Z-ADD     CPFPOS        #1RRN
200700200529     C                   ENDIF                                                  E*1
200800200529      *
200900200529      **   DO WHILE END OF FILE IS NOT REACHED AND F12 OR F3 NOT PRESSED
201000200529      *
201100200529     C     *IN87         DOWEQ     '0'                                          B*1
201200200529     C     *INKC         ANDEQ     '0'
201300200529     C     *INKL         ANDEQ     '0'
201400200529      *
201500200529      **   REINITIALIZE ERROR INDICATORS
201600200529      *
201700200529     C                   EVAL      WREDSP = 'N'                                               215168
201800200529     C                   EXSR      P014
201900200529      *
202000200529     C                   MOVE      '1'           *IN84                          SFLNXTCHG
202100200529      *
202200200529      **   IF 'ADD MODE'
202300200529      *
202400200529     C     *IN43         IFEQ      '0'                                          B*2
202500200529     C     *IN61         ANDEQ     '0'
202600200529      *
202700200529      **   IF AT LEAST ONE FIELD IS DIFFERENT THAN BLANKS
202800200529      *
202900200529     C     #1SECN        IFNE      *BLANKS                                      B*3
203000200529     C     #1COAT        ORNE      *BLANKS
203100200529     C     #1COAN        ORNE      *BLANKS
203200200529     C     #1EXDT        ORNE      *BLANKS
203300200529     C     #1ALEF        ORNE      *BLANKS
203400200529     C     #1NBOP        ORNE      *BLANKS
203500200529      *
203600200529      **   IF 'SECURITY SHORTNAME' LEFT BLANK
203700200529      *
203800200529     C     #1SECN        IFEQ      *BLANKS                                      B*4
203900200529     C                   MOVE      'Y'           ERMSG
204000200529     C                   MOVE      '1'           *IN39                          Reverse image
204100200529     C                   MOVEL     'CO00005'     ZAMSID                         Message id.
204200200529     C                   EXSR      ZASNMS                                       Send message
204300200529     C                   ELSE                                                   X*4
204400200529      *
204500200529      **   CHECK SECURITY SHORTNAME
204600200529      *
204700200529     C/COPY WNCPYSRC,SE7502C002
204800200529      *
204900200529      **   ACCESS SECURITY DETAILS WITH CURRENT SECURITY SHORTNAME
205000200529      *
205100200529     C     CSE010        IFEQ      'Y'                                                        215168
205200200529     C     '?'           SCAN      #1SECN                                 01                  215168
205300200529     C                   IF        *IN01                                                      215168
205400200529     C                   CALL      'SE0043'                                                   215168
205500200529     C                   PARM                    WLACTN                                       215168
205600200529     C                   PARM      '?'           WSECN                                        215168
205700200529      *                                                                                       215168
205800200529     C                   IF        WSECN <> *BLANKS                                           215168
205900200529     C                   EVAL      #1SECN = WSECN                                             215168
206000200529     C                   ELSE                                                                 215168
206100200529     C                   EVAL      #1SECN = *BLANKS                                           215168
206200200529     C                   ENDIF                                                                215168
206300200529     C                   EVAL      WREDSP = 'Y'                                               215168
206400200529     C                   ENDIF                                                                215168
206500200529     C                   ENDIF                                                                215168
206600200529      *                                                                                       215168
206700200529     C     #1SECN        CHAIN     SECTYZ1                            89
206800200529      *
206900200529      **   IF RECORD IS NOT FOUND OR IS FOUND BUT NOT "LIVE"
207000200529      *
207100200529     C     *IN89         IFEQ      '1'                                          B*5
207200200529     C     *IN89         OREQ      '0'
207300200529     C     RECI          ANDNE     'D'
207400200529     C                   MOVE      'Y'           ERMSG
207500200529     C                   MOVE      '1'           *IN39                          Reverse image
207600200529     C                   MOVEL     'CO00007'     ZAMSID                         Message id.
207700200529     C                   EXSR      ZASNMS                                       Send message
207800200529     C                   ELSE                                                   X*5
207900200529      *
208000200529      **   FOR CORPORATE ACTION WITH PROCESSING TYPE 'DV'
208100200529      *
208200200529     C     MMPTYP        IFEQ      'DV'                                         B*6
208300200529      *
208400200529      **   ACCESS INVESTMENT TYPE FILE
208500200529      *
208600200529     C                   MOVE      NMCY          KNMCY             3
208700200529     C                   MOVE      SITP          KSITP             3
208800200529      *
208900200529     C     KEY3          CHAIN     INVTP                              89
209000200529      *
209100200529      **   IF NO RECORD FOUND
209200200529      *
209300200529     C     *IN89         IFEQ      '1'                                          B*7
209400200529     C                   MOVEL     NMCY          WFLD1             6
209500200529     C                   MOVE      SITP          WFLD1
209600200529     C                   MOVEL     '005'         DBASE                          *****************
209700200529     C                   MOVE      'INVTP   '    DBFILE                         * DB ERROR 05   *
209800200529     C                   MOVEL     WFLD1         DBKEY                          *****************
209900200529     C                   EXSR      *PSSR
210000200529     C                   ENDIF                                                  E*7
210100200529      *
210200200529      **   PROCESSING TYPE MUST BE '4' OR '7'
210300200529      *
210400200529     C     PROT          IFNE      '4'                                          B*7
210500200529     C     PROT          ANDNE     '7'
210600200529     C                   MOVE      'Y'           ERMSG
210700200529     C                   MOVE      '1'           *IN39                          Reverse image
210800200529     C                   MOVEL     'CO00012'     ZAMSID                         Message id.
210900200529     C                   EXSR      ZASNMS                                       Send message
211000200529     C                   ENDIF                                                  E*7
211100200529     C                   ENDIF                                                  E*6
211200200529     C                   ENDIF                                                  E*5
211300200529     C                   ENDIF                                                  E*4
211400200529      *
211500200529      **   IF 'ACTION TYPE' LEFT BLANK
211600200529      *
211700200529     C     #1COAT        IFEQ      *BLANKS                                      B*4
211800200529     C                   MOVE      'Y'           ERMSG
211900200529     C                   MOVE      '1'           *IN33                          Reverse image
212000200529     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
212100200529     C                   EXSR      ZASNMS                                       Send message
212200200529     C                   ELSE                                                   X*4
212300200529      *                                                                                       215168
212400200529     C     '?'           SCAN      #1COAT                                 01                  215168
212500200529     C                   IF        *IN01                                                      215168
212600200529     C                   CALL      'SE7501S'                                                  215168
212700200529     C                   PARM      '?'           WCOAT                                        215168
212800200529      *                                                                                       215168
212900200529     C                   IF        WCOAT <> *BLANKS                                           215168
213000200529     C                   EVAL      #1COAT = WCOAT                                             215168
213100200529     C                   ELSE                                                                 215168
213200200529     C                   EVAL      #1COAT = *BLANKS                                           215168
213300200529     C                   ENDIF                                                                215168
213400200529     C                   EVAL      WREDSP = 'Y'                                               215168
213500200529     C                   ENDIF                                                                215168
213600200529      *
213700200529      **   CORPORATE ACTION TYPE MUST BE A LIVE ACTION TYPE
213800200529      *
213900200529     C     #1COAT        CHAIN     SECOATL0                           89
214000200529      *
214100200529     C     *IN89         IFEQ      '1'                                          B*5
214200200529     C     MMRECI        ORNE      'D'
214300200529     C                   MOVE      'Y'           ERMSG
214400200529     C                   MOVE      '1'           *IN33                          Reverse image
214500200529     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
214600200529     C                   EXSR      ZASNMS                                       Send message
214700200529     C                   ENDIF                                                  E*5
214800200529      *                                                                   136419
214900200529     C     *IN89         IFEQ      '0'                                          B*5            13641
215000200529     C     MMPTYP        ANDEQ     'CC'                                                        13641
215100200529     C                   MOVE      'Y'           ERMSG                                         13641
215200200529     C                   MOVE      '1'           *IN33                          Reverse image  13641
215300200529     C                   MOVEL     'CO00577'     ZAMSID                         Message id.    13641
215400200529     C                   EXSR      ZASNMS                                       Send message   13641
215500200529     C                   ENDIF                                                  E*5            13641
215600200529     C                   ENDIF                                                  E*4
215700200529      *
215800200529      **   VALIDATION 'NUMBER OF OPTION'
215900200529      *
216000200529     C     #1NBOP        IFNE      *BLANKS                                      B*4
216100200529      *
216200200529     C                   MOVE      *BLANKS       ZFIELD
216300200529     C                   MOVEL     #1NBOP        ZFIELD
216400200529     C                   Z-ADD     2             ZADIG
216500200529     C                   Z-ADD     0             ZADEC
216600200529     C                   EXSR      ZALIGN
216700200529     C                   MOVE      ZFIELD        #1NBOP
216800200529     C                   MOVE      #1NBOP        W1NBOP
216900200529      *
217000200529      **   IF IT'S NOT A VALID NUMERIC FIELD BETWEEN 1 AND 9
217100200529      *
217200200529     C     *IN99         IFEQ      '1'                                          B*5
217300200529     C     W1NBOP        ORLT      1
217400200529     C     W1NBOP        ORGT      9
217500200529     C                   MOVE      'Y'           ERMSG
217600200529     C                   MOVE      '1'           *IN29                          Reverse image
217700200529     C                   MOVEL     'CO00042'     ZAMSID                         Message id.
217800200529     C                   EXSR      ZASNMS                                       Send message
217900200529     C                   ELSE                                                   X*5
218000200529     C     MMPTYP        IFEQ      'NF'                                         B*6
218100200529     C     W1NBOP        ANDNE     1
218200200529     C     MMPTYP        OREQ      'NC'
218300200529     C     W1NBOP        ANDNE     1
218400200529     C     MMPTYP        OREQ      'CC'                                                        CEU01
218500200529     C     W1NBOP        ANDNE     1                                                           CEU01
218600200529     C/COPY WNCPYSRC,SE7502C014
218700200529     C                   MOVE      'Y'           ERMSG
218800200529     C                   MOVE      '1'           *IN29                          Reverse image
218900200529     C                   MOVEL     'CO00261'     ZAMSID                         Message id.
219000200529     C                   EXSR      ZASNMS                                       Send message
219100200529     C                   ENDIF                                                  E*6
219200200529     C                   ENDIF                                                  E*5
219300200529      *
219400200529     C                   ELSE                                                   X*4
219500200529     C                   MOVE      '01'          #1NBOP
219600200529     C                   ENDIF                                                  E*4
219700200529      *
219800200529     C                   ENDIF                                                  E*3
219900200529     C                   ENDIF                                                  E*2
220000200529      *
220100200529      **   IF NOT ENQUIRY MODE
220200200529      *
220300200529     C     *IN61         IFEQ      '0'                                          B*2
220400200529      *
220500200529      **   IF AT LEAST ONE FIELD IS DIFFERENT THAN BLANK
220600200529      *
220700200529     C     #1EXDT        IFNE      *BLANKS                                      B*3
220800200529     C     #1REFN        ORNE      *BLANKS
220900200529     C     #1SECN        ORNE      *BLANKS
221000200529     C     #1ALEF        ORNE      *BLANKS
221100200529     C     #1COAN        ORNE      *BLANKS
221200200529      *
221300200529      **   IF LAST ALLOCATION DATE IS CHANGED
221400200529      *
221500200529     C     #1COAN        IFNE      #2COAN                                       B*4
221600200529     C     #1COAN        ANDNE     *BLANKS
221700200529      *
221800200529     C                   MOVE      #1COAN        ZDATE
221900200529     C                   EXSR      ZDATE1
222000200529      *
222100200529      **   IF DATE OF ANNOUNCEMENT IS NOT A VALID DATE FORMAT
222200200529      *
222300200529     C     *IN99         IFEQ      '1'                                          B*5
222400200529     C                   MOVE      'Y'           ERMSG
222500200529     C                   MOVE      '1'           *IN37                          Reverse image
222600200529     C                   MOVEL     'CO00033'     ZAMSID                         Message id.
222700200529     C                   EXSR      ZASNMS                                       Send message
222800200529     C                   ENDIF                                                  E*5
222900200529     C                   ENDIF                                                  E*4
223000200529      *
223100200529      **   IF EX-DATE IS CHANGED
223200200529      *
223300200529     C     #1EXDT        IFNE      #2EXDT                                       B*4
223400200529     C     #1EXDT        ANDNE     *BLANKS
223500200529      *
223600200529     C                   MOVE      #1EXDT        ZDATE
223700200529     C                   EXSR      ZDATE1
223800200529      *
223900200529      **   IF EX-DATE IS NOT A VALID DATE FORMAT
224000200529      *
224100200529     C     *IN99         IFEQ      '1'                                          B*5
224200200529     C                   MOVE      'Y'           ERMSG
224300200529     C                   MOVE      '1'           *IN32                          Reverse image
224400200529     C                   MOVEL     'CO00006'     ZAMSID                         Message id.
224500200529     C                   EXSR      ZASNMS                                       Send message
224600200529     C                   ELSE                                                   X*5
224700200529     C                   Z-ADD     ZDAYNO        WEXDT
224800200529      *
224900200529      **   IF EX-DATE LOWER OR EQUAL THAN SE BACK VALUE DATE
225000200529      *
225100200529     C     WEXDT         IFLE      WBACKD
225200200529     C                   MOVE      'Y'           ERMSG
225300200529     C                   MOVE      '1'           *IN32                          Reverse image
225400200529     C                   MOVEL     'CO00013'     ZAMSID                         Message id.
225500200529     C                   EXSR      ZASNMS                                       Send message
225600200529     C                   ENDIF                                                  E*6
225700200529      *
225800200529      **   IF EX-DATE NOT LOWER THAN SECURITY MATURITY DATE
225900200529      *
226000200529     C     WEXDT         IFGE      MATY                                         B*6
226100200529     C     MATY          ANDNE     *ZEROS
226200200529     C                   MOVE      'Y'           ERMSG
226300200529     C                   MOVE      '1'           *IN32                          Reverse image
226400200529     C                   MOVEL     'CO00014'     ZAMSID                         Message id.
226500200529     C                   EXSR      ZASNMS                                       Send message
226600200529     C                   ENDIF                                                  E*6
226700200529      *                                                                                       CSE020
226800200529      ** Validate Ex-date so that it is equal to that of the Parent                           CSE020
226900200529      *                                                                                       CSE020
227000200529     C     CSE020        IFEQ      'Y'                                                        CSE020
227100200529     C     #1MPRF        ANDNE     *BLANKS                                                    CSE020
227200200529     C     #1MPRF        CHAIN     SECORFL9                           89                      CSE020
227300200529     C     *IN89         IFEQ      '0'                                                        CSE020
227400200529     C     WEXDT         ANDNE     MACOEX                                                     CSE020
227500200529     C                   MOVE      'Y'           ERMSG                                        CSE020
227600200529     C                   MOVE      '1'           *IN32                                        CSE020
227700200529     C                   MOVEL     'CO00368'     ZAMSID                                       CSE020
227800200529     C                   EXSR      ZASNMS                                                     CSE020
227900200529     C                   ENDIF                                                                CSE020
228000200529     C     #1REFN        CHAIN     SECORFL9                           89                      CSE020
228100200529     C                   ENDIF                                                                CSE020
228200200529     C                   ENDIF                                                  E*5
228300200529      *                                                                                       CSE020
228400200529     C                   ELSE                                                                 CSE020
228500200529     C     CSE020        IFEQ      'Y'                                                        CSE020
228600200529     C     #1MPRF        ANDNE     *BLANKS                                                    CSE020
228700200529     C     #1MPRF        CHAIN     SECORFL9                           89                      CSE020
228800200529     C     *IN89         IFEQ      '0'                                                        CSE020
228900200529     C     MACOEX        ANDNE     *ZEROS                                                     CSE020
229000200529     C     #1EXDT        ANDEQ     *BLANKS                                                    CSE020
229100200529     C                   MOVE      'Y'           ERMSG                                        CSE020
229200200529     C                   MOVE      '1'           *IN32                                        CSE020
229300200529     C                   MOVEL     'CO00368'     ZAMSID                                       CSE020
229400200529     C                   EXSR      ZASNMS                                                     CSE020
229500200529     C                   ENDIF                                                                CSE020
229600200529     C     #1REFN        CHAIN     SECORFL9                           89                      CSE020
229700200529     C                   ENDIF                                                                CSE020
229800200529     C                   ENDIF                                                  E*4
229900200529      *
230000200529      **   IF ALLOCATION EFFECTIVE DATE IS CHANGED
230100200529      *
230200200529     C     #1ALEF        IFNE      #2ALEF                                       B*4
230300200529     C     #1ALEF        ANDNE     *BLANKS
230400200529      *
230500200529      **   IF 'ALLOCATION EFFECTIVE DATE' ENTERED
230600200529      *
230700200529     C                   MOVE      #1ALEF        ZDATE
230800200529     C                   EXSR      ZDATE1
230900200529     C                   Z-ADD     ZDAYNO        WALEF
231000200529      *
231100200529      **   IF ALLOCATION EFFECTIVE DATE IS NOT A VALID DATE FORMAT
231200200529      *
231300200529     C     *IN99         IFEQ      '1'                                          B*5
231400200529     C                   MOVE      'Y'           ERMSG
231500200529     C                   MOVE      '1'           *IN28                          Reverse image
231600200529     C                   MOVEL     'CO00041'     ZAMSID                         Message id.
231700200529     C                   EXSR      ZASNMS                                       Send message
231800200529     C                   ENDIF                                                  E*5
231900200529      *
232000200529     C     WALEF         IFLT      WEXDT                                        B*5
232100200529     C     *IN99         ANDEQ     '0'
232200200529     C                   MOVE      'Y'           ERMSG
232300200529     C                   MOVE      '1'           *IN28                          Reverse image
232400200529     C                   MOVEL     'CO00251'     ZAMSID                         Message id.
232500200529     C                   EXSR      ZASNMS                                       Send message
232600200529     C                   ENDIF                                                  E*5
232700200529      *
232800200529      **   IF DATE NOT LOWER THAN SECURITY MATURITY DATE
232900200529      *
233000200529     C     WALEF         IFGE      MATY                                         B*5
233100200529     C     MATY          ANDNE     *ZEROS
233200200529     C                   MOVE      'Y'           ERMSG
233300200529     C                   MOVE      '1'           *IN32                          Reverse image
233400200529     C                   MOVEL     'CO00300'     ZAMSID                         Message id.
233500200529     C                   EXSR      ZASNMS                                       Send message
233600200529     C                   ENDIF                                                  E*5
233700200529     C/COPY WNCPYSRC,SEH00002
233800200529     C                   ENDIF                                                  E*4
233900200529     C                   ENDIF                                                  E*3
234000200529     C                   ENDIF                                                  E*2
234100200529      *
234200200529      **   IF 'AMEND MODE' OR 'ENQUIRY' MODE
234300200529      *
234400200529     C     *IN43         IFEQ      '1'                                          B*2
234500200529     C     *IN61         OREQ      '1'
234600200529      *
234700200529      **   IF ACTION INDICATOR IS CHANGED
234800200529      *
234900200529     C     #1SEL         IFNE      *BLANKS                                      B*3
235000200529     C                   EXSR      P008A
235100200529     C                   ENDIF                                                  E*3
235200200529      *
235300200529      **   PROCESS ACTION (ONLY ENQUIRY MODE)
235400200529      *
235500200529     C     ERMSG         IFEQ      'N'                                          B*3
235600200529     C     *IN61         ANDEQ     '1'
235700200529     C                   EXSR      P009
235800200529     C                   MOVE      '0'           *IN84
235900200529     C                   ENDIF                                                  E*3
236000200529     C                   ENDIF                                                  E*2
236100200529      *
236200200529      **   IF AN ERROR MESSAGE IS SENT
236300200529      **   OR IF 'ADD MODE'
236400200529      *
236500200529     C     ERMSG         IFEQ      'Y'                                          B*2
236600200529     C     *IN43         OREQ      '0'
236700200529      *
236800200529      **   IF 'CORPORATE ACTION STATUS' IS 'I' OR 'L' AND FINAL INDICATOR 'N'
236900200529      **     NON-PROTECT 'EX-DATE' SUBFILE FIELD (AMEND MODE)
237000200529      *
237100200529     C     *IN43         IFEQ      '1'                                          B*3
237200200529      *
237300200529     C     #1STAT        IFEQ      'I'                                          B*4
237400200529     C     #1STAT        OREQ      'L'
237500200529     C     #1FINA        ANDEQ     'N'
237600200529     C                   MOVE      '0'           *IN59
237700200529     C                   ELSE                                                   X*4
237800200529     C                   MOVE      '1'           *IN59
237900200529     C                   ENDIF                                                  E*4
238000200529      *
238100200529      **   IF 'CORPORATE ACTION STATUS' IS EQUAL TO S/X/C/R, PROTECT ALLOCATION
238200200529      *
238300200529     C     #1STAT        IFEQ      'S'                                          B*3
238400200529     C     #1STAT        OREQ      'X'
238500200529     C     #1STAT        OREQ      'C'
238600200529     C     #1STAT        OREQ      'R'
238700200529     C                   MOVE      '0'           *IN48
238800200529     C                   ELSE                                                   X*3
238900200529     C                   MOVE      '1'           *IN48
239000200529     C                   ENDIF                                                  E*3
239100200529     C/COPY WNCPYSRC,SEH00003
239200200529      *
239300200529      **   IF 'CORPORATE ACTION STATUS' IS 'C' OR 'R', PROTECT DATE OF ANNOUNCEM
239400200529      *
239500200529     C     #1STAT        IFEQ      'C'                                          B*3
239600200529     C     #1STAT        OREQ      'R'
239700200529     C                   MOVE      '1'           *IN75
239800200529     C                   ELSE                                                   X*3
239900200529     C                   MOVE      '0'           *IN75
240000200529     C                   ENDIF                                                  E*3
240100200529      *
240200200529      **   IF 'LOCKED BY USER IDENTIFIER' IS NOT BLANK
240300200529      **     PROTECT ALL SUBFILE RECORD FIELDS
240400200529      *
240500200529     C***********#1REFN    CHAINSECORFL1             89                   136421
240600200529     C     #1REFN        CHAIN     SECORFL9                           89                       13642
240700200529      *
240800200529     C     MAUSER        IFNE      *BLANKS                                      B*4
240900200529     C                   MOVE      '1'           *IN63
241000200529     C                   ELSE                                                   X*4
241100200529     C                   MOVE      '0'           *IN63
241200200529     C                   ENDIF                                                  E*4
241300200529      *
241400200529     C                   ENDIF                                                  E*3
241500200529      *
241600200529      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
241700200529      *
241800200529     C/COPY WNCPYSRC,SE7502C015
241900200529     C                   UPDATE    SE7502S0
242000200529     C/COPY WNCPYSRC,SE7502C016
242100200529      *
242200200529      **   GOTO NEXT READ OF THE SUBFILE CHANGING
242300200529      *
242400200529     C                   GOTO      TAG4
242500200529     C                   ENDIF                                                  E*2
242600200529      *
242700200529      **   IF 'AMEND MODE'
242800200529      *
242900200529     C     *IN43         IFEQ      '1'                                          B*2
243000200529      *
243100200529      **   IF DATE OF ANNOUNCEMENT, EX-DATE, FINAL INDICATOR, STATUS OR ALLOCATI
243200200529      **   EFFECTIVE DATE IS/ARE CHANGED
243300200529      *
243400200529     C     #1COAN        IFNE      #2COAN                                       B*3
243500200529     C     #1EXDT        ORNE      #2EXDT
243600200529     C     #1ALEF        ORNE      #2ALEF
243700200529      *
243800200529      **   ACCESS CORPORATE ACTION REFERENCE FILE WITH CURRENT REFERENCE
243900200529      *
244000200529     C     #1REFN        CHAIN     SECORFL0                           89
244100200529      *
244200200529      **   IF RECORD IS DIFFERENT THAN READ AT CHARGING OF SUBFILE
244300200529      *
244400200529     C     FIELD         IFNE      #FIELD                                       B*4
244500200529     C                   MOVE      'Y'           ERMSG
244600200529     C                   MOVE      '1'           *IN28                          Reverse image
244700200529     C                   MOVE      '1'           *IN29                          Reverse image
244800200529     C                   MOVE      '1'           *IN32                          Reverse image
244900200529     C                   MOVE      '1'           *IN33                          Reverse image
245000200529     C                   MOVE      '1'           *IN34                          Reverse image
245100200529     C                   MOVE      '1'           *IN37                          Reverse image
245200200529     C                   MOVE      '1'           *IN38                          Reverse image
245300200529     C                   MOVE      '1'           *IN39                          Reverse image
245400200529     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
245500200529     C                   EXSR      ZASNMS                                       Send message
245600200529      *
245700200529      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
245800200529      *
245900200529     C/COPY WNCPYSRC,SE7502C017
246000200529     C                   UPDATE    SE7502S0
246100200529     C/COPY WNCPYSRC,SE7502C018
246200200529      *
246300200529      **   RELEASE THE RECORD
246400200529      *
246500200529     C     #1REFN        SETLL     SECORFL0
246600200529      *
246700200529      **   GOTO NEXT READ OF THE SUBFILE CHANGING
246800200529      *
246900200529     C                   GOTO      TAG4
247000200529     C                   ELSE                                                   X*4
247100200529      *
247200200529     C                   MOVE      'D'           MARECI
247300200529     C                   Z-ADD     BJRDNB        MALCD
247400200529     C                   MOVE      'A'           MACHTP
247500200529     C                   MOVE      ##USR         MALUID
247600200529      *
247700200529      **   IF DATE OF ANNOUNCEMENT CHANGED
247800200529      *
247900200529     C     #1COAN        IFNE      #2COAN                                       B*5
248000200529      *
248100200529     C                   MOVE      #1COAN        ZDATE
248200200529     C                   EXSR      ZDATE1
248300200529     C                   Z-ADD     ZDAYNO        MACOAN
248400200529     C                   MOVE      #1COAN        #2COAN
248500200529      *
248600200529     C                   ENDIF                                                  E*5
248700200529      *
248800200529      **   IF EX-DATE CHANGED
248900200529      *
249000200529     C     #1EXDT        IFNE      #2EXDT                                       B*5
249100200529     C                   MOVE      #1EXDT        ZDATE
249200200529     C                   EXSR      ZDATE1
249300200529     C                   Z-ADD     ZDAYNO        MACOEX
249400200529      *
249500200529     C                   MOVE      #1EXDT        #2EXDT
249600200529      *
249700200529     C                   ENDIF                                                  E*5
249800200529      *
249900200529      **   IF ALLOCATION EFFECTIVE DATE CHANGED
250000200529      *
250100200529     C     #1ALEF        IFNE      #2ALEF                                       B*5
250200200529     C/COPY WNCPYSRC,SEH00004
250300200529     C                   MOVE      #1ALEF        ZDATE
250400200529     C                   EXSR      ZDATE1
250500200529     C                   Z-ADD     ZDAYNO        MAALEF
250600200529     C                   MOVE      #1ALEF        #2ALEF
251000200529     C                   ENDIF                                                  E*5
251100200529      *
251200200529     C                   UPDATE    SECORFD0
251300200529     C                   MOVE      MAJOBN        WAJOBN           10
251400200529     C                   MOVE      MAUSER        WAUSER           10
251500200529     C                   Z-ADD     MAJNBR        WAJNBR            6 0
251600200529     C                   MOVE      *BLANKS       MAJOBN
251700200529     C                   MOVE      *BLANKS       MAUSER
251800200529     C                   Z-ADD     *ZEROS        MAJNBR
251900200529     C                   MOVE      FIELD         #FIELD
252000200529     C                   MOVE      WAJOBN        MAJOBN
252100200529     C                   MOVE      WAUSER        MAUSER
252200200529     C                   Z-ADD     WAJNBR        MAJNBR
252300200529     C                   ENDIF                                                  E*4
252400200529     C                   ENDIF                                                  E*3
252500200529      *
252600200529      **   EXECUTE COMMITMENT CONTROL
252700200529      *
252800200529     C                   COMMIT
252900200529      *
253000200529      **   IF ACTION IS CHANGED
253100200529      *
253200200529     C     #1SEL         IFNE      #2SEL                                        B*3
253300200529      *
253400200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
253500200529      *
253600200529     C     #1REFN        CHAIN     SECORFL0                           89
253700200529      *
253800200529      **   IF RECORD IS DIFFERENT THAN READ AT CHARGING OF SUBFILE
253900200529      *
254000200529     C     FIELD         IFNE      #FIELD                                       B*4
254100200529     C                   MOVE      'Y'           ERMSG
254200200529     C                   MOVE      '1'           *IN28                          Reverse image
254300200529     C                   MOVE      '1'           *IN29                          Reverse image
254400200529     C                   MOVE      '1'           *IN32                          Reverse image
254500200529     C                   MOVE      '1'           *IN33                          Reverse image
254600200529     C                   MOVE      '1'           *IN34                          Reverse image
254700200529     C                   MOVE      '1'           *IN37                          Reverse image
254800200529     C                   MOVE      '1'           *IN38                          Reverse image
254900200529     C                   MOVE      '1'           *IN39                          Reverse image
255000200529     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
255100200529     C                   EXSR      ZASNMS                                       Send message
255200200529      *
255300200529      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
255400200529      *
255500200529     C/COPY WNCPYSRC,SE7502C019
255600200529     C                   UPDATE    SE7502S0
255700200529      *
255800200529     C/COPY WNCPYSRC,SE7502C020
255900200529      **   RELEASE THE RECORD
256000200529      *
256100200529     C     #1REFN        SETLL     SECORFL0
256200200529      *
256300200529      **   GOTO NEXT READ OF THE SUBFILE CHANGING
256400200529      *
256500200529     C                   GOTO      TAG4
256600200529     C                   ELSE                                                   X*4
256700200529      *
256800200529     C                   MOVE      ##JOB         MAJOBN
256900200529     C                   MOVE      ##USR         MAUSER
257000200529     C                   Z-ADD     ##JNO         MAJNBR
257100200529      *
257200200529      **   UPDATE THE RECORD IN CORPORATE ACTION REFERENCE FILE
257300200529      *
257400200529     C                   UPDATE    SECORFD0
257500200529     C                   MOVE      MAJOBN        WAJOBN           10
257600200529     C                   MOVE      MAUSER        WAUSER           10
257700200529     C                   Z-ADD     MAJNBR        WAJNBR            6 0
257800200529     C                   MOVE      *BLANKS       MAJOBN
257900200529     C                   MOVE      *BLANKS       MAUSER
258000200529     C                   Z-ADD     *ZEROS        MAJNBR
258100200529     C                   MOVE      FIELD         #FIELD
258200200529     C                   MOVE      WAJOBN        MAJOBN
258300200529     C                   MOVE      WAUSER        MAUSER
258400200529     C                   Z-ADD     WAJNBR        MAJNBR
258500200529      *
258600200529      **   EXECUTE THE COMMITMENT INSTRUCTION
258700200529      *
258800200529     C                   COMMIT
258900200529      *
259000200529      **   PROCESS ACTION
259100200529      *
259200200529     C                   EXSR      P009
259300200529     C                   ENDIF                                                  E*4
259400200529     C                   ENDIF                                                  E*3
259500200529      *
259600200529      **   IF 'CORPORATE ACTION STATUS' IS 'I' OR 'L' AND FINAL INDICATOR 'N'
259700200529      **     NON-PROTECT 'EX-DATE' SUBFILE FIELD (AMEND MODE)
259800200529      *
259900200529     C     #1STAT        IFEQ      'I'                                          B*4
260000200529     C     #1STAT        OREQ      'L'
260100200529     C     #1FINA        ANDEQ     'N'
260200200529     C                   MOVE      '0'           *IN59
260300200529     C                   ELSE                                                   X*4
260400200529     C                   MOVE      '1'           *IN59
260500200529     C                   ENDIF                                                  E*4
260600200529      *
260700200529      **   IF 'CORPORATE ACTION STATUS' IS EQUAL TO S/X/C/R, PROTECT ALLOCATION
260800200529      *
260900200529     C     #1STAT        IFEQ      'S'                                          B*3
261000200529     C     #1STAT        OREQ      'X'
261100200529     C     #1STAT        OREQ      'C'
261200200529     C     #1STAT        OREQ      'R'
261300200529     C                   MOVE      '0'           *IN48
261400200529     C                   ELSE                                                   X*3
261500200529     C                   MOVE      '1'           *IN48
261600200529     C                   ENDIF                                                  E*3
261700200529     C/COPY WNCPYSRC,SEH00005
261800200529      *
261900200529      **   IF 'CORPORATE ACTION STATUS' IS 'C' OR 'R', PROTECT DATE OF ANNOUNCEM
262000200529      *
262100200529     C     #1STAT        IFEQ      'C'                                          B*3
262200200529     C     #1STAT        OREQ      'R'
262300200529     C                   MOVE      '1'           *IN75
262400200529     C                   ELSE                                                   X*3
262500200529     C                   MOVE      '0'           *IN75
262600200529     C                   ENDIF                                                  E*3
262700200529      *
262800200529      **   IF 'LOCKED BY USER IDENTIFIER' IS NOT BLANK
262900200529      **     PROTECT ALL SUBFILE RECORD FIELDS
263000200529      *
263100200529     C     MAUSER        IFNE      *BLANKS                                      B*4
263200200529     C                   MOVE      '1'           *IN63
263300200529     C                   ELSE                                                   X*4
263400200529     C                   MOVE      '0'           *IN63
263500200529     C                   ENDIF                                                  E*4
263600200529      *
263700200529      **   IF NO ERROR MESSAGE SENT
263800200529      *
263900200529     C     ERMSG         IFEQ      'N'                                          B*3
264000200529     C                   MOVE      '0'           *IN84
264100200529     C/COPY WNCPYSRC,SE7502C021
264200200529     C                   UPDATE    SE7502S0
264300200529     C/COPY WNCPYSRC,SE7502C022
264400200529     C                   ELSE                                                   X*3
264500200529     C                   MOVE      '1'           *IN84
264600200529     C/COPY WNCPYSRC,SE7502C023
264700200529     C                   UPDATE    SE7502S0
264800200529     C/COPY WNCPYSRC,SE7502C024
264900200529     C                   ENDIF                                                  E*3
265000200529     C                   ENDIF                                                  E*2
265100200529      *
265200200529     C     TAG4          TAG
265300200529      *
265400200529     C/COPY WNCPYSRC,SE7502C025
265500200529     C                   WRITE     #MSGCTL
265600200529      *
265700200529      **   READ CHANGED SUBFILE RECORD
265800200529      *
265900200529     C                   READC     SE7502S0                               87
266000200529     C/COPY WNCPYSRC,SE7502C026
266100200529     C                   ENDDO                                                  E*1
266200200529      *
266300200529      **   IF 'ADD MODE'
266400200529      **   AND IF NO ERROR MESSAGE IS SENT
266500200529      *
266600200529     C     *IN43         IFEQ      '0'                                          B*1
266700200529     C     *IN61         ANDEQ     '0'
266800200529     C     ERMSG         ANDEQ     'N'
266900200529     C     WREDSP        ANDNE     'Y'                                                        215168
267000200529      *
267100200529     C                   Z-ADD     1             #1RRN
267200200529     C                   MOVE      'Y'           FINSR             1
267300200529      *
267400200529      **   READ FIRST RECORD OF SUBFILE
267500200529      *
267600200529     C/COPY WNCPYSRC,SE7502C027
267700200529     C                   READC     SE7502S0                               87
267800200529     C/COPY WNCPYSRC,SE7502C028
267900200529      *
268000200529      **   DO WHILE END OF SUBFILE IS NOT REACHED
268100200529      *
268200200529     C     *IN87         DOWEQ     '0'                                          B*2
268300200529      *
268400200529      **   RETRIEVE NEXT AVAILABLE REFERENCE NUMBER
268500200529      *
268600200529     C                   EXSR      P021
268700200529      *
268800200529      **   IF SECURITY SHORTNAME IS LEFT BLANK (IT MEANS THAT RECORD IS BLANK)
268900200529      *
269000200529     C     #1SECN        IFNE      *BLANKS                                      B*3
269100200529      *
269200200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
269300200529      *
269400200529     C***********#1REFN    CHAINSECORFL1             88                   136421
269500200529     C     #1REFN        CHAIN     SECORFL9                           88                       13642
269600200529      *
269700200529      **   IF A RECORD IS FOUND
269800200529      *
269900200529     C     *IN88         IFEQ      '0'                                          B*4
270000200529     C                   MOVE      '1'           *IN28                          Reverse image
270100200529     C                   MOVE      '1'           *IN29                          Reverse image
270200200529     C                   MOVE      '1'           *IN32                          Reverse image
270300200529     C                   MOVE      '1'           *IN33                          Reverse image
270400200529     C                   MOVE      '1'           *IN34                          Reverse image
270500200529     C                   MOVE      '1'           *IN37                          Reverse image
270600200529     C                   MOVE      '1'           *IN38                          Reverse image
270700200529     C                   MOVE      '1'           *IN39                          Reverse image
270800200529     C                   MOVEL     'CO00002'     ZAMSID                         Message id.
270900200529     C                   EXSR      ZASNMS                                       Send message
271000200529      *
271100200529      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
271200200529      *
271300200529     C/COPY WNCPYSRC,SE7502C029
271400200529     C                   UPDATE    SE7502S0
271500200529     C/COPY WNCPYSRC,SE7502C030
271600200529      *
271700200529      **   ROLLBACK INSTRUCTION TO REVERSE ALL INSERTS
271800200529      *
271900200529     C                   ROLBK
272000200529      *
272100200529      **   TERMINATE CURRENT PROCESSING
272200200529      *
272300200529     C                   GOTO      TAG5
272400200529     C                   ELSE                                                   X*4
272500200529      *
272600200529      **   WRITE A RECORD IN CORPORATE ACTION REFERENCE FILE
272700200529      *
272800200529     C                   MOVE      'D'           MARECI
272900200529     C                   Z-ADD     BJRDNB        MALCD
273000200529     C                   MOVE      'I'           MACHTP
273100200529     C                   MOVE      ##USR         MALUID
273200200529     C                   MOVE      #1REFN        MACORF
273300200529     C*****                MOVE *BLANKS   MAJOBN                          137879
273400200529     C*****                MOVE *BLANKS   MAUSER                          137879
273500200529     C*****                Z-ADD*ZEROS    MAJNBR                          137879
273600200529     C                   MOVE      ##JOB         MAJOBN                                        13787
273700200529     C                   MOVE      ##USR         MAUSER                                        13787
273800200529     C                   Z-ADD     ##JNO         MAJNBR                                        13787
273900200529     C                   MOVE      #1SECN        MASESN
274000200529     C                   MOVE      #1COAT        MACOAT
274100200529      *
274200200529     C     #1COAT        CHAIN     SECOATL0                           89
274300200529     C                   MOVE      MMPTYP        MAPTYP
274400200529      *
274500200529     C     #1COAN        IFNE      *BLANKS                                      B*5
274600200529     C                   MOVE      #1COAN        ZDATE
274700200529     C                   EXSR      ZDATE1
274800200529     C                   Z-ADD     ZDAYNO        MACOAN
274900200529     C                   ELSE                                                   X*5
275000200529     C                   Z-ADD     *ZEROS        MACOAN
275100200529     C                   ENDIF                                                  E*5
275200200529      *
275300200529     C     #1EXDT        IFNE      *BLANKS                                      B*5
275400200529     C                   MOVE      #1EXDT        ZDATE
275500200529     C                   EXSR      ZDATE1
275600200529     C                   Z-ADD     ZDAYNO        MACOEX
275700200529     C                   ELSE                                                   X*5
275800200529     C                   Z-ADD     *ZEROS        MACOEX
275900200529     C                   ENDIF                                                  E*5
276000200529      *
276100200529     C     #1ALEF        IFNE      *BLANKS                                      B*5
276200200529     C                   MOVE      #1ALEF        ZDATE
276300200529     C                   EXSR      ZDATE1
276400200529     C                   Z-ADD     ZDAYNO        MAALEF
276500200529     C                   ELSE                                                   X*5
276600200529     C                   Z-ADD     *ZEROS        MAALEF
276700200529     C                   ENDIF                                                  E*5
276800200529      *
276900200529     C                   MOVE      #1NBOP        MANBOP
277000200529     C                   MOVE      'T'           MATDVD
277100200529     C                   Z-ADD     MAALEF        MACOPD
277200200529     C                   Z-ADD     MAALEF        MATDDT
277300200529     C                   Z-ADD     MACOEX        MAEVDT
277400200529     C                   Z-ADD     *ZEROS        MACPNB
277500200529     C                   Z-ADD     *ZEROS        MASHMD
277600200529     C                   MOVE      'N'           MALTBS
277700200529     C                   Z-ADD     *ZEROS        MAOCPV
277800200529     C                   Z-ADD     *ZEROS        MANCPV
277900200529     C                   Z-ADD     *ZEROS        MAONML
278000200529     C                   Z-ADD     *ZEROS        MANNML
278100200529      *
278200200529     C                   MOVE      MASESN        KSECN
278300200529     C                   Z-ADD     MACOEX        KEXDT
278400200529      *                                                                   155622
278500200529     C     KEY7          SETLL     PRICM                                                       15562
278600200529     C                   READ      PRICM                                  89                   15562
278700200529      *                                                                   155622
278800200529     C     *IN89         IFEQ      '0'                                                         15562
278900200529     C     PSSN          ANDEQ     KSECN                                                       15562
279000200529     C     PVDT          ANDGE     KEXDT                                                       15562
279100200529     C     KEXDT         ANDNE     *ZEROS                                                      15562
279200200529     C                   Z-ADD     PPRC          MACUPC                                        15562
279300200529     C                   Z-ADD     PPRC          MAEXPC                                        15562
279400200529     C                   ELSE                                                                  15562
279500200529S3    *                                                                   155622
279600200529     C                   MOVE      'PR'          KTYPE
279700200529      *
279800200529     C     KEY5          SETLL     SECED
279900200529     C                   READ      SECED                                  89
280000200529      *
280100200529     C     *IN89         IFEQ      '0'
280200200529     C     SNSN          ANDEQ     KSECN
280300200529     C     SNDT          ANDGE     KEXDT
280400200529     C     SNET          ANDEQ     'PR'
280500200529     C     KEXDT         ANDNE     *ZEROS                                                      15562
280600200529     C                   Z-ADD     SNPR          MACUPC
280700200529     C                   Z-ADD     SNPR          MAEXPC
280800200529     C                   ELSE
280900200529     C     KSECN         CHAIN     SECTYZ1                            89                       15562
281000200529     C     *IN89         IFEQ      '0'                                                         15562
281100200529     C                   Z-ADD     MKPR          MACUPC                                        15562
281200200529     C                   Z-ADD     MKPR          MAEXPC                                        15562
281300200529     C                   ELSE                                                                  15562
281400200529     C                   Z-ADD     *ZEROS        MACUPC
281500200529     C                   Z-ADD     *ZEROS        MAEXPC
281600200529     C                   ENDIF                                                                 15562
281700200529     C                   ENDIF
281800200529     C                   ENDIF                                                                 15562
281900200529      *
282000200529     C                   Z-ADD     *ZEROS        MACLRD
282100200529     C                   Z-ADD     *ZEROS        MACLRT
282200200529     C                   Z-ADD     *ZEROS        MADLRD
282300200529     C                   Z-ADD     *ZEROS        MADLRT
282400200529     C                   MOVE      'N'           MABLOS
282500200529     C                   MOVE      'N'           MABLOP
282600200529     C                   Z-ADD     *ZEROS        MABFRD
282700200529     C                   Z-ADD     *ZEROS        MABEND
282800200529      *                                                                                       CGL031
282900200529     C                   EVAL      MASETX = *BLANK                                            CGL031
283000200529      *                                                                                       CGL031
283100200529     C                   IF        CGL031 = 'Y' AND                                           CGL031
283200200529     C                             #1COAT = 'DI'                                              CGL031
283300200529     C                   EVAL      KSECN = #1SECN                                             CGL031
283400200529     C     KSECN         CHAIN     SECTYZ1                                                    CGL031
283500200529     C                   IF        %FOUND                                                     CGL031
283600200529     C                   EVAL      MASETX = SETX                                              CGL031
283700200529     C                   ENDIF                                                                CGL031
283800200529     C                   ENDIF                                                                CGL031
283900200529      *                                                                                       CGL031
284000200529     C                   MOVE      'N'           MAREFO
284100200529     C                   MOVE      *BLANKS       MACONR
284200200529     C                   MOVE      *BLANKS       MADFNR
284300200529     C                   MOVE      *BLANKS       MADFCP
284400200529     C                   MOVE      *BLANKS       MADFSP
284500200529     C                   MOVE      'N'           MALREQ
284600200529     C                   Z-ADD     *ZEROS        MALPRO
284700200529     C                   MOVE      'N'           MALTSI
284800200529     C                   MOVE      'I'           MASTAT
284900200529     C                   MOVE      *BLANKS       MAPREF                                       CSE020
285000200529      *
285100200529     C                   WRITE     SECORFD0
285200200529      *
285300200529     C                   Z-ADD     1             WWOPNB            2 0
285400200529     C                   MOVE      #1NBOP        W1NBOP            2 0
285500200529      *
285600200529      **   WRITE THE RECORD(S) ON THE CORPORATE ACTION OPTION FILE
285700200529      **   DEPENDING OF THE PROCESSING TYPE
285800200529      *
285900200529     C     WWOPNB        DOWLE     W1NBOP                                       B*5
286000200529     C                   EXSR      P011
286100200529     C                   ADD       1             WWOPNB
286200200529     C                   ENDDO                                                  E*5
286300200529      *
286400200529      **   SAVE THE FIRST INSERTED RECORD FIELDS
286500200529      *
286600200529     C     FINSR         IFEQ      'Y'                                          B*5
286700200529     C                   MOVE      MACORF        KREFN
286800200529     C                   MOVE      '1'           *IN55
286900200529     C                   MOVE      'N'           FINSR
287000200529     C                   ENDIF                                                  E*5
287100200529      *
287200200529      **   UPDATE SUBFILE RECORD (FOR REVERSED ERROR FIELDS)
287300200529      *
287400200529     C/COPY WNCPYSRC,SE7502C031
287500200529     C                   UPDATE    SE7502S0
287600200529     C/COPY WNCPYSRC,SE7502C032
287700200529      *                                                                   137879
287800200529      **   INITIALISE ERROR INDICATORS                                    137879
287900200529      *                                                                   137879
288000200529     C                   EVAL      *IN07 = *OFF                                               CGL031
288100200529     C                   MOVE      '0'           *IN13                                         13787
288200200529     C                   MOVE      '0'           *IN14                                         13787
288300200529     C                   MOVE      '0'           *IN20                                         13787
288400200529     C                   MOVE      '0'           *IN21                                         13787
288500200529     C                   MOVE      '0'           *IN22                                         13787
288600200529     C                   MOVE      '0'           *IN23                                         13787
288700200529     C                   MOVE      '0'           *IN24                                         13787
288800200529     C                   MOVE      '0'           *IN31                                         13787
288900200529     C                   MOVE      '0'           *IN35                                         13787
289000200529     C                   MOVE      '1'           *IN36                                         13787
289100200529     C                   MOVE      '0'           *IN42                                         13787
289200200529     C                   MOVE      '1'           *IN43                                         13787
289300200529     C                   MOVE      '0'           *IN49                                         13787
289400200529     C                   MOVE      '0'           *IN60                                         13787
289500200529     C                   MOVE      '0'           *IN65                                         13787
289600200529     C                   MOVE      '0'           *IN66                                         13787
289700200529     C                   MOVE      '0'           *IN67                                         13787
289800200529     C                   MOVE      '0'           *IN70                                         13787
289900200529     C                   MOVE      '0'           *IN71                                         13787
290000200529     C                   MOVE      '0'           *IN72                                         13787
290100200529     C                   MOVE      '0'           *IN73                                         13787
290200200529     C                   MOVE      '0'           *IN74                                         13787
290300200529     C                   MOVE      '0'           *IN76                                         13787
290400200529     C                   MOVE      '0'           *IN77                                         13787
290500200529     C                   MOVE      '0'           *IN78                                         13787
290600200529     C                   MOVE      '0'           *IN79                                         13787
290700200529     C                   MOVE      '0'           *IN82                                         13787
290800200529     C                   MOVE      '0'           *IN83                                         13787
290900200529     C                   MOVE      '0'           *IN85                                         13787
291000200529      *                                                                   137879
291100200529     C                   MOVE      'N'           #1FINA                                        13787
291200200529     C                   MOVE      'I'           #1STAT                                        13787
291300200529     C                   MOVE      'G'           #1SEL                                         13787
291400200529     C                   MOVE      'Y'           WWINPT            1                           13787
291500200529     C                   EXSR      P018                                                        13787
291600200529     C                   MOVE      '0'           *IN36                                         13787
291700200529     C                   MOVE      '0'           *IN43                                         13787
291800200529     C                   MOVE      ' '           #1SEL                                         13787
291900200529     C                   MOVE      'N'           WWINPT                                        13787
292000200529      *                                                                   137879
292100200529     C     #1REFN        CHAIN     SECORFL0                           89                       13787
292200200529      *                                                                   137879
292300200529     C                   MOVE      *BLANKS       MAJOBN                                        13787
292400200529     C                   MOVE      *BLANKS       MAUSER                                        13787
292500200529     C                   Z-ADD     *ZEROS        MAJNBR                                        13787
292600200529      *                                                                   137879
292700200529     C     *IN89         IFEQ      '0'                                          B*5            13787
292800200529     C                   UPDATE    SECORFD0                                                    13787
292900200529     C                   ENDIF                                                  E*5            13787
293000200529     C/COPY WNCPYSRC,SE7502C003
293100200529     C                   ENDIF                                                  E*4
293200200529     C                   ENDIF                                                  E*3
293300200529      *
293400200529      **   READ FIRST RECORD OF SUBFILE
293500200529      *
293600200529     C/COPY WNCPYSRC,SE7502C033
293700200529     C                   READC     SE7502S0                               87
293800200529     C/COPY WNCPYSRC,SE7502C034
293900200529     C                   ENDDO                                                  E*2
294000200529      *
294100200529      **   IF AT LEAST ONE RECORD CREATED
294200200529      *
294300200529     C     W1CORF        IFNE      WWCORF                                       B*2
294400200529     C     *LOVAL        SETLL     SECORFPA
294500200529     C                   READ      SECORFPA                               89
294600200529      *
294700200529     C     *IN89         IFEQ      '0'                                          B*3
294800200529     C                   MOVE      WWCORF        MXCORF
294900200529     C                   UPDATE    SECORFP0
295000200529     C                   ENDIF                                                  E*3
295100200529      *
295200200529     C                   ENDIF                                                  E*2
295300200529      *
295400200529      **   EXECUTE COMMITMENT CONTROL TO FIX ALL INSERTED RECORDS
295500200529      *
295600200529     C                   COMMIT
295700200529      *
295800200529      **   SET KEY FIELDS FROM KLIST TO FIRST INSERTED RECORD
295900200529      *
296000200529      **   CLEAR SUBFILE
296100200529      *
296200200529     C                   Z-ADD     0             WWRRN             4 0          SAVE RCD.NBR.
296300200529      *
296400200529      **   CLEAR SUBFILE
296500200529      *
296600200529     C                   EXSR      P004
296700200529      *
296800200529      **   SET INDICATOR TO RETURN TO 'AMEND MODE'
296900200529      *
297000200529     C                   MOVE      '1'           *IN43
297100200529     C                   MOVEA     TXT(3)        ##CTX1
297200200529      *
297300200529      **   PROTECT ON 'POSITION/SELECTION' FIELDS *OFF
297400200529      **   PROTECT/NON-DISPLAY 'ACTION', 'LAST/FINAL ALLOCATION', 'STATUS' *OFF
297500200529      **   PROTECT ON 'SECURITY SHORT.', 'ACTION TYPE', 'NUMBER OF OPTIONS' *ON
297600200529      *
297700200529     C                   MOVE      '0'           *IN56
297800200529     C                   MOVE      '0'           *IN57
297900200529     C                   MOVE      '1'           *IN58
298000200529      *
298100200529     C***********        MOVE      '0'           *IN45                                        CSE020
298200200529     C                   MOVE      '0'           WIN45                                        CSE020
298300200529     C                   MOVE      '0'           *IN30
298400200529      *
298500200529     C/COPY WNCPYSRC,SE7502C035
298600200529     C                   EXSR      P006
298700200529     C/COPY WNCPYSRC,SE7502C036
298800200529      *
298900200529     C***********        MOVE      '1'           *IN45                                        CSE020
299000200529     C                   MOVE      '1'           WIN45                                        CSE020
299100200529      *
299200200529     C                   ENDIF                                                  E*1
299300200529      *
299400200529     C     TAG5          ENDSR
299500200529      *****************************************************************
299600200529      /EJECT
299700200529      *****************************************************************
299800200529      * P008A  : VALIDATE 'ACTION' FIELD                              *
299900200529      *****************************************************************
300000200529      *
300100200529     C     P008A         BEGSR
300200200529      *
300300200529      **   IF IT'S NOT THE REPORT MODE
300400200529      *
300500200529     C     *IN64         IFEQ      '0'                                          B*1
300600200529      *
300700200529      **   IF IT'S THE ENQUIRY MODE, THE 'ACTION' MUST BE EQUAL TO 'E' OR 'F'
300800200529      *
300900200529     C     *IN61         IFEQ      '1'                                          B*2
301000200529      *
301100200529     C     #1SEL         IFNE      'E'                                          B*3
301200200529     C     #1SEL         ANDNE     'F'
301300200529     C     #1SEL         ANDNE     'V'
301400200529     C                   MOVE      'Y'           ERMSG
301500200529     C                   MOVE      '1'           *IN62                          Reverse image
301600200529     C                   MOVEL     'CO00017'     ZAMSID                         Message id.
301700200529     C                   EXSR      ZASNMS                                       Send message
301800200529     C                   GOTO      TAG2
301900200529     C                   ENDIF                                                  E*3
302000200529      *
302100200529     C                   ELSE                                                   X*2
302200200529      *
302300200529      **   'ACTION' CODE CAN BE 'G','F','A','E','R','Y','P','V','D','C','N'
302400200529      *
302500200529     C     #1SEL         IFNE      'G'                                          B*3
302600200529     C     #1SEL         ANDNE     'F'
302700200529     C     #1SEL         ANDNE     'A'
302800200529     C     #1SEL         ANDNE     'E'
302900200529     C     #1SEL         ANDNE     'R'
303000200529     C     #1SEL         ANDNE     'Y'
303100200529     C     #1SEL         ANDNE     'P'
303200200529     C     #1SEL         ANDNE     'V'
303300200529     C     #1SEL         ANDNE     'D'
303400200529     C     #1SEL         ANDNE     'C'
303500200529     C     #1SEL         ANDNE     'N'
303600200529     C                   MOVE      'Y'           ERMSG
303700200529     C                   MOVE      '1'           *IN62                          Reverse image
303800200529     C                   MOVEL     'CO00018'     ZAMSID                         Message id.
303900200529     C                   EXSR      ZASNMS                                       Send message
304000200529     C                   GOTO      TAG2
304100200529     C                   ENDIF                                                  E*3
304200200529     C                   ENDIF                                                  E*2
304300200529      *
304400200529      **   IF IT'S THE REPORT MODE, THE 'ACTION' MUST BE EQUAL TO 'P'
304500200529      *
304600200529     C                   ELSE                                                   X*1
304700200529      *
304800200529     C     #1SEL         IFNE      'P'                                          B*2
304900200529     C                   MOVE      'Y'           ERMSG
305000200529     C                   MOVE      '1'           *IN62                          Reverse image
305100200529     C                   MOVEL     'CO00019'     ZAMSID                         Message id.
305200200529     C                   EXSR      ZASNMS                                       Send message
305300200529     C                   GOTO      TAG2
305400200529     C                   ENDIF                                                  E*2
305500200529     C                   ENDIF                                                  E*1
305600200529      *
305700200529      **   IF 'EX-DATE' IS *GE THAN 'RUN DATE' AND ACTION IS NOT EQUAL TO 'F'
305800200529      *
305900200529     C                   MOVE      #1EXDT        ZDATE
306000200529     C                   EXSR      ZDATE1
306100200529     C                   Z-ADD     ZDAYNO        KEXDT
306200200529      *
306300200529     C     #1SEL         IFEQ      'A'                                          B*1
306400200529     C     #1SEL         OREQ      'E'
306500200529     C     #1SEL         OREQ      'Y'
306600200529     C     KEXDT         IFGE      BJRDNB                                       B*2
306700200529     C                   MOVE      'Y'           ERMSG
306800200529     C                   MOVE      '1'           *IN62                          Reverse image
306900200529     C                   MOVEL     'CO00020'     ZAMSID                         Message id.
307000200529     C                   EXSR      ZASNMS                                       Send message
307100200529     C                   GOTO      TAG2
307200200529     C                   ENDIF                                                  E*2
307300200529     C                   ENDIF                                                  E*1
307400200529      *
307500200529      **   ACCESS ER REFERENCE FILE
307600200529      *
307700200529     C***********#1REFN    CHAINSECORFL1             89                   136421
307800200529     C     #1REFN        CHAIN     SECORFL9                           89                       13642
307900200529      *
308000200529      **   IF LOCKED BY USER IDENTIFIER IS NOT BLANK
308100200529      *
308200200529     C     MAUSER        IFNE      *BLANKS                                      B*1
308300200529      *                                                                                      BUG2686
308400200529     C                   MOVEL     MAUSER        RTJOBW1          16                         BUG2686
308500200529     C                   MOVE      MAJNBR        RTJOBW1                                     BUG2686
308600200529     C                   MOVE      RTJOBW1       RTJOB                                       BUG2686
308700200529     C                   MOVEL     MAJOBN        RTJOB                                       BUG2686
308800200529      *                                                                                      BUG2686
308900200529     C                   CALL      'AOC8002'                                                 BUG2686
309000200529      *                                                                                      BUG2686
309100200529     C                   PARM                    RTJOB            26                         BUG2686
309200200529     C                   PARM                    RTNJOBW          10                         BUG2686
309300200529     C                   PARM                    RTNUSRW          10                         BUG2686
309400200529     C                   PARM                    RTNNUMW           6                         BUG2686
309500200529     C                   PARM                    RTNJIDW          16                         BUG2686
309600200529     C                   PARM                    RTNSTSW          10                         BUG2686
309700200529      *                                                                                      BUG2686
309800200529     C     RTNSTSW       IFEQ      '*ACTIVE'                                                 BUG2686
309900200529      *                                                                                      BUG2686
310000200529     C                   MOVE      MAUSER        WUSER
310100200529     C                   MOVE      MAJOBN        WJOBN
310200200529     C                   MOVE      'Y'           ERMSG
310300200529     C                   MOVE      '1'           *IN28                          Reverse image
310400200529     C                   MOVE      '1'           *IN29                          Reverse image
310500200529     C                   MOVE      '1'           *IN32                          Reverse image
310600200529     C                   MOVE      '1'           *IN33                          Reverse image
310700200529     C                   MOVE      '1'           *IN34                          Reverse image
310800200529     C                   MOVE      '1'           *IN37                          Reverse image
310900200529     C                   MOVE      '1'           *IN38                          Reverse image
311000200529     C                   MOVE      '1'           *IN39                          Reverse image
311100200529     C                   MOVEL     LOCKDS        ZAMSDA
311200200529     C                   MOVEL     'CO00021'     ZAMSID                         Message id.
311300200529     C                   EXSR      ZASNMS                                       Send message
311400200529     C                   GOTO      TAG2
311500200529      *                                                                                      BUG2686
311600200529     C                   ELSE                                                                BUG2686
311700200529      *                                                                                      BUG2686
311800200529     C     #1REFN        CHAIN     SECORFL0                           89                     BUG2686
311900200529     C                   MOVE      *BLANKS       MAUSER                                      BUG2686
312000200529     C                   MOVE      *BLANKS       MAJOBN                                      BUG2686
312100200529     C                   Z-ADD     *ZEROS        MAJNBR                                      BUG2686
312200200529      *                                                                                      BUG2686
312300200529     C                   UPDATE    SECORFD0                                                  BUG2686
312400200529     C                   MOVE      FIELD         #FIELD                                      BUG2686
312500200529      *                                                                                      BUG2686
312600200529     C                   COMMIT                                                              BUG2686
312700200529      *                                                                                      BUG2686
312800200529     C                   ENDIF                                                               BUG2686
312900200529      *                                                                                      BUG2686
313000200529     C                   ENDIF                                                  E*1
313100200529      *
313200200529      **   IF 'PROCESSING TYPE' IS NOT 'NC' AND 'ACTION' IS 'N'
313300200529      **     ERROR MESSAGE : ACTION 'N' NOT ALLOWED
313400200529      *
313500200529     C     #1PTYP        IFNE      'NC'                                         B*1
313600200529     C     #1SEL         ANDEQ     'N'
313700200529     C                   MOVE      'Y'           ERMSG
313800200529     C                   MOVE      '1'           *IN62                          Reverse image
313900200529     C                   MOVEL     'CO00254'     ZAMSID                         Message id.
314000200529     C                   EXSR      ZASNMS                                       Send message
314100200529     C                   GOTO      TAG2
314200200529     C                   ENDIF                                                  E*1
314300200529     C/COPY WNCPYSRC,SE7502C037
314400200529      *
314500200529      **   IF 'ACTION' IS 'N' AND STATUS DIFFERENT THAN 'I'
314600200529      **     ERROR MESSAGE : ACTION 'N' NOT ALLOWED
314700200529      *
314800200529     C     #1SEL         IFEQ      'N'                                          B*1
314900200529     C     #1GSTS        ANDNE     'I'
315000200529     C                   MOVE      'Y'           ERMSG
315100200529     C                   MOVE      '1'           *IN62                          Reverse image
315200200529     C                   MOVEL     'CO00257'     ZAMSID                         Message id.
315300200529     C                   EXSR      ZASNMS                                       Send message
315400200529     C                   GOTO      TAG2
315500200529     C                   ENDIF                                                  E*1
315600200529      *
315700200529      **   IF 'CO STATUS' IS 'AUTHORISED'
315800200529      **   AND ACTION IS 'G', 'D', 'Y' OR 'N'
315900200529      **    ERROR MESSAGE : ... NOT ALLOWED WITH STATUS 'X' (AUTHORISED)
316000200529      *
316100200529     C     #1GSTS        IFEQ      'X'                                          B*1
316200200529     C/COPY WNCPYSRC,SEH00022
316300200529     C     #1SEL         IFEQ      'G'                                          B*2
316400200529     C/COPY WNCPYSRC,SEH00006
316500200529     C     #1SEL         OREQ      'D'
316600200529     C     #1SEL         OREQ      'Y'
316700200529     C     #1SEL         OREQ      'N'
316800200529     C                   MOVE      'Y'           ERMSG
316900200529     C                   MOVE      '1'           *IN62                          Reverse image
317000200529     C                   MOVEL     'CO00023'     ZAMSID                         Message id.
317100200529     C                   EXSR      ZASNMS                                       Send message
317200200529     C                   GOTO      TAG2
317300200529     C                   ENDIF                                                  E*2
317400200529     C                   ENDIF                                                  E*1
317500200529      *
317600200529      **   IF 'CO STATUS' IS 'STOCK AUTHORISED'
317700200529      **   AND ACTION IS 'G', 'D', 'Y' OR 'N'
317800200529      **    ERROR MESSAGE : ... NOT ALLOWED WITH STATUS 'S' (STOCK AUTHORISED)
317900200529      *
318000200529     C     #1GSTS        IFEQ      'S'                                          B*1
318100200529     C*****      #1SEL     IFEQ 'G'                        B*2            137884
318200200529     C*****      #1SEL     OREQ 'D'                                       137884
318300200529     C     #1SEL         IFEQ      'D'                                                         13788
318400200529     C     #1SEL         OREQ      'Y'
318500200529     C     #1SEL         OREQ      'N'
318600200529     C                   MOVE      'Y'           ERMSG
318700200529     C                   MOVE      '1'           *IN62                          Reverse image
318800200529     C                   MOVEL     'CO00098'     ZAMSID                         Message id.
318900200529     C                   EXSR      ZASNMS                                       Send message
319000200529     C                   GOTO      TAG2
319100200529     C                   ENDIF                                                  E*2
319200200529     C                   ENDIF                                                  E*1
319300200529      *
319400200529      **   IF 'CO STATUS' IS 'COMPLETED'
319500200529      **   AND ACTION IS 'G','A','D','Y' OR 'N'
319600200529      **    ERROR MESSAGE : ... NOT ALLOWED WITH STATUS 'C' (COMPLETED)
319700200529      *
319800200529     C     #1GSTS        IFEQ      'C'                                          B*1
319900200529     C     #1SEL         IFEQ      'G'                                          B*2
320000200529     C     #1SEL         OREQ      'A'
320100200529     C     #1SEL         OREQ      'D'
320200200529     C     #1SEL         OREQ      'Y'
320300200529     C     #1SEL         OREQ      'N'
320400200529     C                   MOVE      'Y'           ERMSG
320500200529     C                   MOVE      '1'           *IN62                          Reverse image
320600200529     C                   MOVEL     'CO00024'     ZAMSID                         Message id.
320700200529     C                   EXSR      ZASNMS                                       Send message
320800200529     C                   GOTO      TAG2
320900200529     C                   ENDIF                                                  E*2
321000200529     C                   ENDIF                                                  E*1
321100200529      *
321200200529      **   IF 'CO STATUS' IS 'REVERSED' AND ACTION IS NOT 'E'
321300200529      **    ERROR MESSAGE : ONLY 'F' AND 'P'
321400200529      **                    ALLOWED WHEN STATUS 'R' (REVERSED)
321500200529      *
321600200529     C     #1GSTS        IFEQ      'R'                                          B*1
321700200529     C     #1SEL         ANDNE     'F'
321800200529     C     #1SEL         ANDNE     'P'
321900200529     C                   MOVE      'Y'           ERMSG
322000200529     C                   MOVE      '1'           *IN62                          Reverse image
322100200529     C                   MOVEL     'CO00025'     ZAMSID                         Message id.
322200200529     C                   EXSR      ZASNMS                                       Send message
322300200529     C                   GOTO      TAG2
322400200529     C                   ENDIF                                                  E*1
322500200529      *                                                                   138962
322600200529      ***  If 'Action' is 'Delete' ('D'), test if it's possible to        138962
322700200529      ***  Delete.                                                        138962
322800200529      *                                                                   138962
322900200529     C     #1SEL         IFEQ      'D'                                                         13896
323000200529      *                                                                   138962
323100200529      *****If*Processing*Type*=*Dividend*Events*or*Rights*Issues.* 138962 148743
323200200529      ***  If Processing Type = Dividend Events, Rights Issues or Offers. 148743
323300200529      *                                                                   138962
323400200529     C     #1PTYP        IFEQ      'DV'                                                        13896
323500200529     C     #1PTYP        OREQ      'RG'                                                        13896
323600200529     C     #1PTYP        OREQ      'FR'                                                        14874
323700200529      *                                                                   138962
323800200529      ***  If there is a linked Exercises and Conversions Corporate.      138962
323900200529      *                                                                   138962
324000200529     C     #1REFN        CHAIN     SECOEXL2                           89                       13896
324100200529     C     *IN89         IFEQ      '0'                                                         13896
324200200529     C     MJCORF        CHAIN     SECORFL9                           89                       13896
324300200529     C     *IN89         IFEQ      '0'                                                         13896
324400200529     C     MASTAT        IFEQ      'R'                                                         13896
324500200529      *                                                                   138962
324600200529      ***  If the linked 'EX' Corporate is Reversed, Delete not allowed,  138962
324700200529      ***  only Reverse allowed.                                          138962
324800200529      *                                                                   138962
324900200529     C                   MOVEL     'CO00599'     ZAMSID                         Message id.    13896
325000200529     C                   ELSE                                                                  13896
325100200529      *                                                                   138962
325200200529      ***  If the linked 'EX' Corporate is not Reversed, Delete not       138962
325300200529      ***  allowed.                                                       138962
325400200529      *                                                                   138962
325500200529     C                   MOVEL     'CO00597'     ZAMSID                         Message id.    13896
325600200529     C                   ENDIF                                                                 13896
325700200529     C                   MOVE      'Y'           ERMSG                                         13896
325800200529     C                   MOVE      '1'           *IN62                          Reverse image  13896
325900200529     C                   MOVEL(P)  MJCORF        ZAMSDA                                        13896
326000200529     C                   EXSR      ZASNMS                                       Send message   13896
326100200529     C                   GOTO      TAG2                                                        13896
326200200529     C                   ENDIF                                                                 13896
326300200529     C                   ENDIF                                                                 13896
326400200529     C                   ENDIF                                                                 13896
326500200529      *                                                                   138962
326600200529     C                   ENDIF                                                                 13896
326700200529      *
326800200529      **   IF 'ACTION' IS 'REVERSE' ('R'), TEST IF IT'S POSSIBLE TO REVERSE
326900200529      *
327000200529     C     #1SEL         IFEQ      'R'                                          B*1
327100200529      *
327200200529      **   ACCESS SECURITY DETAILS TO RETRIEVE SECURITY MATURITY DATE
327300200529      *
327400200529     C     #1SECN        CHAIN     SECTYZ1                            89
327500200529      *
327600200529      **   IF 'EX-DATE' IS NOT GREATER THAN CALCULATED 'BACK VALUE DATE'
327700200529      **   OR IF 'RUN DATE' IS NOT LOWER THAN SECURITY 'MATURITY DATE'
327800200529      *
327900200529     C     KEXDT         IFLE      WBACKD                                       B*2
328000200529     C     KEXDT         ANDNE     *ZEROS                                                      13787
328100200529     C     BJRDNB        ORGE      MATY
328200200529     C     MATY          ANDNE     *ZEROS
328300200529     C                   MOVE      'Y'           ERMSG
328400200529     C                   MOVE      '1'           *IN62                          Reverse image
328500200529     C                   MOVEL     'CO00028'     ZAMSID                         Message id.
328600200529     C                   EXSR      ZASNMS                                       Send message
328700200529     C                   GOTO      TAG2
328800200529     C                   ENDIF                                                  E*2
328900200529      *
329000200529     C     BJRDNB        SUB       MATDDT        RTNWRF            5 0
329100200529      *
329200200529     C     RTNWRF        IFGE      RTNPOS                                       B*2
329300200529     C     RTNWRF        ORGE      RTNTRD
329400200529     C     MASTAT        IFNE      'I'                                          B*3            13787
329500200529     C                   MOVE      'Y'           ERMSG
329600200529     C                   MOVE      '1'           *IN62                          Reverse image
329700200529     C                   MOVEL     'CO00556'     ZAMSID                         Message id.
329800200529     C                   EXSR      ZASNMS                                       Send message
329900200529     C                   GOTO      TAG2
330000200529     C                   ENDIF                                                  E*3            13787
330100200529     C                   ENDIF                                                  E*2
330200200529      *                                                                   138962
330300200529      *****If*Processing*Type*=*Dividend*Events*or*Rights*Issues.* 138962 148743
330400200529      ***  If Processing Type = Dividend Events, Rights Issues or Offers. 148743
330500200529      *                                                                   138962
330600200529     C     #1PTYP        IFEQ      'DV'                                                        13896
330700200529     C     #1PTYP        OREQ      'RG'                                                        13896
330800200529     C     #1PTYP        OREQ      'FR'                                                        14874
330900200529      *                                                                   138962
331000200529      ***  If there is a linked Exercises and Conversions Corporate and   138962
331100200529      ***  this linked Corporate not Reversed, Reverse not allowed.       138962
331200200529      *                                                                   138962
331300200529     C     #1REFN        CHAIN     SECOEXL2                           89                       13896
331400200529     C     *IN89         IFEQ      '0'                                                         13896
331500200529     C     MJCORF        CHAIN     SECORFL9                           89                       13896
331600200529     C     *IN89         IFEQ      '0'                                                         13896
331700200529     C     MASTAT        ANDNE     'R'                                                         13896
331800200529     C                   MOVE      'Y'           ERMSG                                         13896
331900200529     C                   MOVE      '1'           *IN62                          Reverse image  13896
332000200529     C                   MOVEL     'CO00598'     ZAMSID                         Message id.    13896
332100200529     C                   MOVEL(P)  MJCORF        ZAMSDA                                        13896
332200200529     C                   EXSR      ZASNMS                                       Send message   13896
332300200529     C                   GOTO      TAG2                                                        13896
332400200529     C                   ENDIF                                                                 13896
332500200529     C                   ENDIF                                                                 13896
332600200529     C                   ENDIF                                                                 13896
332700200529      *                                                                   138962
332800200529     C                   ENDIF                                                  E*1
332900200529      *                                                                                       CSE020
333000200529      ** Parent Reference can only be reversed or deleted if all of its                       CSE020
333100200529      ** subordinate actions are already deleted                                              CSE020
333200200529      *                                                                                       CSE020
333300200529     C     CSE020        IFEQ      'Y'                                                        CSE020
333400200529     C                   MOVE      'Y'           WDELAL            1                          CSE020
333500200529     C     #1SEL         IFEQ      'R'                                                        CSE020
333600200529     C     #1SEL         OREQ      'D'                                                        CSE020
333700200529     C     #1REFN        SETLL     SECORFLA                                                   CSE020
333800200529     C     #1REFN        READE     SECORFLA                               89                  CSE020
333900200529      *                                                                                       CSE020
334000200529     C     *IN89         DOWEQ     *OFF                                                       CSE020
334100200529     C     WDELAL        ANDEQ     'Y'                                                        CSE020
334200200529     C     MASTAT        IFNE      'R'                                                        CSE020
334300200529     C                   MOVE      'N'           WDELAL                                       CSE020
334400200529     C                   ENDIF                                                                CSE020
334500200529     C     #1REFN        READE     SECORFLA                               89                  CSE020
334600200529     C                   ENDDO                                                                CSE020
334700200529      *                                                                                       CSE020
334800200529     C     WDELAL        IFEQ      'N'                                                        CSE020
334900200529     C                   MOVE      'Y'           ERMSG                                        CSE020
335000200529     C                   MOVE      '1'           *IN62                                        CSE020
335100200529     C                   MOVEL     'CO00369'     ZAMSID                                       CSE020
335200200529     C                   EXSR      ZASNMS                                                     CSE020
335300200529     C                   ENDIF                                                                CSE020
335400200529     C                   ENDIF                                                                CSE020
335500200529     C                   ENDIF                                                                CSE020
335600200529      *
335700200529      **   IF 'ACTION' IS 'REPLY' AND IF PROCESSING TYPE 'NC'
335800200529      **   OR 'CC'                                                        CEU017
335900200529      *
336000200529     C     #1SEL         IFEQ      'Y'                                          B*1
336100200529     C     #1PTYP        ANDEQ     'NC'
336200200529     C     #1SEL         OREQ      'Y'                                                         CEU01
336300200529     C     #1PTYP        ANDEQ     'CC'                                                        CEU01
336400200529     C                   MOVE      'Y'           ERMSG
336500200529     C                   MOVE      '1'           *IN62                          Reverse image
336600200529     C                   MOVEL     'CO00110'     ZAMSID                         Message id.
336700200529     C                   EXSR      ZASNMS                                       Send message
336800200529     C                   ENDIF                                                  E*1
336900200529      *
337000200529     C     #1SEL         IFEQ      'F'                                          B*1
337100200529     C     #1SEL         OREQ      'V'
337200200529     C     #1SEL         OREQ      'E'
337300200529     C                   MOVE      'E'           WLACTN
337400200529     C                   ELSE                                                   X*1
337500200529     C     #1SEL         IFEQ      'N'                                          B*2            13788
337600200529     C                   MOVE      'X'           WLACTN                                        13788
337700200529     C                   ELSE                                                   X*2            13788
337800200529     C                   MOVE      #1SEL         WLACTN
337900200529     C                   ENDIF                                                  E*2            13788
338000200529     C                   ENDIF                                                  E*1
338100200529      *
338200200529     C     #1SEL         IFEQ      'E'                                          B*1
338300200529     C     #1SEL         OREQ      'Y'
338400200529     C     #1SEL         OREQ      'V'
338500200529     C     #1SEL         OREQ      'N'
338600200529     C                   EXSR      P025
338700200529     C                   ENDIF                                                  E*1
338800200529      *
338900200529      **  Check if user is authorised to the action code
339000200529      *
339100200529      **  If single branch environment
339200200529      *
339300200529     C     AGMBIN        IFNE      'Y'
339400200529     C                   CALL      'ZVACTU'
339500200529     C                   PARM                    WLACTN            1
339600200529     C                   PARM                    WLERR             1 0
339700200529      *
339800200529     C     WLERR         IFNE      *ZERO
339900200529     C                   MOVE      'Y'           ERMSG
340000200529     C                   MOVE      '1'           *IN62
340100200529     C                   MOVEL     'CO00034'     ZAMSID
340200200529     C                   EXSR      ZASNMS
340300200529     C                   ENDIF
340400200529      *
340500200529     C                   ELSE
340600200529      *
340700200529      **  If multibranching environment
340800200529      *
340900200529     C                   CALL      'ZVACTBU'
341000200529     C                   PARM                    WLACTN            1
341100200529     C                   PARM      BVBRCD        WLBRCH            3
341200200529     C                   PARM                    WLERR             1 0
341300200529      *
341400200529     C     WLERR         IFEQ      1
341500200529     C                   MOVE      'Y'           ERMSG
341600200529     C                   MOVE      '1'           *IN62
341700200529     C                   MOVEL     'CO00035'     ZAMSID
341800200529     C                   EXSR      ZASNMS
341900200529     C                   ELSE
342000200529     C     WLERR         IFEQ      2
342100200529     C                   MOVE      'Y'           ERMSG
342200200529     C                   MOVE      '1'           *IN62
342300200529     C                   MOVEL     'CO00036'     ZAMSID
342400200529     C                   EXSR      ZASNMS
342500200529     C                   ENDIF
342600200529     C                   ENDIF
342700200529      *
342800200529     C                   ENDIF
342900200529      *
343000200529     C     TAG2          ENDSR
343100200529      *****************************************************************
343200200529      /EJECT
343300200529      *****************************************************************
343400200529      * P009   : PROCESS 'ACTION'                                     *
343500200529      *****************************************************************
343600200529      *
343700200529     C     P009          BEGSR
343800200529     C/COPY WNCPYSRC,SE7502C064
343900200529      *
344000200529      **   IF ACTION IS 'AMEND' CALL 'DEPOTS MAINTENANCE' PROGRAM
344100200529      **   OR IF ACTION IS 'ENQUIRY' CALL 'DEPOTS ENQUIRY' PROGRAM
344200200529      *
344300200529     C     #1SEL         IFEQ      'A'                                          B*1
344400200529     C     #1SEL         OREQ      'E'
344500200529      *
344600200529     C                   MOVE      *BLANKS       WRTCD
344700200529      *
344800200529     C                   MOVE      #1EXDT        ZDATE
344900200529     C                   EXSR      ZDATE1
345000200529     C                   MOVE      ZDAYNO        WEXDAT
345100200529      *
345200200529     C                   MOVE      *BLANKS       WNBOP
345300200529     C                   MOVE      #1NBOP        WNBOP             2
345400200529      *
345500200529     C                   CALL      'SE7512'                             99
345600200529     C                   PARM                    #1REFN                         ER Reference
345700200529     C                   PARM                    #1SECN                         Security Shortname
345800200529     C                   PARM                    #1COAT                         Corporate Action Typ
345900200529     C                   PARM                    #1PTYP                         Processing Type
346000200529     C                   PARM                    WEXDAT            5            Ex-Date
346100200529     C                   PARM                    WNBOP                          Number of Options
346200200529     C                   PARM                    #1SEL                          Amend or Enquiry ?
346300200529     C                   PARM      *BLANKS       WWGSTS            1            General Status
346400200529     C                   PARM                    WRTCD             1            Return Code
346500200529      *
346600200529     C     #1SEL         IFEQ      'A'                                          B*2
346700200529     C                   MOVE      WWGSTS        #1GSTS
346800200529      *                                                                   137879
346900200529      **  RETRIEVE THE "HIGHER" STATUS AND FINAL ALLOCATION INDICATOR     137879
347000200529      *                                                                   137879
347100200529     C                   MOVE      *BLANKS       #1STAT                                        13787
347200200529     C                   MOVE      *BLANKS       #1FINA                                        13787
347300200529     C                   MOVE      'Y'           WFIRST            1                           13787
347400200529      *                                                                   137879
347500200529     C     #1REFN        SETLL     SECODRL1                                                    13787
347600200529     C     #1REFN        READE     SECODRL1                               89                   13787
347700200529      *                                                                   137879
347800200529     C     *IN89         IFEQ      '1'                                          B*3            13787
347900200529     C                   MOVE      MASTAT        #1STAT                                        13787
348000200529     C                   ENDIF                                                  E*3            13787
348100200529      *                                                                   137879
348200200529     C     *IN89         DOWEQ     '0'                                          B*3            13787
348300200529      *                                                                   137879
348400200529     C     MSRECI        IFEQ      'D'                                          B*4            13787
348500200529      *                                                                   137879
348600200529     C     WFIRST        IFEQ      'Y'                                          B*5            13787
348700200529     C                   MOVE      MSFAID        #1FINA                                        13787
348800200529     C                   MOVE      MSCOST        #1STAT                                        13787
348900200529     C                   MOVE      'N'           WFIRST                                        13787
349000200529     C                   ELSE                                                   X*5            13787
349100200529      *                                                                   137879
349200200529      **  RETRIEVE THE "HIGHER" FINAL ALLOCATION INDICATOR                137879
349300200529      *                                                                   137879
349400200529     C     MSFAID        IFEQ      'Y'                                          B*6            13787
349500200529     C                   MOVE      MSFAID        #1FINA                                        13787
349600200529     C                   ELSE                                                   X*6            13787
349700200529     C     MSFAID        IFEQ      'S'                                          B*7            13787
349800200529     C     #1FINA        ANDEQ     'N'                                                         13787
349900200529     C                   MOVE      MSFAID        #1FINA                                        13787
350000200529     C                   ENDIF                                                  E*7            13787
350100200529     C                   ENDIF                                                  E*6            13787
350200200529      *                                                                   137879
350300200529      **  RETRIEVE THE "HIGHER" STATUS                                    137879
350400200529      *                                                                   137879
350500200529     C     MSCOST        IFEQ      'C'                                          B*6            13787
350600200529     C                   MOVE      MSCOST        #1STAT                                        13787
350700200529     C                   ELSE                                                   X*6            13787
350800200529     C     MSCOST        IFEQ      'X'                                          B*7            13787
350900200529     C     #1STAT        IFEQ      'S'                                          B*8            13787
351000200529     C     #1STAT        OREQ      'L'                                                         13787
351100200529     C     #1STAT        OREQ      'I'                                                         13787
351200200529     C                   MOVE      MSCOST        #1STAT                                        13787
351300200529     C                   ENDIF                                                  E*8            13787
351400200529     C                   ENDIF                                                  E*7            13787
351500200529      *                                                                   137879
351600200529     C     MSCOST        IFEQ      'S'                                          B*7            13787
351700200529     C     #1STAT        IFEQ      'L'                                          B*8            13787
351800200529     C     #1STAT        OREQ      'I'                                                         13787
351900200529     C                   MOVE      MSCOST        #1STAT                                        13787
352000200529     C                   ENDIF                                                  E*8            13787
352100200529     C                   ENDIF                                                  E*7            13787
352200200529      *                                                                   137879
352300200529     C     MSCOST        IFEQ      'L'                                          B*7            13787
352400200529     C     #1STAT        ANDEQ     'I'                                                         13787
352500200529     C                   MOVE      MSCOST        #1STAT                                        13787
352600200529     C                   ENDIF                                                  E*7            13787
352700200529     C                   ENDIF                                                  E*6            13787
352800200529     C                   ENDIF                                                  E*5            13787
352900200529     C                   ENDIF                                                  E*4            13787
353000200529      *                                                                   137879
353100200529     C     #1REFN        READE     SECODRL1                               89                   13787
353200200529     C                   ENDDO                                                  E*3            13787
353300200529      *                                                                   137879
353400200529     C     #1FINA        IFEQ      *BLANKS                                      B*3            13787
353500200529     C     #1STAT        ANDEQ     *BLANKS                                                     13787
353600200529     C                   MOVE      'N'           #1FINA                                        13787
353700200529     C                   MOVE      'I'           #1STAT                                        13787
353800200529     C                   ENDIF                                                  E*3            13787
353900200529     C                   ENDIF                                                  E*2
354000200529      *
354100200529      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
354200200529      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
354300200529      **         DATABASE ERROR
354400200529      *
354500200529     C     *IN99         IFEQ      '1'                                          B*2
354600200529     C     WRTCD         OREQ      'E'
354700200529     C                   MOVEL     '006'         DBASE             3 0          *****************
354800200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 06 **
354900200529     C                   MOVEL     NARR(5)       DBKEY            29            *****************
355000200529     C                   EXSR      *PSSR
355100200529     C                   ENDIF                                                  E*2
355200200529      *
355300200529     C     WRTCD         IFNE      'M'                                          B*2
355400200529     C                   MOVE      *BLANKS       #1SEL
355500200529     C                   ENDIF                                                  E*2
355600200529      *
355700200529      **   IF RETURN CODE IS EQUAL TO '2', '3' OR 'M'
355800200529      *
355900200529     C     WRTCD         IFEQ      '2'                                          B*2
356000200529     C     WRTCD         OREQ      '3'
356100200529     C     WRTCD         OREQ      'M'
356200200529      *
356300200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
356400200529      *
356500200529     C     #1REFN        CHAIN     SECORFL0                           88
356600200529      *
356700200529     C                   MOVE      *BLANKS       MAJOBN
356800200529     C                   MOVE      *BLANKS       MAUSER
356900200529     C                   Z-ADD     *ZEROS        MAJNBR
357000200529      *
357100200529     C                   UPDATE    SECORFD0
357200200529     C                   MOVE      FIELD         #FIELD
357300200529     C/COPY WNCPYSRC,SE7502C004
357400200529      *
357500200529      **   COMMITMENT INSTRUCTION
357600200529      *
357700200529     C                   COMMIT
357800200529      *
357900200529     C     WRTCD         IFEQ      '3'                                          B*3
358000200529     C                   MOVE      '1'           *INKC
358100200529     C                   ENDIF                                                  E*3
358200200529      *
358300200529     C     WRTCD         IFEQ      'M'                                          B*3
358400200529     C                   MOVE      'Y'           ERMSG
358500200529     C                   MOVE      '1'           *IN62                          Reverse image
358600200529     C                   MOVEL     'CO00031'     ZAMSID                         Message id.
358700200529     C                   EXSR      ZASNMS                                       Send message
358800200529     C                   ENDIF                                                  E*3
358900200529      *
359000200529     C                   GOTO      TAG3
359100200529     C                   ENDIF                                                  E*2
359200200529     C                   ENDIF                                                  E*1
359300200529      *
359400200529      **   IF 'ACTION' IS PRINT
359500200529      *
359600200529     C     #1SEL         IFEQ      'P'                                          B*1
359700200529      *
359800200529     C                   MOVE      *BLANKS       #1SEL
359900200529      *
360000200529     C                   MOVE      *BLANKS       @PARM           100
360100200529     C                   MOVEL     'SE7533'      @RNAM
360200200529     C                   MOVEL     'SEC7533B'    @COTT
360300200529      *
360400200529     C                   CALL      'FC0040X'
360500200529     C                   PARM      *BLANKS       @RTCD             7
360600200529     C                   PARM                    @RNAM            10
360700200529     C                   PARM                    @COTT            10
360800200529     C                   PARM      '10004'       @CSEQ             5
360900200529     C                   PARM      #1REFN        @PARM           100
361000200529     C                   PARM      AGMBIN        @MBRC             1
361100200529     C                   PARM      'S'           @LVL              1
361200200529     C                   PARM      *BLANKS       @ETTY             3
361300200529      *
361400200529      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
361500200529      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
361600200529      **         DATABASE ERROR
361700200529      *
361800200529     C     @RTCD         IFNE      *BLANKS
361900200529     C                   MOVEL     '008'         DBASE             3 0          *****************
362000200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 08 **
362100200529     C                   MOVEL     NARR(8)       DBKEY            29            *****************
362200200529     C                   EXSR      *PSSR
362300200529     C                   ENDIF                                                  E*2
362400200529      *
362500200529      **   IF RETURN CODE IS EQUAL TO BLANK
362600200529      *
362700200529     C     @RTCD         IFEQ      ' '                                          B*2
362800200529      *
362900200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
363000200529      *
363100200529     C     #1REFN        CHAIN     SECORFL0                           88
363200200529      *
363300200529     C                   MOVE      *BLANKS       MAJOBN
363400200529     C                   MOVE      *BLANKS       MAUSER
363500200529     C                   Z-ADD     *ZEROS        MAJNBR
363600200529      *
363700200529     C                   UPDATE    SECORFD0
363800200529     C                   MOVE      FIELD         #FIELD
363900200529      *
364000200529     C                   MOVEL     'CO00294'     ZAMSID
364100200529     C                   EXSR      ZASNMS
364200200529      *
364300200529      **   COMMITMENT INSTRUCTION
364400200529      *
364500200529     C                   COMMIT
364600200529      *
364700200529     C                   ENDIF                                                  E*2
364800200529     C                   ENDIF                                                  E*1
364900200529      *
365000200529      **   IF 'ACTION' IS REVERSE, DELETE OR AUTHORISATION (PROCESSING TYPE 'NC'
365100200529      *
365200200529     C     #1SEL         IFEQ      'R'
365300200529     C     #1SEL         OREQ      'D'
365400200529     C     #1SEL         OREQ      'N'
365500200529      *
365600200529      **   PRODUCE CONFIRMATION SCREEN
365700200529      *
365800200529     C                   EXSR      P010
365900200529      *
366000200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
366100200529      *
366200200529     C                   CALL      'Y2CLMSC'
366300200529     C                   PARM      ##PGM         ZAPGM            10
366400200529     C                   PARM      '*SAME'       ZAPGRL            5
366500200529      *
366600200529      **   IF CONFIRMATION INDICATOR RETURNED IS NOT EQUAL TO 'Y'
366700200529      *
366800200529     C     #1CONF        IFNE      'Y'                                          B*2
366900200529      *
367000200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
367100200529      *
367200200529     C     #1REFN        CHAIN     SECORFL0                           88
367300200529      *
367400200529     C                   MOVE      *BLANKS       MAJOBN
367500200529     C                   MOVE      *BLANKS       MAUSER
367600200529     C                   Z-ADD     *ZEROS        MAJNBR
367700200529      *
367800200529     C                   UPDATE    SECORFD0
367900200529     C                   MOVE      FIELD         #FIELD
368000200529      *
368100200529     C                   COMMIT
368200200529      *
368300200529     C                   MOVE      *BLANKS       #1SEL
368400200529      *
368500200529      **   TERMINATE CURRENT PROCESSING
368600200529      *
368700200529     C                   GOTO      TAG3
368800200529      *
368900200529     C                   ENDIF                                                  E*2
369000200529     C                   ENDIF                                                  E*1
369100200529      *
369200200529      **   IF 'ACTION' IS REVERSE
369300200529      *
369400200529     C     #1SEL         IFEQ      'R'                                          B*1
369500200529      *
369600200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
369700200529      *
369800200529     C     #1REFN        CHAIN     SECORFL0                           88
369900200529      *
370000200529     C                   MOVE      'D'           MARECI
370100200529     C                   Z-ADD     BJRDNB        MALCD
370200200529     C                   MOVE      'R'           MACHTP
370300200529     C                   MOVE      ##USR         MALUID
370400200529      *
370500200529      **   IF EX-DATE CHANGED
370600200529      *
370700200529     C     #1EXDT        IFNE      #2EXDT                                       B*2
370800200529     C                   MOVE      #1EXDT        ZDATE
370900200529     C                   EXSR      ZDATE1
371000200529     C                   Z-ADD     ZDAYNO        MACOEX
371100200529      *
371200200529     C                   MOVE      #1EXDT        #2EXDT
371300200529     C                   ENDIF                                                  E*2
371400200529      *
371500200529      **   IF DATE OF ANNOUNCEMENT CHANGED
371600200529      *
371700200529     C     #1COAN        IFNE      #2COAN                                       B*2
371800200529     C                   MOVE      #1COAN        ZDATE
371900200529     C                   EXSR      ZDATE1
372000200529     C                   Z-ADD     ZDAYNO        MACOAN
372100200529      *
372200200529     C                   MOVE      #1COAN        #2COAN
372300200529     C                   ENDIF                                                  E*2
372400200529      *
372500200529      **   IF ALLOCATION EFFECTIVE DATE CHANGED
372600200529      *
372700200529     C     #1ALEF        IFNE      #2ALEF                                       B*2
372800200529     C                   MOVE      #1ALEF        ZDATE
372900200529     C                   EXSR      ZDATE1
373000200529     C                   Z-ADD     ZDAYNO        MAALEF
373100200529      *
373200200529     C                   MOVE      #1ALEF        #2ALEF
373300200529     C                   ENDIF                                                  E*2
373400200529      *
373500200529     C     #1REFN        SETLL     SECOALL0
373600200529     C     #1REFN        READE     SECOALL0                               89
373700200529      *
373800200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
373900200529      *
374000200529     C     *IN89         DOWEQ     '0'                                          B*2
374100200529     C     #1REFN        ANDEQ     MCCORF
374200200529      *
374300200529     C     MCRECI        IFEQ      '*'                                          B*3
374400200529     C                   DELETE    SECOALD0
374500200529     C                   ELSE                                                   X*3
374600200529     C                   MOVE      '*'           MCRECI
374700200529     C                   Z-ADD     BJRDNB        MCLCD
374800200529     C                   MOVE      'R'           MCCHTP
374900200529     C                   MOVE      ##USR         MCLUID
375000200529     C                   UPDATE    SECOALD0
375100200529     C                   ENDIF                                                  E*3
375200200529      *
375300200529      **   ACCESS NEXT RECORD
375400200529      *
375500200529     C     #1REFN        READE     SECOALL0                               89
375600200529     C                   ENDDO                                                  E*2
375700200529      *
375800200529     C     #1REFN        SETLL     SECODPL0
375900200529     C     #1REFN        READE     SECODPL0                               89
376000200529      *
376100200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
376200200529      *
376300200529     C     *IN89         DOWEQ     '0'                                          B*2
376400200529     C     #1REFN        ANDEQ     MBCORF
376500200529      *
376600200529     C     MBRECI        IFEQ      '*'                                          B*3
376700200529     C                   DELETE    SECODPD0
376800200529     C                   ELSE                                                   X*3
376900200529     C                   MOVE      '*'           MBRECI
377000200529     C                   Z-ADD     BJRDNB        MBLCD
377100200529     C                   MOVE      'R'           MBCHTP
377200200529     C                   MOVE      ##USR         MBLUID
377300200529     C                   UPDATE    SECODPD0
377400200529     C                   ENDIF                                                  E*3
377500200529      *
377600200529      **   ACCESS NEXT RECORD
377700200529      *
377800200529     C     #1REFN        READE     SECODPL0                               89
377900200529     C                   ENDDO                                                  E*2
378000200529      *
378100200529     C     #1REFN        SETLL     SECODRL0
378200200529     C     #1REFN        READE     SECODRL0                               89
378300200529      *
378400200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
378500200529      *
378600200529     C     *IN89         DOWEQ     '0'                                          B*2
378700200529     C     #1REFN        ANDEQ     MSCORF
378800200529      *
378900200529     C                   Z-ADD     BJRDNB        MSLCD
379000200529     C                   MOVE      'R'           MSCHTP
379100200529     C                   MOVE      ##USR         MSLUID
379200200529     C                   MOVE      'R'           MSCOST
379300200529     C                   UPDATE    SECODRD0
379400200529      *
379500200529      **   ACCESS NEXT RECORD
379600200529      *
379700200529     C     #1REFN        READE     SECODRL0                               89
379800200529     C                   ENDDO                                                  E*2
379900200529      *                                                                   138962
380000200529      ***  Reverse records on Blocking File.                              138962
380100200529      *                                                                   138962
380200200529     C     #1REFN        SETLL     SECOBKL1                                                    13896
380300200529     C     #1REFN        READE     SECOBKL1                               89                   13896
380400200529      *                                                                   138962
380500200529      ***  Do while end of file not reached.                              138962
380600200529      *                                                                   138962
380700200529     C     *IN89         DOWEQ     '0'                                          B*2            13896
380800200529      *                                                                   138962
380900200529     C     MURECI        IFEQ      '*'                                          B*3            13896
381000200529     C                   DELETE    SECOBKD0                                                    13896
381100200529     C                   ELSE                                                   X*3            13896
381200200529     C                   Z-ADD     BJRDNB        MULCD                                         13896
381300200529     C                   MOVE      'R'           MUCHTP                                        13896
381400200529     C                   MOVE      ##USR         MULUID                                        13896
381500200529     C                   MOVE      '*'           MURECI                                        13896
381600200529     C                   UPDATE    SECOBKD0                                                    13896
381700200529     C                   ENDIF                                                  E*3            13896
381800200529      *                                                                   138962
381900200529      ***  Access next record.                                            138962
382000200529      *                                                                   138962
382100200529     C     #1REFN        READE     SECOBKL1                               89                   13896
382200200529     C                   ENDDO                                                  E*2            13896
382300200529      *
382400200529     C                   MOVE      *BLANKS       MAJOBN
382500200529     C                   MOVE      *BLANKS       MAUSER
382600200529     C                   Z-ADD     *ZEROS        MAJNBR
382700200529     C                   MOVE      'R'           MASTAT
382800200529      *
382900200529     C                   UPDATE    SECORFD0
383000200529     C                   MOVE(P)   FIELD         WWFLD           175                           13896
383100200529      *                                                                   138962
383200200529      *****If*Exercises*and*Conversions*and*'DV'*or*'RG'*linked*** 138962 148743
383300200529      *****Corporate Action*exists.******************************* 138962 148743
383400200529      ***  If Exercises and Conversions and 'DV', 'RG' or 'OF' linked     148743
383500200529      ***  Corporate Action exists.                                       148743
383600200529      *                                                                   138962
383700200529     C     #1PTYP        IFEQ      'EX'                                                        13896
383800200529     C     WWLNKR        ANDNE     *BLANKS                                                     13896
383900200529     C     WWLNKR        CHAIN     SECORFL9                           89                       13896
384000200529      *                                                                   138962
384100200529      *****If*Status*of*the*'DV'*or*'RG'*linked*Corporate*Action** 138962 148743
384200200529      *****neither*Stock*Autorised,*nor*Fully*Authorised,*nor***** 138962 148743
384300200529      *****Complete,*set*'Rights'*fields*to*blank*or*zero*(and**** 138962 148743
384400200529      *****'Subscription*Rights*Tradable'*field*if*'DV'*to*'N').** 138962 148743
384500200529      ***  If Status of the 'DV', 'RG' or 'FR' linked Corporate Action    148743
384600200529      ***  neither Stock Autorised, nor Fully Authorised, nor Complete,   148743
384700200529      ***  set 'Rights' fields to blank or zero (and 'Subscription Rights 148743
384800200529      ***  Tradable' field if 'DV' to 'N').                               148743
384900200529      *                                                                   138962
385000200529     C     *IN89         IFEQ      '0'                                                         13896
385100200529     C     MASTAT        IFNE      'S'                                                         13896
385200200529     C     MASTAT        ANDNE     'X'                                                         13896
385300200529     C     MASTAT        ANDNE     'C'                                                         13896
385400200529     C     WWPTYP        IFEQ      'DV'                                                        13896
385500200529     C     WWLNKR        CHAIN     SECODVL0                           89                       13896
385600200529     C     *IN89         IFEQ      '0'                                                         13896
385700200529     C                   MOVE      'N'           MDSBRT                                        13896
385800200529     C                   MOVE      *BLANKS       MDSBRS                                        13896
385900200529     C                   Z-ADD     0             MDREPR                                        13896
386000200529     C                   Z-ADD     0             MDREXD                                        13896
386100200529     C                   Z-ADD     0             MDREXA                                        13896
386200200529     C                   MOVE      *BLANKS       MDREAT                                        13896
386300200529     C                   Z-ADD     0             MDRNNS                                        13896
386400200529     C                   Z-ADD     0             MDRNRI                                        13896
386500200529     C                   Z-ADD     0             MDRMLT                                        13896
386600200529     C                   Z-ADD     0             MDRDIV                                        13896
386700200529     C                   Z-ADD     0             MDRTRF                                        13896
386800200529     C                   Z-ADD     0             MDRTRT                                        13896
386900200529     C                   Z-ADD     BJRDNB        MDLCD                                         13896
387000200529     C                   MOVE      'A'           MDCHTP                                        13896
387100200529     C                   MOVE      ##USR         MDLUID                                        13896
387200200529     C                   UPDATE    SECODVD0                                                    13896
387300200529     C                   ENDIF                                                                 13896
387400200529     C                   ELSE                                                                  13896
387500200529     C     WWPTYP        IFEQ      'RG'                                                        14874
387600200529     C     WWLNKR        CHAIN     SECORGL0                           89                       13896
387700200529     C     *IN89         IFEQ      '0'                                                         13896
387800200529     C                   MOVE      *BLANKS       MFSBRS                                        13896
387900200529     C                   Z-ADD     0             MFSBRP                                        13896
388000200529     C                   Z-ADD     0             MFREXD                                        13896
388100200529     C                   Z-ADD     0             MFREXA                                        13896
388200200529     C                   MOVE      *BLANKS       MFREAT                                        13896
388300200529     C                   Z-ADD     0             MFRNNS                                        13896
388400200529     C                   Z-ADD     0             MFRNRI                                        13896
388500200529     C                   Z-ADD     0             MFRMLT                                        13896
388600200529     C                   Z-ADD     0             MFRDIV                                        13896
388700200529     C                   Z-ADD     0             MFRTRF                                        13896
388800200529     C                   Z-ADD     0             MFRTRT                                        13896
388900200529     C                   MOVE      *BLANKS       MFAVOP                                        13896
389000200529     C                   Z-ADD     BJRDNB        MFLCD                                         13896
389100200529     C                   MOVE      'A'           MFCHTP                                        13896
389200200529     C                   MOVE      ##USR         MFLUID                                        13896
389300200529     C                   UPDATE    SECORGD0                                                    13896
389400200529     C                   ENDIF                                                                 13896
389500200529     C                   ELSE                                                                  14874
389600200529     C     WWLNKR        CHAIN     SECOFRL0                           89                       14874
389700200529     C     *IN89         IFEQ      '0'                                                         14874
389800200529     C                   MOVE      'N'           MESBRT                                        14874
389900200529     C                   MOVE      *BLANKS       MESBRS                                        14874
390000200529     C                   Z-ADD     0             MEREPR                                        14874
390100200529     C                   Z-ADD     0             MEREXD                                        14874
390200200529     C                   Z-ADD     0             MEREXA                                        14874
390300200529     C                   MOVE      *BLANKS       MEREAT                                        14874
390400200529     C                   Z-ADD     0             MERNNS                                        14874
390500200529     C                   Z-ADD     0             MERNRI                                        14874
390600200529     C                   Z-ADD     0             MERMLT                                        14874
390700200529     C                   Z-ADD     0             MERDIV                                        14874
390800200529     C                   Z-ADD     0             MERTRF                                        14874
390900200529     C                   Z-ADD     0             MERTRT                                        14874
391000200529     C                   Z-ADD     BJRDNB        MELCD                                         14874
391100200529     C                   MOVE      'A'           MECHTP                                        14874
391200200529     C                   MOVE      ##USR         MELUID                                        14874
391300200529     C                   UPDATE    SECOFRD0                                                    14874
391400200529     C                   ENDIF                                                                 14874
391500200529     C                   ENDIF                                                                 14874
391600200529     C                   ENDIF                                                                 13896
391700200529      *                                                                   138962
391800200529     C     #1REFN        CHAIN     SECOEXL0                           89                       13896
391900200529     C     *IN89         IFEQ      '0'                                                         13896
392000200529     C                   MOVE      *BLANKS       MJLNKR                                        13896
392100200529     C                   Z-ADD     BJRDNB        MJLCD                                         13896
392200200529     C                   MOVE      'A'           MJCHTP                                        13896
392300200529     C                   MOVE      ##USR         MJLUID                                        13896
392400200529     C                   UPDATE    SECOEXD0                                                    13896
392500200529     C                   ENDIF                                                                 13896
392600200529     C                   ENDIF                                                                 13896
392700200529     C                   ENDIF                                                                 13896
392800200529     C                   MOVE      WWFLD         FIELD                                         13896
392900200529     C                   ENDIF                                                                 13896
393000200529      *
393100200529     C     #1PTYP        IFEQ      'CC'                                         B*2            CEU01
393200200529     C     #1REFN        CHAIN     SECOCCL0                           89                       CEU01
393300200529      *                                                                   CEU017
393400200529     C     *IN89         IFEQ      '0'                                                         CEU01
393500200529     C                   MOVE      '*'           NARECI                                        CEU01
393600200529     C                   Z-ADD     BJRDNB        NALCD                                         CEU01
393700200529     C                   MOVE      'R'           NACHTP                                        CEU01
393800200529     C                   MOVE      ##USR         NALUID                                        CEU01
393900200529     C                   UPDATE    SECOCCD0                                                    CEU01
394000200529     C                   ENDIF                                                                 CEU01
394100200529      *                                                                   CEU017
394200200529     C     NABLKR        IFNE      *ZEROS                                       B*3            CEU01
394300200529     C     *IN89         ANDEQ     '0'                                                         CEU01
394400200529     C                   Z-ADD     *ZEROS        WCOUNT                                        13787
394500200529     C                   MOVE      #1REFN        W1REFN                                        13787
394600200529     C     NABLKR        CHAIN     SECORBL0                           89                       CEU01
394700200529      *                                                                   CEU017
394800200529      **  Reverse all matching records in LF/SECORSL0                     CEU017
394900200529     C     NBBLKR        SETLL     SECORSL0                                                    CEU01
395000200529     C     NBBLKR        READE     SECORSL0                               89                   CEU01
395100200529      *                                                                   CEU017
395200200529     C     *IN89         DOWEQ     '0'                                          B*4            CEU01
395300200529     C     NCRECI        IFEQ      'D'                                          B*5            13787
395400200529     C                   ADD       1             WCOUNT                                        13787
395500200529     C                   ENDIF                                                  E*5            13787
395600200529     C     W1REFN        IFEQ      NCCORF                                       B*5            13787
395700200529     C                   MOVE      '*'           NCRECI                                        CEU01
395800200529     C                   Z-ADD     BJRDNB        NCLCD                                         CEU01
395900200529     C                   MOVE      'R'           NCCHTP                                        CEU01
396000200529     C                   MOVE      ##USR         NCLUID                                        CEU01
396100200529     C                   UPDATE    SECORSD0                                                    CEU01
396200200529     C                   SUB       1             WCOUNT                                        13787
396300200529     C                   ENDIF                                                  E*5            13787
396400200529     C     NBBLKR        READE     SECORSL0                               89                   CEU01
396500200529     C                   ENDDO                                                  E*4            CEU01
396600200529      *                                                                   CEU017
396700200529      **  Reverse matching record in LF/SECORBL0                          CEU017
396800200529     C     WCOUNT        IFEQ      *ZEROS                                       B*4            13787
396900200529     C                   MOVE      'R'           NBSTAT                                        CEU01
397000200529     C                   Z-ADD     BJRDNB        NBLCD                                         CEU01
397100200529     C                   MOVE      'R'           NBCHTP                                        CEU01
397200200529     C                   MOVE      ##USR         NBLUID                                        CEU01
397300200529     C                   UPDATE    SECORBD0                                                    CEU01
397400200529     C                   ENDIF                                                  E*4            13787
397500200529     C                   ENDIF                                                  E*3            CEU01
397600200529      *                                                                   CEU017
397700200529     C                   ENDIF                                                  E*2            CEU01
397800200529      *
397900200529      **   UPDATE SUBFILE FIELDS
398000200529      *
398100200529     C                   MOVE      FIELD         #FIELD
398200200529     C                   MOVE      *BLANKS       #1SEL
398300200529     C                   MOVE      'R'           #1STAT
398400200529     C                   MOVE      'R'           #1GSTS
398500200529      *
398600200529      **   COMMITMENT INSTRUCTION
398700200529      *
398800200529     C                   COMMIT
398900200529     C                   ENDIF                                                  E*1
399000200529      *
399100200529      **   IF 'ACTION' IS 'GENERAL INFORMATION', 'F' - ENQUIRY OR 'G' - MAINTENA
399200200529      *
399300200529     C     #1SEL         IFEQ      'F'                                          B*1
399400200529     C     #1SEL         OREQ      'G'
399500200529      *                                                                   CEU017
399600200529     C                   MOVE      '0'           *IN35                                         CEU01
399700200529     C     #1PTYP        IFEQ      'CC'                                         B*1            CEU01
399800200529     C                   MOVE      '1'           *IN35                                         CEU01
399900200529     C                   ENDIF                                                  E*1            CEU01
400000200529      *
400100200529     C                   MOVE      *IN61         WIN61             1
400200200529     C     #1SEL         IFEQ      'F'                                          B*2
400300200529     C                   MOVE      '1'           *IN61
400400200529     C                   ENDIF                                                  E*2
400500200529     C/COPY WNCPYSRC,SEH00007
400600200529      *
400700200529      **   INITIALISE ERROR INDICATORS
400800200529      *
400900200529     C                   EVAL      *IN07 = *OFF                                               CGL031
401000200529     C                   MOVE      '0'           *IN13
401100200529     C                   MOVE      '0'           *IN14
401200200529     C                   MOVE      '0'           *IN20
401300200529     C                   MOVE      '0'           *IN21
401400200529     C                   MOVE      '0'           *IN22
401500200529     C                   MOVE      '0'           *IN23
401600200529     C                   MOVE      '0'           *IN24
401700200529     C                   MOVE      '0'           *IN31
401800200529     C                   MOVE      '0'           *IN42
401900200529     C                   MOVE      '0'           *IN49
402000200529     C                   MOVE      '0'           *IN60
402100200529     C                   MOVE      '0'           *IN65
402200200529     C                   MOVE      '0'           *IN66
402300200529     C                   MOVE      '0'           *IN67
402400200529     C                   MOVE      '0'           *IN70
402500200529     C                   MOVE      '0'           *IN71
402600200529     C                   MOVE      '0'           *IN72
402700200529     C                   MOVE      '0'           *IN73
402800200529     C                   MOVE      '0'           *IN74
402900200529     C                   MOVE      '0'           *IN76
403000200529     C                   MOVE      '0'           *IN77
403100200529     C                   MOVE      '0'           *IN78
403200200529     C                   MOVE      '0'           *IN79
403300200529     C                   MOVE      '0'           *IN82
403400200529     C                   MOVE      '0'           *IN83
403500200529     C                   MOVE      '0'           *IN85
403600200529      *
403700200529      **   PROCESS 'FULL DETAILS' SCREEN
403800200529      *
403900200529     C                   EXSR      P018
404000200529      *
404100200529      **   IF F3 OR F12 IS PRESSED OR IF ALL FIELDS PROTECTED
404200200529      *
404300200529     C     *INKC         IFEQ      '1'                                          B*2
404400200529     C     *INKL         OREQ      '1'
404500200529     C     *IN61         OREQ      '1'
404600200529      *
404700200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
404800200529      *
404900200529     C     #1REFN        CHAIN     SECORFL0                           88
405000200529      *
405100200529     C                   MOVE      *BLANKS       MAJOBN
405200200529     C                   MOVE      *BLANKS       MAUSER
405300200529     C                   Z-ADD     *ZEROS        MAJNBR
405400200529      *
405500200529     C                   UPDATE    SECORFD0
405600200529      *
405700200529      **   UPDATE SUBFILE FIELDS
405800200529      *
405900200529     C                   MOVE      FIELD         #FIELD
406000200529      *
406100200529      **   COMMITMENT INSTRUCTION
406200200529      *
406300200529     C                   COMMIT
406400200529     C                   ENDIF                                                  E*2
406500200529      *
406600200529     C                   MOVE      *BLANKS       #1SEL
406700200529      *
406800200529     C                   MOVE      WIN61         *IN61
406900200529      *
407000200529     C                   ENDIF                                                  E*1
407100200529      *
407200200529      **   IF 'ACTION' IS DELETE
407300200529      *
407400200529     C     #1SEL         IFEQ      'D'                                          B*1
407500200529      *
407600200529      **   DELETE RECORDS IN DEPOT FILES
407700200529      *
407800200529     C     #1REFN        SETLL     SECODPL0
407900200529     C     #1REFN        READE     SECODPL0                               89
408000200529      *
408100200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
408200200529      *
408300200529     C     *IN89         DOWEQ     '0'                                          B*2
408400200529     C     #1REFN        ANDEQ     MBCORF
408500200529      *
408600200529     C                   DELETE    SECODPD0
408700200529      *
408800200529      **   ACCESS NEXT RECORD
408900200529      *
409000200529     C     #1REFN        READE     SECODPL0                               89
409100200529     C                   ENDDO                                                  E*2
409200200529      *
409300200529      **   DELETE RECORDS IN DEPOT FILES
409400200529      *
409500200529     C     #1REFN        SETLL     SECODRL0
409600200529     C     #1REFN        READE     SECODRL0                               89
409700200529      *
409800200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
409900200529      *
410000200529     C     *IN89         DOWEQ     '0'                                          B*2
410100200529     C     #1REFN        ANDEQ     MSCORF
410200200529      *
410300200529     C                   DELETE    SECODRD0
410400200529      *
410500200529      **   ACCESS NEXT RECORD
410600200529      *
410700200529     C     #1REFN        READE     SECODRL0                               89
410800200529     C                   ENDDO                                                  E*2
410900200529      *
411000200529      **   DELETE RECORDS IN ALLOCATION FILES
411100200529      *
411200200529     C     #1REFN        SETLL     SECOALL0
411300200529     C     #1REFN        READE     SECOALL0                               89
411400200529      *
411500200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
411600200529      *
411700200529     C     *IN89         DOWEQ     '0'                                          B*2
411800200529     C     #1REFN        ANDEQ     MCCORF
411900200529      *
412000200529     C                   DELETE    SECOALD0
412100200529      *
412200200529      **   ACCESS NEXT RECORD
412300200529      *
412400200529     C     #1REFN        READE     SECOALL0                               89
412500200529     C                   ENDDO                                                  E*2
412600200529      *
412700200529      **   DELETE RECORDS IN REPLY HANDLING FILES
412800200529      *
412900200529     C     #1REFN        SETLL     SECOREL0
413000200529     C     #1REFN        READE     SECOREL0                               89
413100200529      *
413200200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
413300200529      *
413400200529     C     *IN89         DOWEQ     '0'                                          B*2
413500200529     C     #1REFN        ANDEQ     MQCORF
413600200529      *
413700200529     C                   DELETE    SECORED0
413800200529      *
413900200529      **   ACCESS NEXT RECORD
414000200529      *
414100200529     C     #1REFN        READE     SECOREL0                               89
414200200529     C                   ENDDO                                                  E*2
414300200529      *
414400200529      **   DELETE RECORDS IN HISTORIC REPLY HANDLING FILES
414500200529      *
414600200529     C     #1REFN        SETLL     SECORHL0
414700200529     C     #1REFN        READE     SECORHL0                               89
414800200529      *
414900200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
415000200529      *
415100200529     C     *IN89         DOWEQ     '0'                                          B*2
415200200529     C     #1REFN        ANDEQ     MPCORF
415300200529      *
415400200529     C                   DELETE    SECORHD0
415500200529      *
415600200529      **   ACCESS NEXT RECORD
415700200529      *
415800200529     C     #1REFN        READE     SECORHL0                               89
415900200529     C                   ENDDO                                                  E*2
416000200529      *
416100200529      **   DELETE RECORDS IN BLOCKING FILE
416200200529      *
416300200529     C     #1REFN        SETLL     SECOBKL1
416400200529     C     #1REFN        READE     SECOBKL1                               89
416500200529      *
416600200529      **   DO WHILE END OF FILE NOT REACHED AND SAME REFERENCE NUMBER
416700200529      *
416800200529     C     *IN89         DOWEQ     '0'                                          B*2
416900200529     C     #1REFN        ANDEQ     MUCORF
417000200529      *
417100200529     C                   DELETE    SECOBKD0
417200200529      *
417300200529      **   ACCESS NEXT RECORD
417400200529      *
417500200529     C     #1REFN        READE     SECOBKL1                               89
417600200529     C                   ENDDO                                                  E*2
417700200529      *
417800200529      **   DELETE ALL THE RELATIVE OPTIONS
417900200529      *
418000200529     C                   EXSR      P022
418100200529      *
418200200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
418300200529      *
418400200529     C     #1REFN        CHAIN     SECORFL0                           88
418500200529     C                   DELETE    SECORFD0
418600200529      *                                                                   138962
418700200529      *****If*Exercises*and*Conversions*and*'DV'*or*'RG'*linked*** 138962 148743
418800200529      *****Corporate*Action*exists.******************************* 138962 148743
418900200529      ***  If Exercises and Conversions and 'DV', 'RG' or 'FR' linked     148743
419000200529      ***  Corporate Action exists.                                       148743
419100200529      *                                                                   138962
419200200529     C     #1PTYP        IFEQ      'EX'                                                        13896
419300200529     C     WWLNKR        ANDNE     *BLANKS                                                     13896
419400200529     C     WWLNKR        CHAIN     SECORFL9                           89                       13896
419500200529      *                                                                   138962
419600200529      *****If*Status*of*the*'DV'*or*'RG'*linked*Corporate*Action** 138962 148743
419700200529      *****neither*Stock*Autorised,*nor*Fully*Authorised,*nor***** 138962 148743
419800200529      *****Complete,*set*'Rights'*fields*to*blank*or*zero*(and**** 138962 148743
419900200529      *****'Subscription*Rights*Tradable'*field*if*'DV'*to*'N').** 138962 148743
420000200529      ***  If Status of the 'DV', 'RG' or 'FR' linked Corporate Action    148743
420100200529      ***  neither Stock Autorised, nor Fully Authorised, nor Complete,   148743
420200200529      ***  set 'Rights' fields to blank or zero (and 'Subscription Rights 148743
420300200529      ***  Tradable' field if 'DV' to 'N').                               148743
420400200529      *                                                                   138962
420500200529     C     *IN89         IFEQ      '0'                                                         13896
420600200529     C     MASTAT        IFNE      'S'                                                         13896
420700200529     C     MASTAT        ANDNE     'X'                                                         13896
420800200529     C     MASTAT        ANDNE     'C'                                                         13896
420900200529     C     WWPTYP        IFEQ      'DV'                                                        13896
421000200529     C     WWLNKR        CHAIN     SECODVL0                           89                       13896
421100200529     C     *IN89         IFEQ      '0'                                                         13896
421200200529     C                   MOVE      'N'           MDSBRT                                        13896
421300200529     C                   MOVE      *BLANKS       MDSBRS                                        13896
421400200529     C                   Z-ADD     0             MDREPR                                        13896
421500200529     C                   Z-ADD     0             MDREXD                                        13896
421600200529     C                   Z-ADD     0             MDREXA                                        13896
421700200529     C                   MOVE      *BLANKS       MDREAT                                        13896
421800200529     C                   Z-ADD     0             MDRNNS                                        13896
421900200529     C                   Z-ADD     0             MDRNRI                                        13896
422000200529     C                   Z-ADD     0             MDRMLT                                        13896
422100200529     C                   Z-ADD     0             MDRDIV                                        13896
422200200529     C                   Z-ADD     0             MDRTRF                                        13896
422300200529     C                   Z-ADD     0             MDRTRT                                        13896
422400200529     C                   Z-ADD     BJRDNB        MDLCD                                         13896
422500200529     C                   MOVE      'A'           MDCHTP                                        13896
422600200529     C                   MOVE      ##USR         MDLUID                                        13896
422700200529     C                   UPDATE    SECODVD0                                                    13896
422800200529     C                   ENDIF                                                                 13896
422900200529     C                   ELSE                                                                  13896
423000200529     C     WWPTYP        IFEQ      'RG'                                                        14874
423100200529     C     WWLNKR        CHAIN     SECORGL0                           89                       13896
423200200529     C     *IN89         IFEQ      '0'                                                         13896
423300200529     C                   MOVE      *BLANKS       MFSBRS                                        13896
423400200529     C                   Z-ADD     0             MFSBRP                                        13896
423500200529     C                   Z-ADD     0             MFREXD                                        13896
423600200529     C                   Z-ADD     0             MFREXA                                        13896
423700200529     C                   MOVE      *BLANKS       MFREAT                                        13896
423800200529     C                   Z-ADD     0             MFRNNS                                        13896
423900200529     C                   Z-ADD     0             MFRNRI                                        13896
424000200529     C                   Z-ADD     0             MFRMLT                                        13896
424100200529     C                   Z-ADD     0             MFRDIV                                        13896
424200200529     C                   Z-ADD     0             MFRTRF                                        13896
424300200529     C                   Z-ADD     0             MFRTRT                                        13896
424400200529     C                   MOVE      *BLANKS       MFAVOP                                        13896
424500200529     C                   Z-ADD     BJRDNB        MFLCD                                         13896
424600200529     C                   MOVE      'A'           MFCHTP                                        13896
424700200529     C                   MOVE      ##USR         MFLUID                                        13896
424800200529     C                   UPDATE    SECORGD0                                                    13896
424900200529     C                   ENDIF                                                                 13896
425000200529     C                   ELSE                                                                  14874
425100200529     C     WWLNKR        CHAIN     SECOFRL0                           89                       14874
425200200529     C     *IN89         IFEQ      '0'                                                         14874
425300200529     C                   MOVE      'N'           MESBRT                                        14874
425400200529     C                   MOVE      *BLANKS       MESBRS                                        14874
425500200529     C                   Z-ADD     0             MEREPR                                        14874
425600200529     C                   Z-ADD     0             MEREXD                                        14874
425700200529     C                   Z-ADD     0             MEREXA                                        14874
425800200529     C                   MOVE      *BLANKS       MEREAT                                        14874
425900200529     C                   Z-ADD     0             MERNNS                                        14874
426000200529     C                   Z-ADD     0             MERNRI                                        14874
426100200529     C                   Z-ADD     0             MERMLT                                        14874
426200200529     C                   Z-ADD     0             MERDIV                                        14874
426300200529     C                   Z-ADD     0             MERTRF                                        14874
426400200529     C                   Z-ADD     0             MERTRT                                        14874
426500200529     C                   Z-ADD     BJRDNB        MELCD                                         14874
426600200529     C                   MOVE      'A'           MECHTP                                        14874
426700200529     C                   MOVE      ##USR         MELUID                                        14874
426800200529     C                   UPDATE    SECOFRD0                                                    14874
426900200529     C                   ENDIF                                                                 14874
427000200529     C                   ENDIF                                                                 14874
427100200529     C                   ENDIF                                                                 13896
427200200529     C                   ENDIF                                                                 13896
427300200529     C                   ENDIF                                                                 13896
427400200529     C                   ENDIF                                                                 13896
427500200529     C/COPY WNCPYSRC,SE7502C005
427600200529      *
427700200529      **   COMMITMENT INSTRUCTION
427800200529      *
427900200529     C                   COMMIT
428000200529      *
428100200529     C                   MOVE      *BLANKS       #1SEL
428200200529     C***********        MOVE      '0'           *IN45                                        CSE020
428300200529     C                   MOVE      '0'           WIN45                                        CSE020
428400200529     C                   ENDIF                                                  E*1
428500200529      *
428600200529      **   IF 'ACTION' IS AUTHORISATION (PROCESSING TYPE 'NC')
428700200529      *
428800200529     C     #1SEL         IFEQ      'N'                                          B*1
428900200529      *
429000200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
429100200529      *
429200200529     C     #1REFN        CHAIN     SECORFL0                           88
429300200529      *
429400200529     C                   MOVE      'D'           MARECI
429500200529     C                   Z-ADD     BJRDNB        MALCD
429600200529     C                   MOVE      'A'           MACHTP
429700200529     C                   MOVE      ##USR         MALUID
429800200529     C                   MOVE      'X'           MASTAT
429900200529     C                   UPDATE    SECORFD0
430000200529      *
430100200529      **   UPDATE SUBFILE FIELDS
430200200529      *
430300200529     C                   MOVE      FIELD         #FIELD
430400200529     C                   MOVE      *BLANKS       #1SEL
430500200529     C                   MOVE      'X'           #1GSTS
430600200529      *
430700200529      **   COMMITMENT INSTRUCTION
430800200529      *
430900200529     C                   COMMIT
431000200529     C                   ENDIF                                                  E*1
431100200529      *
431200200529      **   IF 'ACTION' IS CUSTOMER REPLY HANDLE
431300200529      *
431400200529     C     #1SEL         IFEQ      'Y'                                          B*1
431500200529      *
431600200529     C                   MOVE      *BLANKS       WRTCD
431700200529      *
431800200529     C                   MOVE      #1EXDT        ZDATE
431900200529     C                   EXSR      ZDATE1
432000200529     C                   MOVE      ZDAYNO        WEXDAT
432100200529      *
432200200529     C                   CALL      'SE7514'                             99
432300200529     C                   PARM                    #1REFN                         ER Reference
432400200529     C                   PARM                    #1SECN                         Security Shortname
432500200529     C                   PARM                    #1COAT                         Corporate Action Typ
432600200529     C                   PARM                    #1STAT                         Corporate Action Sta
432700200529     C                   PARM                    #1PTYP                         Processing Type
432800200529     C                   PARM                    WEXDAT            5            Ex-Date
432900200529     C                   PARM                    NMCY              3            Nominal Currency
433000200529     C                   PARM                    WRTCD             1            Return Code
433100200529      *
433200200529      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
433300200529      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
433400200529      **         DATABASE ERROR
433500200529      *
433600200529     C     *IN99         IFEQ      '1'                                          B*2
433700200529     C     WRTCD         OREQ      'E'
433800200529     C                   MOVEL     '006'         DBASE             3 0          *****************
433900200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 06 **
434000200529     C                   MOVEL     NARR(6)       DBKEY            29            *****************
434100200529     C                   EXSR      *PSSR
434200200529     C                   ENDIF                                                  E*2
434300200529      *
434400200529     C     WRTCD         IFNE      'M'                                          B*2
434500200529     C                   MOVE      *BLANKS       #1SEL
434600200529     C                   ENDIF                                                  E*2
434700200529      *
434800200529      **   IF RETURN CODE IS EQUAL TO '2', '3' OR 'M'
434900200529      *
435000200529     C     WRTCD         IFEQ      '2'                                          B*2
435100200529     C     WRTCD         OREQ      '3'
435200200529     C     WRTCD         OREQ      'M'
435300200529      *
435400200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
435500200529      *
435600200529     C     #1REFN        CHAIN     SECORFL0                           88
435700200529      *
435800200529     C                   MOVE      *BLANKS       MAJOBN
435900200529     C                   MOVE      *BLANKS       MAUSER
436000200529     C                   Z-ADD     *ZEROS        MAJNBR
436100200529      *
436200200529     C                   UPDATE    SECORFD0
436300200529      *
436400200529      **   UPDATE SUBFILE FIELDS
436500200529      *
436600200529     C                   MOVE      FIELD         #FIELD
436700200529      *
436800200529      **   COMMITMENT INSTRUCTION
436900200529      *
437000200529     C                   COMMIT
437100200529      *
437200200529     C     WRTCD         IFEQ      '3'                                          B*3
437300200529     C                   MOVE      '1'           *INKC
437400200529     C                   ENDIF                                                  E*3
437500200529      *
437600200529     C                   ENDIF                                                  E*2
437700200529      *
437800200529     C                   MOVE      *BLANKS       #1SEL
437900200529      *
438000200529     C                   ENDIF                                                  E*1
438100200529      *
438200200529      **   IF 'ACTION' IS VIEW CUSTOMER ALLOCATIONS
438300200529      *
438400200529     C     #1SEL         IFEQ      'V'                                          B*1
438500200529      *
438600200529     C                   MOVE      *BLANKS       WRTCD
438700200529     C     *LOCK         IN        LDA
438800200529     C                   MOVEL     'SE7502'      PGMNAM
438900200529     C                   OUT       LDA
439000200529      *
439100200529     C                   CALL      'SE7540'                             99
439200200529     C                   PARM                    #1REFN                         ER Reference
439300200529     C                   PARM      *BLANKS       WWOPTN            2            Option number
439400200529     C                   PARM      *BLANKS       WWBRCD            3            Branch Code
439500200529     C                   PARM      *BLANKS       WWBOOK            2            Book
439600200529     C                   PARM      *BLANKS       WWCUST            6            Customer
439700200529     C                   PARM      *BLANKS       WWPTFR            4            Portfolio
439800200529     C                   PARM      *BLANKS       WWCPGM            6            Calling Pgm
439900200529     C                   PARM                    WRTCD             1            Return Code
440000200529      *
440100200529     C     *LOCK         IN        LDA
440200200529     C                   MOVEL     *BLANKS       PGMNAM
440300200529     C                   OUT       LDA
440400200529      *
440500200529      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
440600200529      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
440700200529      **         DATABASE ERROR
440800200529      *
440900200529     C     *IN99         IFEQ      '1'                                          B*2
441000200529     C     WRTCD         OREQ      'E'
441100200529     C                   MOVEL     '007'         DBASE             3 0          *****************
441200200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 07 **
441300200529     C                   MOVEL     NARR(9)       DBKEY            29            *****************
441400200529     C                   EXSR      *PSSR
441500200529     C                   ENDIF                                                  E*2
441600200529      *
441700200529     C     WRTCD         IFNE      'M'                                          B*2
441800200529     C                   MOVE      *BLANKS       #1SEL
441900200529     C                   ENDIF                                                  E*2
442000200529      *
442100200529      **   IF RETURN CODE IS EQUAL TO '2', '3' OR 'M'
442200200529      *
442300200529     C     WRTCD         IFEQ      '2'                                          B*2
442400200529     C     WRTCD         OREQ      '3'
442500200529     C     WRTCD         OREQ      'M'
442600200529      *
442700200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
442800200529      *
442900200529     C     #1REFN        CHAIN     SECORFL0                           88
443000200529      *
443100200529     C                   MOVE      *BLANKS       MAJOBN
443200200529     C                   MOVE      *BLANKS       MAUSER
443300200529     C                   Z-ADD     *ZEROS        MAJNBR
443400200529      *
443500200529     C                   UPDATE    SECORFD0
443600200529      *
443700200529      **   UPDATE SUBFILE FIELDS
443800200529      *
443900200529     C                   MOVE      FIELD         #FIELD
444000200529      *
444100200529      **   COMMITMENT INSTRUCTION
444200200529      *
444300200529     C                   COMMIT
444400200529      *
444500200529     C     WRTCD         IFEQ      '3'                                          B*3
444600200529     C                   MOVE      '1'           *INKC
444700200529     C                   ENDIF                                                  E*3
444800200529     C                   ENDIF                                                  E*2
444900200529      *
445000200529     C                   ENDIF                                                  E*1
445100200529      *
445200200529      **   IF 'ACTION' IS PRINT CORRESPONDENCE, *** FUTURE USE, PHASE II ***
445300200529      *
445400200529     C     #1SEL         IFEQ      'C'                                          B*1
445500200529      *
445600200529     C                   MOVE      'Y'           ERMSG
445700200529     C                   MOVE      '1'           *IN62                          Reverse image
445800200529     C                   MOVEL     'CO00258'     ZAMSID
445900200529     C                   EXSR      ZASNMS
446000200529      *
446100200529      **   ACCESS CORPORATE ACTION REFERENCE WITH CURRENT REFERENCE
446200200529      *
446300200529     C     #1REFN        CHAIN     SECORFL0                           88
446400200529      *
446500200529     C                   MOVE      *BLANKS       MAJOBN
446600200529     C                   MOVE      *BLANKS       MAUSER
446700200529     C                   Z-ADD     *ZEROS        MAJNBR
446800200529      *
446900200529     C                   UPDATE    SECORFD0
447000200529      *
447100200529      **   UPDATE SUBFILE FIELDS
447200200529      *
447300200529     C                   MOVE      FIELD         #FIELD
447400200529      *
447500200529      **   COMMITMENT INSTRUCTION
447600200529      *
447700200529     C                   COMMIT
447800200529      *
447900200529     C                   ENDIF                                                  E*1
448000200529      *
448100200529     C     TAG3          ENDSR
448200200529      *****************************************************************
448300200529      /EJECT
448400200529      *****************************************************************
448500200529      * P010   : PROCESS 'CONFIRMATION' SCREEN                        *
448600200529      *****************************************************************
448700200529      *
448800200529     C     P010          BEGSR
448900200529      *
449000200529     C                   MOVE      *BLANKS       #1CONF
449100200529      *
449200200529     C                   MOVE      '0'           *IN40
449300200529     C                   MOVE      '0'           *IN41
449400200529      *
449500200529     C                   MOVE      '0'           *IN44
449600200529     C                   MOVE      '1'           *IN47
449700200529      *                                                                   138962
449800200529      ***  If Delete or Reverse of a Corporate Action type Exercises and  138962
449900200529      ***  Conversions, check if there is a linked Corporate Action.      138962
450000200529      *                                                                   138962
450100200529     C                   MOVE      *BLANKS       REFLIN                                        13896
450200200529     C     #1PTYP        IFEQ      'EX'                                                        13896
450300200529     C     #1SEL         ANDEQ     'D'                                                         13896
450400200529     C     #1PTYP        OREQ      'EX'                                                        13896
450500200529     C     #1SEL         ANDEQ     'R'                                                         13896
450600200529     C     #1REFN        CHAIN(N)  SECOEXL0                           89                       13896
450700200529     C     MJLNKR        IFNE      *BLANKS                                                     13896
450800200529     C     MJLNKR        CHAIN(N)  SECODVL0                           89                       13896
450900200529     C     *IN89         IFEQ      '0'                                                         13896
451000200529     C                   MOVE      MJLNKR        WWLNKR                                        13896
451100200529     C                   MOVE      'DV'          WWPTYP                                        13896
451200200529     C                   ELSE                                                                  13896
451300200529     C     MJLNKR        CHAIN(N)  SECORGL0                           89                       13896
451400200529     C     *IN89         IFEQ      '0'                                                         13896
451500200529     C                   MOVE      MJLNKR        WWLNKR                                        13896
451600200529     C                   MOVE      'RG'          WWPTYP                                        13896
451700200529     C                   ELSE                                                                  14874
451800200529     C     MJLNKR        CHAIN(N)  SECOFRL0                           89                       14874
451900200529     C     *IN89         IFEQ      '0'                                                         14874
452000200529     C                   MOVE      MJLNKR        WWLNKR                                        14874
452100200529     C                   MOVE      'FR'          WWPTYP                                        14874
452200200529     C                   ENDIF                                                                 14874
452300200529     C                   ENDIF                                                                 13896
452400200529     C                   ENDIF                                                                 13896
452500200529     C                   ENDIF                                                                 13896
452600200529     C                   ENDIF                                                                 13896
452700200529      *
452800200529      **   DEPENDING OF THE 'ACTION', SET THE CORRECT NARRATIVE
452900200529      **   *** CONFIRM REVERSAL ***
453000200529      *
453100200529     C     #1SEL         IFEQ      'R'                                          B*1
453200200529     C                   MOVE      '1'           *IN40
453300200529     C                   MOVE      '0'           *IN41
453400200529     C                   ELSE                                                   X*1
453500200529      *
453600200529      **   *** CONFIRM DELETION ***
453700200529      *
453800200529     C     #1SEL         IFEQ      'D'                                          B*2
453900200529     C                   MOVE      '0'           *IN40
454000200529     C                   MOVE      '0'           *IN41
454100200529     C                   ELSE                                                   X*2
454200200529      *
454300200529      **   *** CONFIRM AUTHORISATION ***
454400200529      *
454500200529     C     #1SEL         IFEQ      'N'                                          B*3
454600200529     C                   MOVE      '0'           *IN40
454700200529     C                   MOVE      '1'           *IN41
454800200529     C                   ENDIF                                                  E*3
454900200529     C                   ENDIF                                                  E*2
455000200529     C                   ENDIF                                                  E*1
455100200529      *
455200200529     C******     *IN61     IFEQ '1'                        B*1            138962
455300200529     C******               MOVEATXT,4     ##CTX1                          138962
455400200529     C******               ELSE                            X*1            138962
455500200529     C******               MOVEATXT,5     ##CTX1                          138962
455600200529     C******               ENDIF                           E*1            138962
455700200529     C                   MOVEA     TXT(6)        ##CTX1                                        13896
455800200529      *
455900200529      **   DO WHILE F3 OR F12 NOT PRESSED AND NO ERROR
456000200529      *
456100200529     C     *INKC         DOWEQ     '0'                                          B*1
456200200529     C     *INKL         ANDEQ     '0'
456300200529     C     #1CONF        ANDNE     'Y'
456400200529     C     #1CONF        ANDNE     'N'
456500200529      *
456600200529      **   SETUP SCREEN TIME
456700200529      *
456800200529     C                   TIME                    ##TME                          Screen time.
456900200529      *                                                                   138962
457000200529      ***  If Delete or Reverse CO type 'EX' linked with CO type 'DV' or  138962
457100200529      ***  'RG' or 'FR', send warning message.                            148743
457200200529      *****'RG',*send*warning*message.**************************** 138962 148743
457300200529      *                                                                   138962
457400200529     C     #1SEL         IFEQ      'D'                                                         13896
457500200529     C     WWLNKR        ANDNE     *BLANKS                                                     13896
457600200529     C     #1SEL         OREQ      'R'                                                         13896
457700200529     C     WWLNKR        ANDNE     *BLANKS                                                     13896
457800200529     C                   MOVEL(P)  REFLIN        ZAMSDA                                        13896
457900200529     C                   MOVEL     'CO00600'     ZAMSID                         Message id.    13896
458000200529     C                   EXSR      ZASNMS                                       Send message   13896
458100200529     C                   ENDIF                                                                 13896
458200200529      *
458300200529      **   EXECUTE SCREEN FORMAT
458400200529      *
458500200529     C                   WRITE     #MSGCTL
458600200529     C                   WRITE     SE7502F1
458700200529     C                   EXFMT     SE7502F2
458800200529      *
458900200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
459000200529      *
459100200529     C                   CALL      'Y2CLMSC'
459200200529     C                   PARM      ##PGM         ZAPGM            10
459300200529     C                   PARM      '*SAME'       ZAPGRL            5
459400200529      *
459500200529      **   IF 'CONFIRMATION INDICATOR' IS NOT EQUAL TO 'Y' OR 'N'
459600200529      *
459700200529     C     #1CONF        IFNE      'N'                                          B*2
459800200529     C     #1CONF        ANDNE     'Y'
459900200529     C                   MOVE      '1'           *IN44                          Reverse image
460000200529     C                   MOVEL     'CO00032'     ZAMSID                         Message id.
460100200529     C                   EXSR      ZASNMS                                       Send message
460200200529     C                   ELSE                                                   X*2
460300200529     C                   MOVE      '0'           *IN44                          Reverse image
460400200529     C                   ENDIF                                                  E*2
460500200529     C                   ENDDO                                                  E*1
460600200529      *
460700200529     C                   MOVEA     TXT(3)        ##CTX1
460800200529     C                   MOVE      '0'           *IN47
460900200529      *
461000200529     C                   ENDSR
461100200529      *****************************************************************
461200200529      /EJECT
461300200529      *****************************************************************
461400200529      * P011   : WRITE OPTION(S) WITH DEFAULT INFORMATION             *
461500200529      *****************************************************************
461600200529      *
461700200529     C     P011          BEGSR
461800200529      *
461900200529     C                   MOVEL     NARR(4)       WWOPSH           26
462000200529     C                   MOVE      WWOPNB        WWOPSH
462100200529      *
462200200529     C     MAPTYP        IFEQ      'DV'                                         B*1
462300200529     C                   CLEAR                   SECODVD0
462400200529     C                   MOVE      'D'           MDRECI
462500200529     C                   Z-ADD     BJRDNB        MDLCD
462600200529     C                   MOVE      'I'           MDCHTP
462700200529     C                   MOVE      ##USR         MDLUID
462800200529     C                   MOVE      #1REFN        MDCORF
462900200529     C                   Z-ADD     WWOPNB        MDOPTN
463000200529     C                   MOVE      #1SECN        MDNSEC
463100200529     C                   MOVE      'D'           MDRNDN
463200200529     C                   MOVE      'N'           MDRNDS
463300200529     C                   MOVE      'N'           MDSBRT
463400200529     C                   MOVEL     WWOPSH        MDOPSH
463500200529     C                   WRITE     SECODVD0
463600200529     C                   ELSE                                                   X*1
463700200529     C     MAPTYP        IFEQ      'FR'                                         B*2
463800200529     C                   CLEAR                   SECOFRD0
463900200529     C                   MOVE      'D'           MERECI
464000200529     C                   Z-ADD     BJRDNB        MELCD
464100200529     C                   MOVE      'I'           MECHTP
464200200529     C                   MOVE      ##USR         MELUID
464300200529     C                   MOVE      #1REFN        MECORF
464400200529     C                   Z-ADD     WWOPNB        MEOPTN
464500200529     C                   MOVE      #1SECN        MENSEC
464600200529     C                   MOVE      'D'           MERNDN
464700200529     C                   MOVE      'N'           MERNDS
464800200529     C                   MOVEL     WWOPSH        MEOPSH
464900200529     C                   WRITE     SECOFRD0
465000200529     C                   ELSE                                                   X*2
465100200529     C     MAPTYP        IFEQ      'CE'                                         B*3
465200200529     C                   CLEAR                   SECOCED0
465300200529     C                   MOVE      'D'           MGRECI
465400200529     C                   Z-ADD     BJRDNB        MGLCD
465500200529     C                   MOVE      'I'           MGCHTP
465600200529     C                   MOVE      ##USR         MGLUID
465700200529     C                   MOVE      #1REFN        MGCORF
465800200529     C                   Z-ADD     WWOPNB        MGOPTN
465900200529     C                   MOVEL     WWOPSH        MGOPSH
466000200529     C                   WRITE     SECOCED0
466100200529     C                   ELSE                                                   X*3
466200200529     C     MAPTYP        IFEQ      'CR'                                         B*4
466300200529     C                   CLEAR                   SECOCRD0
466400200529     C                   MOVE      'D'           MHRECI
466500200529     C                   Z-ADD     BJRDNB        MHLCD
466600200529     C                   MOVE      'I'           MHCHTP
466700200529     C                   MOVE      ##USR         MHLUID
466800200529     C                   MOVE      #1REFN        MHCORF
466900200529     C                   Z-ADD     WWOPNB        MHOPTN
467000200529     C                   MOVEL     WWOPSH        MHOPSH
467100200529     C                   WRITE     SECOCRD0
467200200529     C                   ELSE                                                   X*4
467300200529     C     MAPTYP        IFEQ      'OF'                                         B*5
467400200529     C                   CLEAR                   SECOOFD0
467500200529     C                   MOVE      'D'           MIRECI
467600200529     C                   Z-ADD     BJRDNB        MILCD
467700200529     C                   MOVE      'I'           MICHTP
467800200529     C                   MOVE      ##USR         MILUID
467900200529     C                   MOVE      #1REFN        MICORF
468000200529     C                   MOVE      'D'           MIRNDN
468100200529     C                   MOVE      'N'           MIRNDS
468200200529     C                   Z-ADD     WWOPNB        MIOPTN
468300200529     C                   MOVEL     WWOPSH        MIOPSH
468400200529     C                   WRITE     SECOOFD0
468500200529     C                   ELSE                                                   X*5
468600200529     C     MAPTYP        IFEQ      'RG'                                         B*6
468700200529     C                   CLEAR                   SECORGD0
468800200529     C                   MOVE      'D'           MFRECI
468900200529     C                   Z-ADD     BJRDNB        MFLCD
469000200529     C                   MOVE      'I'           MFCHTP
469100200529     C                   MOVE      ##USR         MFLUID
469200200529     C                   MOVE      #1REFN        MFCORF
469300200529     C                   Z-ADD     WWOPNB        MFOPTN
469400200529     C                   MOVE      #1SECN        MFNSEC
469500200529     C                   MOVE      'D'           MFRNDN
469600200529     C                   MOVE      'N'           MFRNDS
469700200529     C                   MOVEL     WWOPSH        MFOPSH
469800200529     C                   WRITE     SECORGD0
469900200529     C                   ELSE                                                   X*6
470000200529     C     MAPTYP        IFEQ      'EX'                                         B*7
470100200529     C                   CLEAR                   SECOEXD0
470200200529     C                   MOVE      'D'           MJRECI
470300200529     C                   Z-ADD     BJRDNB        MJLCD
470400200529     C                   MOVE      'I'           MJCHTP
470500200529     C                   MOVE      ##USR         MJLUID
470600200529     C                   MOVE      #1REFN        MJCORF
470700200529     C                   Z-ADD     WWOPNB        MJOPTN
470800200529     C                   MOVE      'D'           MJRNDN
470900200529     C                   MOVE      'N'           MJRNDS
471000200529     C                   MOVE      'N'           MJOPT1
471100200529     C                   MOVE      'N'           MJOPT2
471200200529     C                   MOVE      'N'           MJOPT3
471300200529     C                   MOVE      'N'           MJOPT4
471400200529     C                   MOVE      'N'           MJOPT5
471500200529     C                   MOVE      'N'           MJOPT6
471600200529     C                   MOVE      'N'           MJOPT7
471700200529     C                   MOVEL     WWOPSH        MJOPSH
471800200529     C                   WRITE     SECOEXD0
471900200529     C                   ELSE                                                   X*7
472000200529     C     MAPTYP        IFEQ      'NF'                                         B*8
472100200529     C                   CLEAR                   SECONFD0
472200200529     C                   MOVE      'D'           MKRECI
472300200529     C                   Z-ADD     BJRDNB        MKLCD
472400200529     C                   MOVE      'I'           MKCHTP
472500200529     C                   MOVE      ##USR         MKLUID
472600200529     C                   MOVE      #1REFN        MKCORF
472700200529     C                   Z-ADD     1             MKSEQN
472800200529     C                   WRITE     SECONFD0
472900200529     C                   ELSE                                                   X*8
473000200529     C     MAPTYP        IFEQ      'NC'                                         B*9
473100200529     C                   CLEAR                   SECONCD0
473200200529     C                   MOVE      'D'           MLRECI
473300200529     C                   Z-ADD     BJRDNB        MLLCD
473400200529     C                   MOVE      'I'           MLCHTP
473500200529     C                   MOVE      ##USR         MLLUID
473600200529     C                   MOVE      #1REFN        MLCORF
473700200529     C                   WRITE     SECONCD0
473800200529     C                   ELSE                                                   X*9            CEU01
473900200529     C     MAPTYP        IFEQ      'CC'                                         B*10           CEU01
474000200529     C                   CLEAR                   SECOCCD0                                      CEU01
474100200529     C                   MOVE      'D'           NARECI                                        CEU01
474200200529     C                   Z-ADD     BJRDNB        NALCD                                         CEU01
474300200529     C                   MOVE      'I'           NACHTP                                        CEU01
474400200529     C                   MOVE      ##USR         NALUID                                        CEU01
474500200529     C                   MOVE      #1REFN        NACORF                                        CEU01
474600200529     C                   WRITE     SECOCCD0                                                    CEU01
474700200529     C/COPY WNCPYSRC,SE7502C038
474800200529     C                   ENDIF                                                  E*10           CEU01
474900200529     C                   ENDIF                                                  E*9
475000200529     C                   ENDIF                                                  E*8
475100200529     C                   ENDIF                                                  E*7
475200200529     C                   ENDIF                                                  E*6
475300200529     C                   ENDIF                                                  E*5
475400200529     C                   ENDIF                                                  E*4
475500200529     C                   ENDIF                                                  E*3
475600200529     C                   ENDIF                                                  E*2
475700200529     C                   ENDIF                                                  E*1
475800200529      *
475900200529     C                   ENDSR
476000200529      *****************************************************************
476100200529      /EJECT
476200200529      *****************************************************************
476300200529      * P014   : REINITIALISE INDICATORS                              *
476400200529      *****************************************************************
476500200529      *
476600200529     C     P014          BEGSR
476700200529      *
476800200529      **   REINITIALISE INDICATORS
476900200529      *
477000200529     C                   MOVE      '0'           *IN28                          Error on Allocation
477100200529     C                   MOVE      '0'           *IN29                          Error on Number Opti
477200200529     C                   MOVE      '0'           *IN32                          Error on Ex-Date
477300200529     C                   MOVE      '0'           *IN33                          Error on Action Type
477400200529     C                   MOVE      '0'           *IN34                          Error on Status
477500200529     C                   MOVE      '0'           *IN37                          Error on Date Announ
477600200529     C                   MOVE      '0'           *IN38                          Error on Reference
477700200529     C                   MOVE      '0'           *IN39                          Error on Shortname
477800200529     C                   MOVE      '0'           *IN62                          Error on Action
477900200529      *
478000200529     C                   ENDSR
478100200529      *****************************************************************
478200200529      /EJECT
478300200529      *****************************************************************
478400200529      * P015   : CLEAR SFL FIELDS                                     *
478500200529      *****************************************************************
478600200529      *
478700200529     C     P015          BEGSR
478800200529      *
478900200529      **   INITIALISE SUBFILE RECORD
479000200529      *
479100200529     C                   MOVE      *BLANKS       #1SEL
479200200529     C                   MOVE      *BLANKS       #1REFN
479300200529     C                   MOVE      *BLANKS       #1LEVL                                       CSE020
479400200529     C                   MOVE      *BLANKS       #1SECN
479500200529     C                   MOVE      *BLANKS       #1COAT
479600200529     C                   MOVE      *BLANKS       #1COAN
479700200529     C                   MOVE      *BLANKS       #1EXDT
479800200529     C                   MOVE      *BLANKS       #1ALEF
479900200529     C                   MOVE      *BLANKS       #1NBOP
480000200529     C                   MOVE      *BLANKS       #1GSTS
480100200529      *
480200200529      **   INITIALISE HIDDEN SUBFILE FIELDS
480300200529      *
480400200529     C                   MOVE      *BLANKS       #FIELD
480500200529     C                   MOVE      *BLANKS       #1PTYP
480600200529     C                   MOVE      *BLANKS       #1TDVD
480700200529      *
480800200529     C                   MOVE      *BLANKS       #2SEL
480900200529     C                   MOVE      *BLANKS       #2COAN
481000200529     C                   MOVE      *BLANKS       #2EXDT
481100200529     C                   MOVE      *BLANKS       #2ALEF
481200200529     C                   MOVE      *BLANKS       #1MPRF                                       CSE020
481300200529      *
481400200529     C                   ENDSR
481500200529      ********************************************************************
481600200529      /EJECT
481700200529      *****************************************************************
481800200529      * P016  : LOAD SFL FIELDS                                       *
481900200529      *****************************************************************
482000200529      *
482100200529     C     P016          BEGSR
482200200529      *
482300200529      **   INITIALISE SUBFILE RECORD
482400200529      *
482500200529     C                   MOVE      *BLANKS       #1SEL
482600200529     C                   MOVE      MACORF        #1REFN
482700200529     C                   MOVE      MALEVL        #1LEVL                                       CSE020
482800200529     C                   MOVE      MASESN        #1SECN
482900200529     C                   MOVE      MACOAT        #1COAT
483000200529     C                   MOVE      MAPTYP        #1PTYP
483100200529     C                   MOVE      MATDVD        #1TDVD
483200200529     C     CSE020        IFEQ      'Y'                                                        CSE020
483300200529     C                   MOVE      MAPREF        #1MPRF                                       CSE020
483400200529     C                   ENDIF                                                                CSE020
483500200529      *
483600200529     C     MACOAN        IFNE      *ZEROS
483700200529     C                   Z-ADD     MACOAN        ZDAYNO
483800200529     C                   EXSR      ZDATE2
483900200529     C                   MOVE      ZDATE         #1COAN
484000200529     C                   ELSE
484100200529     C                   MOVE      *BLANKS       #1COAN
484200200529     C                   ENDIF
484300200529      *
484400200529     C     MACOEX        IFNE      *ZEROS
484500200529     C                   Z-ADD     MACOEX        ZDAYNO
484600200529     C                   EXSR      ZDATE2
484700200529     C                   MOVE      ZDATE         #1EXDT
484800200529     C                   ELSE
484900200529     C                   MOVE      *BLANKS       #1EXDT
485000200529     C                   ENDIF
485100200529      *
485200200529     C     MAALEF        IFNE      *ZEROS
485300200529     C                   Z-ADD     MAALEF        ZDAYNO
485400200529     C                   EXSR      ZDATE2
485500200529     C                   MOVE      ZDATE         #1ALEF
485600200529     C                   ELSE
485700200529     C                   MOVE      *BLANKS       #1ALEF
485800200529     C                   ENDIF
485900200529      *
486000200529     C                   MOVE      MANBOP        #1NBOP
486100200529     C                   MOVE      MASTAT        #1GSTS
486200200529      *                                                                                       CSE016
486300200529     C                   MOVE      *BLANKS       #1SRNM                                       CSE016
486400200529      *                                                                                       CSE016
486500200529      ** Retrieve security description                                                        CSE016
486600200529      *                                                                                       CSE016
486700200529     C     #1SECN        CHAIN     SECTYZ1                            89                      CSE016
486800200529     C     *IN89         IFEQ      *OFF                                                       CSE016
486900200529      *                                                                                       CSE016
487000200529      ** Format security report description                                                   CSE016
487100200529      *                                                                                       CSE016
487200200529     C     #1SECN        IFNE      *BLANKS                                                    CSE016
487300200529      *                                                                                       CSE016
487400200529     C                   CALLB     'ZSDESC'                                                   CSE016
487500200529     C                   PARM      SRPN          PSRPN                                        CSE016
487600200529     C                   PARM                    PSFN1                                        CSE016
487700200529     C                   PARM                    PSFN2                                        CSE016
487800200529     C                   PARM                    CPNR                                         CSE016
487900200529     C                   PARM                    MATY                                         CSE016
488000200529     C                   PARM                    SCPP                                         CSE016
488100200529     C                   PARM                    SCPD                                         CSE016
488200200529     C                   PARM      BVRIDF        PRSFD                                        CSE016
488300200529     C                   PARM                    SCPI                                         CSE016
488400200529     C                   PARM                    PRNME                                        CSE016
488500200529     C                   PARM                    PFNM1                                        CSE016
488600200529     C                   PARM                    PFNM2                                        CSE016
488700200529     C                   PARM                    PFNM3                                        CSE016
488800200529      *                                                                                       CSE016
488900200529     C                   EVAL      #1SRNM = PRNME                                             CSE016
489000200529      *                                                                                       CSE016
489100200529     C                   ENDIF                                                                CSE016
489200200529      *                                                                                       CSE016
489300200529     C                   ENDIF                                                                CSE016
489400200529      *
489500200529      **   INITIALISE HIDDEN SUBFILE FIELDS
489600200529      *
489700200529     C                   MOVE      MAJOBN        WAJOBN           10
489800200529     C                   MOVE      MAUSER        WAUSER           10
489900200529     C                   Z-ADD     MAJNBR        WAJNBR            6 0
490000200529     C                   MOVE      *BLANKS       MAJOBN
490100200529     C                   MOVE      *BLANKS       MAUSER
490200200529     C                   Z-ADD     *ZEROS        MAJNBR
490300200529     C                   MOVE      FIELD         #FIELD
490400200529     C                   MOVE      WAJOBN        MAJOBN
490500200529     C                   MOVE      WAUSER        MAUSER
490600200529     C                   Z-ADD     WAJNBR        MAJNBR
490700200529     C                   MOVE      *BLANKS       #2SEL
490800200529     C                   MOVE      #1COAN        #2COAN
490900200529     C                   MOVE      #1EXDT        #2EXDT
491000200529     C                   MOVE      #1ALEF        #2ALEF
491100200529      *
491200200529     C                   ENDSR
491300200529      ********************************************************************
491400200529      /EJECT
491500200529      *****************************************************************
491600200529      * P017  : REINITIALISE POSITION/SELECTION FIELDS                *
491700200529      *****************************************************************
491800200529      *
491900200529     C     P017          BEGSR
492000200529      *
492100200529     C                   MOVE      *BLANKS       #REFN
492200200529     C                   MOVE      *BLANKS       #SECN
492300200529     C                   MOVE      *BLANKS       #EXDT
492400200529     C                   MOVE      *BLANKS       #COAT
492500200529     C                   MOVE      *BLANKS       #STAT
492600200529      *
492700200529     C                   MOVE      *BLANKS       #3REFN
492800200529     C                   MOVE      *BLANKS       #3SECN
492900200529     C                   MOVE      *BLANKS       #3EXDT
493000200529     C                   MOVE      *BLANKS       #3STAT
493100200529     C                   MOVE      *BLANKS       #3COAT
493200200529      *
493300200529     C                   MOVE      '0'           *IN50
493400200529     C                   MOVE      '0'           *IN51
493500200529     C                   MOVE      '0'           *IN52
493600200529     C                   MOVE      '0'           *IN86
493700200529     C                   MOVE      '0'           *IN69
493800200529      *
493900200529     C                   ENDSR
494000200529      ****************************************************************
494100200529      /EJECT
494200200529      *****************************************************************
494300200529      * P018  : PROCESS 'FULL DETAILS' SCREEN                         *
494400200529      *****************************************************************
494500200529      *
494600200529     C     P018          BEGSR
494700200529      *
494800200529      **   SETUP THE DISPLAY FIELDS
494900200529      *                                                                   136420
495000200529     C                   MOVE      *BLANKS       #1BLKR                                        13642
495100200529     C     MAPTYP        IFEQ      'CC'                                                        13642
495200200529     C     #1REFN        CHAIN     SECOCCL0                           89                       13642
495300200529      *                                                                   136420
495400200529     C     *IN89         IFEQ      '0'                                                         13642
495500200529     C     NABLKR        ANDNE     *ZEROS                                                      13642
495600200529     C                   MOVE      NABLKR        #1BLKR                                        13642
495700200529     C                   ENDIF                                                                 13642
495800200529      *                                                                                       CSE020
495900200529      ** Display Parent reference field if MAPREF is not blanks                               CSE020
496000200529      *                                                                                       CSE020
496100200529     C     CSE020        IFEQ      'Y'                                                        CSE020
496200200529     C     MAPREF        ANDNE     *BLANKS                                                    CSE020
496300200529     C                   MOVE      MAPREF        #1PREF                                       CSE020
496400200529     C                   MOVE      '1'           *IN53                                        CSE020
496500200529     C                   ELSE                                                                 CSE020
496600200529     C                   MOVE      '0'           *IN53                                        CSE020
496700200529     C                   ENDIF                                                                CSE020
496800200529      *                                                                   136420
496900200529     C                   ENDIF                                                                 13642
497000200529      *
497100200529     C                   MOVE      MATDVD        #1TDVD
497200200529      *
497300200529     C     MACOPD        IFNE      *ZEROS                                       B*1
497400200529     C                   Z-ADD     MACOPD        ZDAYNO
497500200529     C                   EXSR      ZDATE2
497600200529     C                   MOVE      ZDATE         #1COPD
497700200529     C                   ELSE                                                   X*1
497800200529     C                   MOVE      #1ALEF        #1COPD
497900200529     C                   ENDIF                                                  E*1
498000200529      *
498100200529     C     MATDDT        IFNE      *ZEROS                                       B*1
498200200529     C                   Z-ADD     MATDDT        ZDAYNO
498300200529     C                   EXSR      ZDATE2
498400200529     C                   MOVE      ZDATE         #1TDDT
498500200529     C                   ELSE                                                   X*1
498600200529     C                   MOVE      #1ALEF        #1TDDT
498700200529     C                   ENDIF                                                  E*1
498800200529      *
498900200529     C     MAEVDT        IFNE      *ZEROS                                       B*1
499000200529     C                   Z-ADD     MAEVDT        ZDAYNO
499100200529     C                   EXSR      ZDATE2
499200200529     C                   MOVE      ZDATE         #1EVDT
499300200529     C                   ELSE                                                   X*1
499400200529     C                   MOVE      #1EXDT        #1EVDT
499500200529     C                   ENDIF                                                  E*1
499600200529      *
499700200529     C     MACPNB        IFEQ      *ZEROS                                       B*1
499800200529     C                   MOVE      *BLANKS       #1CPNB
499900200529     C                   ELSE                                                   X*1
500000200529     C                   MOVE      MACPNB        #1CPNB
500100200529     C                   ENDIF                                                  E*1
500200200529      *
500300200529     C     MASHMD        IFNE      *ZEROS                                       B*1
500400200529     C                   Z-ADD     MASHMD        ZDAYNO
500500200529     C                   EXSR      ZDATE2
500600200529     C                   MOVE      ZDATE         #1SHMD
500700200529     C                   ELSE                                                   X*1
500800200529     C                   MOVE      *BLANKS       #1SHMD
500900200529     C                   ENDIF                                                  E*1
501000200529      *
501100200529     C                   MOVE      MALTBS        #1LTBS
501200200529      *
501300200529      **   ACCESS SECURITY DETAILS TO RETRIEVE NUMBER OF DECIMALS ON THE SECURIT
501400200529      *
501500200529     C     MASESN        CHAIN     SECTYZ1                            89
501600200529      *
501700200529     C     MAOCPV        IFNE      *ZEROS
501800200529     C                   MOVE      *BLANKS       ZFLD15
501900200529     C                   MOVE      MAOCPV        ZFLD15
502000200529     C                   Z-ADD     NMDP          ZDECS
502100200529     C                   MOVE      'L'           ZECODE
502200200529     C                   EXSR      ZSEDIT
502300200529     C                   MOVEL     *BLANKS       #1OCPV
502400200529     C                   MOVE      ZOUT21        WFLD17           17
502500200529     C                   MOVEL     WFLD17        #1OCPV
502600200529     C                   ELSE
502700200529     C                   MOVE      *BLANKS       #1OCPV
502800200529     C                   ENDIF
502900200529      *
503000200529     C     MANCPV        IFNE      *ZEROS
503100200529     C                   MOVE      *BLANKS       ZFLD15
503200200529     C                   MOVE      MANCPV        ZFLD15
503300200529     C                   Z-ADD     NMDP          ZDECS
503400200529     C                   MOVE      'L'           ZECODE
503500200529     C                   EXSR      ZSEDIT
503600200529     C                   MOVEL     *BLANKS       #1NCPV
503700200529     C                   MOVE      ZOUT21        WFLD17
503800200529     C                   MOVEL     WFLD17        #1NCPV
503900200529     C                   ELSE
504000200529     C                   MOVE      *BLANKS       #1NCPV
504100200529     C                   ENDIF
504200200529      *
504300200529     C     MAONML        IFNE      *ZEROS
504400200529     C                   MOVE      *BLANKS       ZFLD15
504500200529     C                   MOVE      MAONML        ZFLD15
504600200529     C                   Z-ADD     NMDP          ZDECS
504700200529     C                   MOVE      'L'           ZECODE
504800200529     C                   EXSR      ZSEDIT
504900200529     C                   MOVEL     *BLANKS       #1ONML
505000200529     C                   MOVE      ZOUT21        WFLD17
505100200529     C                   MOVEL     WFLD17        #1ONML
505200200529     C                   ELSE
505300200529     C                   MOVE      *BLANKS       #1ONML
505400200529     C                   ENDIF
505500200529      *
505600200529     C     MANNML        IFNE      *ZEROS
505700200529     C                   MOVE      *BLANKS       ZFLD15
505800200529     C                   MOVE      MANNML        ZFLD15
505900200529     C                   Z-ADD     NMDP          ZDECS
506000200529     C                   MOVE      'L'           ZECODE
506100200529     C                   EXSR      ZSEDIT
506200200529     C                   MOVEL     *BLANKS       #1NNML
506300200529     C                   MOVE      ZOUT21        WFLD17
506400200529     C                   MOVEL     WFLD17        #1NNML
506500200529     C                   ELSE
506600200529     C                   MOVE      *BLANKS       #1NNML
506700200529     C                   ENDIF
506800200529      *
506900200529     C     MACUPC        IFNE      *ZEROS
507000200529     C                   MOVE      *BLANKS       ZFLD15
507100200529     C                   MOVE      MACUPC        ZFLD15
507200200529     C                   Z-ADD     8             ZDECS
507300200529     C                   MOVE      'L'           ZECODE
507400200529     C                   EXSR      ZSEDIT
507500200529     C                   MOVEL     *BLANKS       #1CUPC
507600200529     C                   MOVE      ZOUT21        WFLD17
507700200529     C                   MOVEL     WFLD17        #1CUPC
507800200529     C                   ELSE
507900200529     C                   MOVE      *BLANKS       #1CUPC
508000200529     C                   ENDIF
508100200529      *
508200200529     C     MAEXPC        IFNE      *ZEROS
508300200529     C                   MOVE      *BLANKS       ZFLD15
508400200529     C                   MOVE      MAEXPC        ZFLD15
508500200529     C                   Z-ADD     8             ZDECS
508600200529     C                   MOVE      'L'           ZECODE
508700200529     C                   EXSR      ZSEDIT
508800200529     C                   MOVEL     *BLANKS       #1EXPC
508900200529     C                   MOVE      ZOUT21        WFLD17
509000200529     C                   MOVEL     WFLD17        #1EXPC
509100200529     C                   ELSE
509200200529     C                   MOVE      *BLANKS       #1EXPC
509300200529     C                   ENDIF
509400200529      *
509500200529     C     MACLRD        IFNE      *ZEROS                                       B*1
509600200529     C                   Z-ADD     MACLRD        ZDAYNO
509700200529     C                   EXSR      ZDATE2
509800200529     C                   MOVE      ZDATE         #1CLRD
509900200529     C                   ELSE                                                   X*1
510000200529     C                   MOVE      *BLANKS       #1CLRD
510100200529     C                   ENDIF                                                  E*1
510200200529      *
510300200529     C     MACLRT        IFNE      *ZEROS                                       B*1
510400200529     C                   MOVE      MACLRT        #1CLRT
510500200529     C                   ELSE                                                   X*1
510600200529     C                   MOVE      *BLANKS       #1CLRT
510700200529     C                   ENDIF                                                  E*1
510800200529      *
510900200529     C     MADLRD        IFNE      *ZEROS                                       B*1
511000200529     C                   Z-ADD     MADLRD        ZDAYNO
511100200529     C                   EXSR      ZDATE2
511200200529     C                   MOVE      ZDATE         #1DLRD
511300200529     C                   ELSE                                                   X*1
511400200529     C                   MOVE      *BLANKS       #1DLRD
511500200529     C                   ENDIF                                                  E*1
511600200529      *
511700200529     C     MADLRT        IFNE      *ZEROS                                       B*1
511800200529     C                   MOVE      MADLRT        #1DLRT
511900200529     C                   ELSE                                                   X*1
512000200529     C                   MOVE      *BLANKS       #1DLRT
512100200529     C                   ENDIF                                                  E*1
512200200529      *
512300200529     C                   MOVE      MABLOP        #1BLOP
512400200529     C                   MOVE      MABLOP        #2BLOP
512500200529     C                   MOVE      MABLOS        #1BLOS
512600200529     C                   MOVE      MABLOS        #2BLOS
512700200529      *
512800200529     C     MABFRD        IFNE      *ZEROS                                       B*1
512900200529     C                   Z-ADD     MABFRD        ZDAYNO
513000200529     C                   EXSR      ZDATE2
513100200529     C                   MOVE      ZDATE         #1BFRD
513200200529     C                   ELSE                                                   X*1
513300200529     C                   MOVE      *BLANKS       #1BFRD
513400200529     C                   ENDIF                                                  E*1
513500200529      *
513600200529     C                   MOVE      #1BFRD        #2BFRD
513700200529      *
513800200529     C     MABEND        IFNE      *ZEROS                                       B*1
513900200529     C     MABEND        ANDNE     *HIVAL                                                      13693
514000200529     C                   Z-ADD     MABEND        ZDAYNO
514100200529     C                   EXSR      ZDATE2
514200200529     C                   MOVE      ZDATE         #1BEND
514300200529     C                   ELSE                                                   X*1
514400200529     C                   MOVE      *BLANKS       #1BEND
514500200529     C                   ENDIF                                                  E*1
514600200529      *
514700200529     C                   MOVE      #1BEND        #2BEND
514800200529      *                                                                                       CGL031
514900200529      ** Move relevant file fields to screen fields if CGL031 is enabled.                     CGL031
515000200529      *                                                                                       CGL031
515100200529     C                   IF        CGL031 = 'Y'                                               CGL031
515200200529     C                   EVAL      #1SETX = MASETX                                            CGL031
515300200529     C                   ENDIF                                                                CGL031
515400200529      *
515500200529     C                   MOVE      MAREFO        #1REFO
515600200529     C                   MOVE      MACONR        #1CONR
515700200529     C                   MOVE      MADFNR        #1DFNR
515800200529     C                   MOVE      MADFCP        #1DFCP
515900200529     C                   MOVE      MADFSP        #1DFSP
516000200529      *                                                                                       CSE020
516100200529      ** Move parent reference field to screen fields.                                        CSE020
516200200529      *                                                                                       CSE020
516300200529     C     CSE020        IFEQ      'Y'                                                        CSE020
516400200529     C     MAPREF        ANDNE     *BLANKS                                                    CSE020
516500200529     C                   MOVE      MAPREF        #1PREF                                       CSE020
516600200529     C                   MOVE      '1'           *IN53                                        CSE020
516700200529     C                   ELSE                                                                 CSE020
516800200529     C                   MOVE      '0'           *IN53                                        CSE020
516900200529     C                   ENDIF                                                                CSE020
517000200529      *
517100200529     C                   MOVE      MANBOP        WNBOP
517200200529     C/COPY WNCPYSRC,SE7502C039
517300200529      *
517400200529     C                   MOVE      '1'           *IN47
517500200529      *                                                                                       CSE020
517600200529      ** Include F8 for Subordinate Action if CSE020 is installed and                         CSE020
517700200529      ** if CA Processing type is allowed to have a child                                     CSE020
517800200529      *                                                                                       CSE020
517900200529     C                   MOVE      '0'           *IN68                                        CSE020
518000200529     C     CSE020        IFEQ      'Y'                                                        CSE020
518100200529     C     #1LEVL        ANDNE     '9'                                                        CSE020
518200200529     C     #1PTYP        IFEQ      'FR'                                                       CSE020
518300200529     C     #1PTYP        OREQ      'CC'                                                       CSE020
518400200529     C     #1PTYP        OREQ      'CR'                                                       CSE020
518500200529     C     #1PTYP        OREQ      'DV'                                                       CSE020
518600200529     C     #1PTYP        OREQ      'EX'                                                       CSE020
518700200529     C     #1PTYP        OREQ      'NC'                                                       CSE020
518800200529     C     #1PTYP        OREQ      'OF'                                                       CSE020
518900200529     C     #1PTYP        OREQ      'RG'                                                       CSE020
519000200529     C                   MOVE      '1'           *IN68                                        CSE020
519100200529     C                   ELSE                                                                 CSE020
519200200529     C                   MOVE      '0'           *IN68                                        CSE020
519300200529     C                   ENDIF                                                                CSE020
519400200529     C                   ENDIF                                                                CSE020
519500200529      *                                                                                       CSE020
519600200529     C     CSE020        IFEQ      'Y'                                                        CSE020
519700200529     C     WWINPT        ANDNE     'Y'                                                        CSE020
519800200529     C     *IN68         ANDEQ     '1'                                                        CSE020
519900200529     C     *IN61         IFEQ      '1'                                                        CSE020
520000200529     C                   MOVE      TXT(7)        ##CTX1                                       CSE020
520100200529     C                   ELSE                                                                 CSE020
520200200529     C                   MOVE      TXT(8)        ##CTX1                                       CSE020
520300200529     C                   ENDIF                                                                CSE020
520400200529     C                   ELSE                                                                 CSE020
520500200529      *
520600200529     C     WWINPT        IFEQ      'Y'                                          B*0            13787
520700200529     C                   MOVEA     TXT(6)        ##CTX1                                        13787
520800200529     C                   ELSE                                                   X*0            13787
520900200529     C     *IN61         IFEQ      '1'                                          B*1
521000200529     C                   MOVEA     TXT(4)        ##CTX1
521100200529     C                   ELSE                                                   X*1
521200200529     C                   MOVEA     TXT(5)        ##CTX1
521300200529     C                   ENDIF                                                  E*1
521400200529     C                   ENDIF                                                  E*0            13787
521500200529     C                   ENDIF                                                                CSE020
521600200529      *                                                                                       CSE016
521700200529      ** Retrieve security description                                                        CSE016
521800200529      *                                                                                       CSE016
521900200529     C     #1SECN        CHAIN     SECTYZ1                            89                      CSE016
522000200529     C     *IN89         IFEQ      *OFF                                                       CSE016
522100200529      *                                                                                       CSE016
522200200529      ** Format security report description                                                   CSE016
522300200529      *                                                                                       CSE016
522400200529     C                   MOVE      *BLANKS       #1SRNM                                       CSE016
522500200529      *                                                                                       CSE016
522600200529     C     #1SECN        IFNE      *BLANKS                                                    CSE016
522700200529      *                                                                                       CSE016
522800200529     C                   CALLB     'ZSDESC'                                                   CSE016
522900200529     C                   PARM      SRPN          PSRPN                                        CSE016
523000200529     C                   PARM                    PSFN1                                        CSE016
523100200529     C                   PARM                    PSFN2                                        CSE016
523200200529     C                   PARM                    CPNR                                         CSE016
523300200529     C                   PARM                    MATY                                         CSE016
523400200529     C                   PARM                    SCPP                                         CSE016
523500200529     C                   PARM                    SCPD                                         CSE016
523600200529     C                   PARM      BVRIDF        PRSFD                                        CSE016
523700200529     C                   PARM                    SCPI                                         CSE016
523800200529     C                   PARM                    PRNME                                        CSE016
523900200529     C                   PARM                    PFNM1                                        CSE016
524000200529     C                   PARM                    PFNM2                                        CSE016
524100200529     C                   PARM                    PFNM3                                        CSE016
524200200529      *                                                                                       CSE016
524300200529     C                   EVAL      #1SRNM = PRNME                                             CSE016
524400200529      *                                                                                       CSE016
524500200529     C                   ENDIF                                                                CSE016
524600200529      *                                                                                       CSE016
524700200529     C                   ENDIF                                                                CSE016
524800200529      *
524900200529     C                   MOVE      'Y'           ERROR             1
525000200529     C                   MOVE      '1'           *IN84
525100200529      *
525200200529      **  Determine fields to protect depending of the Status and the Final Allo
525300200529     C                   MOVE      '0'           *IN15
525400200529     C                   MOVE      '0'           *IN16
525500200529     C                   MOVE      '0'           *IN17
525600200529     C                   MOVE      '0'           *IN18
525700200529     C                   MOVE      '0'           *IN19
525800200529      *
525900200529      **  LS=Final Allocation Stock          (*IN15)
526000200529      **  LY=Final Allocation Cash and Stock (*IN16)
526100200529      **  S =Stock Authorised                (*IN17)
526200200529      **  X =Fully Authorised (Cash & Stock) (*IN18)
526300200529      **  C =Completed                       (*IN18 + *IN19)
526400200529      **  R =Reversed                        (*IN18 + *IN19)
526500200529     C     #1STAT        IFEQ      'L'                                          B*1
526600200529     C     #1FINA        IFEQ      'S'                                          B*2
526700200529     C                   MOVE      '1'           *IN15
526800200529     C                   ELSE                                                   X*2
526900200529     C     #1FINA        IFEQ      'Y'                                          B*3
527000200529     C                   MOVE      '1'           *IN16
527100200529     C                   ENDIF                                                  E*3
527200200529     C                   ENDIF                                                  E*2
527300200529     C                   ELSE                                                   X*1
527400200529     C     #1STAT        IFEQ      'S'                                          B*2
527500200529     C                   MOVE      '1'           *IN17
527600200529     C                   ELSE                                                   X*2
527700200529     C     #1STAT        IFEQ      'X'                                          B*3
527800200529     C                   MOVE      '1'           *IN18
527900200529     C                   ELSE                                                   X*3
528000200529     C     #1STAT        IFEQ      'C'                                          B*4
528100200529     C     #1STAT        OREQ      'R'
528200200529     C                   MOVE      '1'           *IN18
528300200529     C                   MOVE      '1'           *IN19
528400200529     C                   ENDIF                                                  E*4
528500200529     C                   ENDIF                                                  E*3
528600200529     C                   ENDIF                                                  E*2
528700200529     C                   ENDIF                                                  E*1
528800200529      *
528900200529      **   DO WHILE F12 OR F3 IS NOT PRESSED AND NO ERROR
529000200529      *
529100200529     C     *INKC         DOWEQ     '0'                                          B*1
529200200529     C     *INKL         ANDEQ     '0'
529300200529     C     ERROR         ANDEQ     'Y'
529400200529     C/COPY WNCPYSRC,SE7502C040
529500200529      *
529600200529      **   IF 'NUMBER OF OPTIONS' IS NOT 01
529700200529      **   NON PROTECT THE FIELDS 'ACCEPT OFFER', 'REFUSE OFFER', 'OPTION NARRAT
529800200529      **                          'DEFAULT CASH', 'DEFAULT STOCK', 'DEFAULT FOR
529900200529      *
530000200529     C                   MOVE      WNBOP         W1NBOP
530100200529      *
530200200529     C     W1NBOP        IFNE      1                                            B*2
530300200529     C                   MOVE      '0'           *IN26
530400200529     C                   ELSE                                                   X*2
530500200529     C                   MOVE      '1'           *IN26
530600200529     C                   ENDIF                                                  E*2
530700200529      *
530800200529      **   SETUP SCREEN TIME
530900200529      *
531000200529     C                   TIME                    ##TME                          Screen time.
531100200529      *
531200200529      **   EXECUTE SCREEN FORMAT
531300200529      *
531400200529     C/COPY WNCPYSRC,SE7502C041
531500200529     C                   WRITE     #MSGCTL
531600200529     C                   WRITE     SE7502F1
531700200529     C                   EXFMT     SE7502F3
531800200529     C*****                MOVE '0'       *IN15                    137879 137884
531900200529     C*****                MOVE '0'       *IN16                    137879 137884
532000200529     C*****                MOVE '0'       *IN17                    137879 137884
532100200529     C*****                MOVE '0'       *IN18                    137879 137884
532200200529     C*****                MOVE '0'       *IN19                    137879 137884
532300200529      *
532400200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
532500200529      *
532600200529     C                   CALL      'Y2CLMSC'
532700200529     C                   PARM      ##PGM         ZAPGM            10
532800200529     C                   PARM      '*SAME'       ZAPGRL            5
532900200529     C/COPY WNCPYSRC,SE7502C042
533000200529      *
533100200529     C                   MOVE      'N'           ERROR
533200200529      *                                                                                       CSE020
533300200529      ** Process Subordinate Action if F8 pressed.                                            CSE020
533400200529      *                                                                                       CSE020
533500200529     C     CSE020        IFEQ      'Y'                                                        CSE020
533600200529     C     *INKH         ANDEQ     '1'                                                        CSE020
533700200529     C     *IN68         ANDEQ     '1'                                                        CSE020
533800200529     C                   MOVE      'Y'           ERROR                                        CSE020
533900200529     C                   CALLB     'SE7502N'                                                  CSE020
534000200529     C                   PARM                    MACORF                                       CSE020
534100200529     C                   PARM                    MACOEX                                       CSE020
534200200529     C                   PARM                    ACTION                                       CSE020
534300200529     C                   PARM                    #1SECN                                       CSE020
534400200529     C                   PARM                    #1STAT                                       CSE020
534500200529     C                   PARM                    #1FINA                                       CSE020
534600200529     C                   PARM                    #1SEL                                        CSE020
534700200529     C                   PARM                    #1PTYP                                       CSE020
534800200529     C                   PARM                    PRTCD             1                          CSE020
534900200529      *                                                                                       CSE020
535000200529     C     PRTCD         IFEQ      'E'                                                        CSE020
535100200529      *                                                                                       CSE020
535200200529     C     MMPTYP        IFEQ      'NF'                                                       CSE020
535300200529     C                   MOVEL     NARR(2)       DBKEY            29                          CSE020
535400200529     C                   ELSE                                                                 CSE020
535500200529     C     MMPTYP        IFEQ      'NC'                                                       CSE020
535600200529     C                   MOVEL     NARR(3)       DBKEY                                        CSE020
535700200529     C                   ELSE                                                                 CSE020
535800200529     C     MMPTYP        IFEQ      'CC'                                                       CSE020
535900200529     C                   MOVEL     NARR(7)       DBKEY                                        CSE020
536000200529     C                   ELSE                                                                 CSE020
536100200529     C                   MOVEL     NARR(1)       DBKEY                                        CSE020
536200200529     C                   ENDIF                                                                CSE020
536300200529     C                   ENDIF                                                                CSE020
536400200529     C                   ENDIF                                                                CSE020
536500200529      *                                                                                       CSE020
536600200529     C                   MOVEL     '009'         DBASE             3 0                        CSE020
536700200529     C                   MOVEL     *BLANKS       DBFILE           10                          CSE020
536800200529     C                   EXSR      *PSSR                                                      CSE020
536900200529     C                   ENDIF                                                                CSE020
537000200529      *                                                                                       CSE020
537100200529      ** If Return Code is equal to '2', '3'                                                  CSE020
537200200529      *                                                                                       CSE020
537300200529     C     PRTCD         IFEQ      '3'                                                        CSE020
537400200529      *                                                                                       CSE020
537500200529      ** Access to ER Reference file with current reference                                   CSE020
537600200529      *                                                                                       CSE020
537700200529     C     #1REFN        CHAIN     SECORFL0                           88                      CSE020
537800200529      *                                                                                       CSE020
537900200529     C     *IN88         IFEQ      '0'                                                        CSE020
538000200529     C                   MOVE      *BLANKS       MAJOBN                                       CSE020
538100200529     C                   MOVE      *BLANKS       MAUSER                                       CSE020
538200200529     C                   Z-ADD     *ZEROS        MAJNBR                                       CSE020
538300200529      *                                                                                       CSE020
538400200529     C     MACHTP        IFNE      'R'                                                        CSE020
538500200529     C     MASTAT        ANDNE     'R'                                                        CSE020
538600200529     C     MASTAT        ANDNE     'C'                                                        CSE020
538700200529     C                   MOVE      'D'           MARECI                                       CSE020
538800200529     C                   Z-ADD     BJRDNB        MALCD                                        CSE020
538900200529     C                   MOVE      'A'           MACHTP                                       CSE020
539000200529     C                   MOVE      ##USR         MALUID                                       CSE020
539100200529     C                   ENDIF                                                                CSE020
539200200529      *                                                                                       CSE020
539300200529     C                   UPDATE    SECORFD0                                                   CSE020
539400200529     C                   MOVE      FIELD         #FIELD                                       CSE020
539500200529     C                   ENDIF                                                                CSE020
539600200529      *                                                                                       CSE020
539700200529      ** Commitment Instruction                                                               CSE020
539800200529      *                                                                                       CSE020
539900200529     C                   COMMIT                                                               CSE020
540000200529     C                   ENDIF                                                                CSE020
540100200529      *                                                                                       CSE020
540200200529     C     PRTCD         IFEQ      '3'                                                        CSE020
540300200529     C                   MOVE      '1'           *INKC                                        CSE020
540400200529     C                   ELSE                                                                 CSE020
540500200529     C     WWINPT        IFEQ      'Y'                                                        CSE020
540600200529     C                   MOVE      '1'           *INKL                                        CSE020
540700200529     C                   ENDIF                                                                CSE020
540800200529     C     PRTCD         IFEQ      '1'                                                        CSE020
540900200529     C                   MOVE      '0'           WIN45                                        CSE020
541000200529     C                   ENDIF                                                                CSE020
541100200529     C                   ENDIF                                                                CSE020
541200200529      *                                                                                       CSE020
541300200529     C                   ELSE                                                                 CSE020
541400200529      *
541500200529      **   IF CMD11 PRESSED
541600200529      *
541700200529     C     *INKK         IFEQ      '1'                                          B*2
541800200529     C     *INKC         OREQ      '0'                                                         13787
541900200529     C     *INKL         ANDEQ     '0'                                                         13787
542000200529     C     WWINPT        ANDEQ     'Y'                                                         13787
542100200529      *                                                                   155622
542200200529      **   VALIDATE DETAILS AND UPDATE FILE IF NO ERROR                   155622
542300200529      *                                                                   155622
542400200529     C     *IN61         IFEQ      '0'                                          B*3            15562
542500200529     C                   EXSR      P019                                                        15562
542600200529     C                   ENDIF                                                  E*3            15562
542700200529      *
542800200529      **   VIEW/CHANGE OPTION(S)
542900200529      *
543000200529     C     ERROR         IFEQ      'N'                                          B*3            15562
543100200529     C/COPY WNCPYSRC,SE7502C043
543200200529     C                   EXSR      P023
543300200529     C/COPY WNCPYSRC,SE7502C044
543400200529     C                   ENDIF                                                  E*3            15562
543500200529     C                   ELSE                                                   X*2
543600200529      *
543700200529      **   IF ALL INPUT FIELDS ARE NOT PROTECTED
543800200529      *
543900200529     C     *IN61         IFEQ      '0'                                          B*3
544000200529     C     #1SECN        CHAIN     SECTYZ1                            89
544100200529      *
544200200529      **   VALIDATE DETAILS AND UPDATE FILE IF NO ERROR
544300200529      *
544400200529     C                   EXSR      P019
544500200529     C                   ENDIF                                                  E*3
544600200529     C                   ENDIF                                                  E*2
544700200529     C/COPY WNCPYSRC,SE7502C045
544800200529     C                   ENDIF                                                                CSE020
544900200529     C                   ENDDO                                                  E*1
545000200529      *                                                                   137884
545100200529     C                   MOVE      '0'           *IN15                                         13788
545200200529     C                   MOVE      '0'           *IN16                                         13788
545300200529     C                   MOVE      '0'           *IN17                                         13788
545400200529     C                   MOVE      '0'           *IN18                                         13788
545500200529     C                   MOVE      '0'           *IN19                                         13788
545600200529      *
545700200529      **   SETUP CORRECTLY THE COMMAND KEYS AVAILABLE
545800200529      *
545900200529     C                   MOVEA     TXT(3)        ##CTX1
546000200529      *
546100200529     C                   MOVE      '0'           *IN47
546200200529      *
546300200529      **   CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE.
546400200529      *
546500200529     C/COPY WNCPYSRC,SE7502C046
546600200529     C                   CALL      'Y2CLMSC'
546700200529     C                   PARM      ##PGM         ZAPGM            10
546800200529     C                   PARM      '*SAME'       ZAPGRL            5
546900200529     C/COPY WNCPYSRC,SE7502C047
547000200529      *
547100200529     C                   ENDSR
547200200529      ****************************************************************
547300200529      /EJECT
547400200529      *****************************************************************
547500200529      * P019  : VALIDATE 'FULL DETAILS' SCREEN AND UPDATE FILE        *
547600200529      *****************************************************************
547700200529      *
547800200529     C     P019          BEGSR
547900200529      *
548000200529      **   ACCESS SECURITY DETAILS WITH CURRENT SECURITY SHORTNAME
548100200529      *
548200200529     C     #1SECN        CHAIN     SECTYZ1                            89
548300200529      *
548400200529      **   INITIALISE ERROR INDICATORS
548500200529      *
548600200529     C                   EVAL      *IN07 = *OFF                                               CGL031
548700200529     C                   MOVE      '0'           *IN13
548800200529     C                   MOVE      '0'           *IN14
548900200529     C                   MOVE      '0'           *IN20
549000200529     C                   MOVE      '0'           *IN21
549100200529     C                   MOVE      '0'           *IN22
549200200529     C                   MOVE      '0'           *IN23
549300200529     C                   MOVE      '0'           *IN24
549400200529     C                   MOVE      '0'           *IN31
549500200529     C                   MOVE      '0'           *IN42
549600200529     C                   MOVE      '0'           *IN49
549700200529     C                   MOVE      '0'           *IN60
549800200529     C                   MOVE      '0'           *IN65
549900200529     C                   MOVE      '0'           *IN66
550000200529     C                   MOVE      '0'           *IN67
550100200529     C                   MOVE      '0'           *IN70
550200200529     C                   MOVE      '0'           *IN71
550300200529     C                   MOVE      '0'           *IN72
550400200529     C                   MOVE      '0'           *IN73
550500200529     C                   MOVE      '0'           *IN74
550600200529     C                   MOVE      '0'           *IN76
550700200529     C                   MOVE      '0'           *IN77
550800200529     C                   MOVE      '0'           *IN78
550900200529     C                   MOVE      '0'           *IN79
551000200529     C                   MOVE      '0'           *IN82
551100200529     C                   MOVE      '0'           *IN83
551200200529     C                   MOVE      '0'           *IN85
551300200529      *
551400200529     C                   Z-ADD     *ZEROS        WCOPD             5 0
551500200529     C                   Z-ADD     *ZEROS        WTDDT             5 0
551600200529     C                   Z-ADD     *ZEROS        WEVDT             5 0
551700200529      *
551800200529     C                   MOVE      #1EXDT        ZDATE
551900200529     C                   EXSR      ZDATE1
552000200529     C                   Z-ADD     ZDAYNO        WEXDT             5 0
552100200529      *
552200200529     C                   MOVE      #1ALEF        ZDATE
552300200529     C                   EXSR      ZDATE1
552400200529     C                   Z-ADD     ZDAYNO        WALEF             5 0
552500200529      *
552600200529      **   IF 'PAYMENT DATE' IS NOT BLANK
552700200529      *
552800200529     C     #1COPD        IFNE      *BLANKS                                      B*1
552900200529      *
553000200529     C                   MOVE      #1COPD        ZDATE
553100200529     C                   EXSR      ZDATE1
553200200529      *
553300200529      **   IF 'PAYMENT DATE IS NOT A VALID DATE FORMAT
553400200529      *
553500200529     C     *IN99         IFEQ      '1'                                          B*2
553600200529     C                   MOVE      'Y'           ERROR
553700200529     C                   MOVE      '1'           *IN65                          Reverse image
553800200529     C                   MOVEL     'CO00038'     ZAMSID                         Message id.
553900200529     C                   EXSR      ZASNMS                                       Send message
554000200529     C                   ELSE                                                   X*2
554100200529     C                   Z-ADD     ZDAYNO        WCOPD             5 0
554200200529      *
554300200529      **   IF 'PAYMENT DATE' IS BEFORE THE 'EX-DATE'
554400200529      *
554500200529     C     WCOPD         IFLT      WEXDT                                        B*3
554600200529     C     WEXDT         ANDNE     *ZEROS
554700200529     C                   MOVE      'Y'           ERROR
554800200529     C                   MOVE      '1'           *IN65                          Reverse image
554900200529     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
555000200529     C                   EXSR      ZASNMS                                       Send message
555100200529     C                   ENDIF                                                  E*3
555200200529      *
555300200529      **   IF 'PAYMENT DATE' IS BEFORE THE 'ALLOCATION EFFECTIVE DATE'
555400200529      *
555500200529     C     WCOPD         IFLT      WALEF                                        B*3
555600200529     C     WALEF         ANDNE     *ZEROS
555700200529     C                   MOVE      'Y'           ERROR
555800200529     C                   MOVE      '1'           *IN65                          Reverse image
555900200619     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
556100200529     C                   EXSR      ZASNMS                                       Send message
556200200529     C                   ENDIF                                                  E*3
556300200529      *
556400200529      **   IF 'PAYMENT DATE' IS GREATER OR EQUAL TO THE MATURITY DATE OF THE SEC
556500200529      *
556600200529     C     WCOPD         IFGE      MATY                                         B*3
556700200529     C     MATY          ANDNE     *ZEROS
556800200529     C                   MOVE      'Y'           ERROR
556900200529     C                   MOVE      '1'           *IN65                          Reverse image
557000200529     C                   MOVEL     'CO00217'     ZAMSID                         Message id.
557100200529     C                   EXSR      ZASNMS                                       Send message
557200200529     C                   ENDIF                                                  E*3
557300200529     C                   ENDIF                                                  E*2
557400200529     C                   ENDIF                                                  E*1
557500200529      *
557600200529      **   IF 'TRADE DATE' IS NOT BLANK
557700200529      *
557800200529     C     #1TDDT        IFNE      *BLANKS                                      B*1
557900200529      *
558000200529     C                   MOVE      #1TDDT        ZDATE
558100200529     C                   EXSR      ZDATE1
558200200529      *
558300200529      **   IF 'TRADE DATE IS NOT A VALID DATE FORMAT
558400200529      *
558500200529     C     *IN99         IFEQ      '1'                                          B*2
558600200529     C                   MOVE      'Y'           ERROR
558700200529     C                   MOVE      '1'           *IN60                          Reverse image
558800200529     C                   MOVEL     'CO00301'     ZAMSID                         Message id.
558900200529     C                   EXSR      ZASNMS                                       Send message
559000200529     C                   ELSE                                                   X*2
559100200529     C                   Z-ADD     ZDAYNO        WTDDT             5 0
559200200529      *
559300200529      **   IF 'TRADE DATE' IS GREATER THAN THE 'ALLOCATION EFFECTIVE DATE'
559400200529      *
559500200529     C     WTDDT         IFGT      WALEF                                        B*3
559600200529     C     WALEF         ANDNE     *ZEROS
559700200529     C                   MOVE      'Y'           ERROR
559800200529     C                   MOVE      '1'           *IN60                          Reverse image
559900200529     C                   MOVEL     'CO00212'     ZAMSID                         Message id.
560000200529     C                   EXSR      ZASNMS                                       Send message
560100200529     C                   ENDIF                                                  E*3
560200200529      *
560300200529      **   IF 'TRADE DATE' MUST BE LOWER THAN THE MATURITY DATE OF THE SECURITY
560400200529      *
560500200529     C     WTDDT         IFGE      MATY                                         B*3
560600200529     C     MATY          ANDNE     *ZEROS
560700200529     C                   MOVE      'Y'           ERROR
560800200529     C                   MOVE      '1'           *IN60                          Reverse image
560900200529     C                   MOVEL     'CO00218'     ZAMSID                         Message id.
561000200529     C                   EXSR      ZASNMS                                       Send message
561100200529     C                   ENDIF                                                  E*3
561200200529      *
561300200529      **   IF 'TRADE DATE' MUST BE GREATER OR EQUAL THAN SE BACK VALUE PERIOD
561400200529      *
561500200529     C     WTDDT         IFLT      WBACKD                                       B*3
561600200529     C                   MOVE      'Y'           ERROR
561700200529     C                   MOVE      '1'           *IN60                          Reverse image
561800200529     C                   MOVEL     'CO00219'     ZAMSID                         Message id.
561900200529     C                   EXSR      ZASNMS                                       Send message
562000200529     C                   ENDIF                                                  E*3
562100200529     C                   ENDIF                                                  E*2
562200200529     C                   ENDIF                                                  E*1
562300200529      *
562400200529      **   IF 'EVENT DATE' IS NOT BLANK
562500200529      *
562600200529     C     #1EVDT        IFNE      *BLANKS                                      B*1
562700200529      *
562800200529     C                   MOVE      #1EVDT        ZDATE
562900200529     C                   EXSR      ZDATE1
563000200529      *
563100200529      **   IF 'EVENT DATE IS NOT A VALID DATE FORMAT
563200200529      *
563300200529     C     *IN99         IFEQ      '1'                                          B*2
563400200529     C                   MOVE      'Y'           ERROR
563500200529     C                   MOVE      '1'           *IN49                          Reverse image
563600200529     C                   MOVEL     'CO00211'     ZAMSID                         Message id.
563700200529     C                   EXSR      ZASNMS                                       Send message
563800200529     C                   ELSE                                                   X*2
563900200529     C                   Z-ADD     ZDAYNO        WEVDT             5 0
564000200529      *
564100200529      **   IF 'PAYMENT DATE' IS BEFORE 'EVENT DATE'
564200200529      *
564300200529     C     WCOPD         IFLT      WEVDT                                        B*3
564400200529     C     WCOPD         ANDNE     *ZEROS
564500200529     C                   MOVE      'Y'           ERROR
564600200529     C                   MOVE      '1'           *IN65                          Reverse image
564700200529     C                   MOVEL     'CO00216'     ZAMSID                         Message id.
564800200529     C                   EXSR      ZASNMS                                       Send message
564900200529     C                   ENDIF                                                  E*3
565000200529      *
565100200529      **   IF 'EVENT DATE' MUST NOT BE BEFORE 'EX-DATE'
565200200529      *
565300200529     C     WEVDT         IFLT      WEXDT                                        B*3
565400200529     C                   MOVE      'Y'           ERROR
565500200529     C                   MOVE      '1'           *IN49                          Reverse image
565600200529     C                   MOVEL     'CO00213'     ZAMSID                         Message id.
565700200529     C                   EXSR      ZASNMS                                       Send message
565800200529     C                   ENDIF                                                  E*3
565900200529      *
566000200529      **   IF 'EVENT DATE' MUST BE LOWER THAN MATURITY DATE OF THE SECURITY
566100200529      *
566200200529     C     WEVDT         IFGE      MATY                                         B*3
566300200529     C     MATY          ANDNE     *ZEROS
566400200529     C                   MOVE      'Y'           ERROR
566500200529     C                   MOVE      '1'           *IN49                          Reverse image
566600200529     C                   MOVEL     'CO00220'     ZAMSID                         Message id.
566700200529     C                   EXSR      ZASNMS                                       Send message
566800200529     C                   ENDIF                                                  E*3
566900200529     C                   ENDIF                                                  E*2
567000200529     C                   ENDIF                                                  E*1
567100200529      *
567200200529      **   IF 'TRADE/VALUE DATE POSITION' IS ENTERED
567300200529      *
567400200529     C     #1TDVD        IFNE      *BLANKS                                      B*1
567500200529      *
567600200529      **   'TRADE/VALUE DATE POSITION' MUST BE EQUAL TO 'T' OR 'V'
567700200529      *
567800200529     C     #1TDVD        IFNE      'T'                                          B*2
567900200529     C     #1TDVD        ANDNE     'V'
568000200529     C                   MOVE      'Y'           ERROR
568100200529     C                   MOVE      '1'           *IN66                          Reverse image
568200200529     C                   MOVEL     'CO00037'     ZAMSID                         Message id.
568300200529     C                   EXSR      ZASNMS                                       Send message
568400200529     C                   ENDIF                                                  E*2
568500200529     C                   ELSE                                                   X*1
568600200529     C                   MOVE      'T'           #1TDVD
568700200529     C                   ENDIF                                                  E*1
568800200529      *
568900200529      **   IF 'COUPON NUMBER' IS ENTERED
569000200529      *
569100200529     C     #1CPNB        IFNE      *BLANKS                                      B*1
569200200529      *
569300200529      **   CHECK IT'S A VALID NUMERIC FIELD
569400200529      *
569500200529     C     DIGITS        CHECK     #1CPNB:1      N                 1 0    89
569600200529      *
569700200529      **   IF IT'S NOT A VALID NUMERIC FIELD
569800200529      *
569900200529     C     *IN89         IFEQ      '1'                                          B*2
570000200529     C                   MOVE      'Y'           ERROR
570100200529     C                   MOVE      '1'           *IN67                          Reverse image
570200200529     C                   MOVEL     'CO00040'     ZAMSID                         Message id.
570300200529     C                   EXSR      ZASNMS                                       Send message
570400200529     C                   ENDIF                                                  E*2
570500200529     C                   ENDIF                                                  E*1
570600200529      *
570700200529      **   IF 'SHAREHOLDERS MEETING DATE' IS ENTERED
570800200529      *
570900200529     C     #1SHMD        IFNE      *BLANKS                                      B*1
571000200529      *
571100200529     C                   MOVE      #1SHMD        ZDATE
571200200529     C                   EXSR      ZDATE1
571300200529      *
571400200529      **   IF 'SHAREHOLDERS MEETING DATE' IS NOT A VALID DATE FORMAT
571500200529      *
571600200529     C     *IN99         IFEQ      '1'                                          B*2
571700200529     C                   MOVE      'Y'           ERROR
571800200529     C                   MOVE      '1'           *IN70                          Reverse image
571900200529     C                   MOVEL     'CO00043'     ZAMSID                         Message id.
572000200529     C                   EXSR      ZASNMS                                       Send message
572100200529     C                   ENDIF                                                  E*2
572200200529     C                   ENDIF                                                  E*1
572300200529      *
572400200529      **   IF 'LETTER TO BE SENT' HAS BEEN ENTERED
572500200529      *
572600200529     C     #1LTBS        IFNE      *BLANKS                                      B*1
572700200529      *
572800200529      **   'LETTER TO BE SENT' MUST BE EQUAL TO 'Y' OR 'N'
572900200529      *
573000200529     C     #1LTBS        IFNE      'Y'                                          B*2
573100200529     C     #1LTBS        ANDNE     'N'
573200200529     C                   MOVE      'Y'           ERROR
573300200529     C                   MOVE      '1'           *IN71                          Reverse image
573400200529     C                   MOVEL     'CO00044'     ZAMSID                         Message id.
573500200529     C                   EXSR      ZASNMS                                       Send message
573600200529     C                   ENDIF                                                  E*2
573700200529     C                   ELSE                                                   X*1
573800200529     C                   MOVE      'N'           #1LTBS
573900200529     C                   ENDIF                                                  E*1
574000200529      *
574100200529      **   IF 'OLD CAPITAL VALUE' HAS BEEN ENTERED
574200200529      *
574300200529     C     #1OCPV        IFNE      *BLANKS                                      B*1
574400200529     C                   MOVE      *BLANKS       ZFLD17
574500200529     C                   MOVE      #1OCPV        ZFLD17
574600200529     C     15            SUB       NMDP          ZSDIG
574700200529     C                   Z-ADD     NMDP          ZSDEC
574800200529     C                   EXSR      ZASIGN
574900200529     C     *IN99         IFEQ      '1'                                          B*2
575000200529     C                   MOVEL     'CO00129'     ZAMSID
575100200529     C                   EXSR      ZASNMS
575200200529     C                   MOVE      'Y'           ERROR
575300200529     C                   MOVE      '1'           *IN20
575400200529     C                   ENDIF                                                  E*2
575500200529     C                   ENDIF                                                  E*1
575600200529      *
575700200529      **   IF 'NEW CAPITAL VALUE' HAS BEEN ENTERED
575800200529      *
575900200529     C     #1NCPV        IFNE      *BLANKS                                      B*1
576000200529     C                   MOVE      *BLANKS       ZFLD17
576100200529     C                   MOVE      #1NCPV        ZFLD17
576200200529     C     15            SUB       NMDP          ZSDIG
576300200529     C                   Z-ADD     NMDP          ZSDEC
576400200529     C                   EXSR      ZASIGN
576500200529     C     *IN99         IFEQ      '1'                                          B*2
576600200529     C                   MOVEL     'CO00130'     ZAMSID
576700200529     C                   EXSR      ZASNMS
576800200529     C                   MOVE      'Y'           ERROR
576900200529     C                   MOVE      '1'           *IN21
577000200529     C                   ENDIF                                                  E*2
577100200529     C                   ENDIF                                                  E*1
577200200529      *
577300200529      **   IF 'OLD NOMINAL VALUE' HAS BEEN ENTERED
577400200529      *
577500200529     C     #1ONML        IFNE      *BLANKS                                      B*1
577600200529     C                   MOVE      *BLANKS       ZFLD17
577700200529     C                   MOVE      #1ONML        ZFLD17
577800200529     C     15            SUB       NMDP          ZSDIG
577900200529     C                   Z-ADD     NMDP          ZSDEC
578000200529     C                   EXSR      ZASIGN
578100200529     C     *IN99         IFEQ      '1'                                          B*2
578200200529     C                   MOVEL     'CO00131'     ZAMSID
578300200529     C                   EXSR      ZASNMS
578400200529     C                   MOVE      'Y'           ERROR
578500200529     C                   MOVE      '1'           *IN22
578600200529     C                   ENDIF                                                  E*2
578700200529     C                   ENDIF                                                  E*1
578800200529      *
578900200529      **   IF 'NEW NOMINAL VALUE' HAS BEEN ENTERED
579000200529      *
579100200529     C     #1NNML        IFNE      *BLANKS                                      B*1
579200200529     C                   MOVE      *BLANKS       ZFLD17
579300200529     C                   MOVE      #1NNML        ZFLD17
579400200529     C     15            SUB       NMDP          ZSDIG
579500200529     C                   Z-ADD     NMDP          ZSDEC
579600200529     C                   EXSR      ZASIGN
579700200529     C     *IN99         IFEQ      '1'                                          B*2
579800200529     C                   MOVEL     'CO00132'     ZAMSID
579900200529     C                   EXSR      ZASNMS
580000200529     C                   MOVE      'Y'           ERROR
580100200529     C                   MOVE      '1'           *IN23
580200200529     C                   ENDIF                                                  E*2
580300200529     C                   ENDIF                                                  E*1
580400200529      *
580500200529      **   IF 'MARKET CUM PRICE' HAS BEEN ENTERED
580600200529      *
580700200529     C     #1CUPC        IFNE      *BLANKS                                      B*1
580800200529     C                   MOVE      *BLANKS       ZFIELD
580900200529     C                   MOVE      #1CUPC        ZFIELD
581000200529     C                   Z-ADD     7             ZADIG
581100200529     C                   Z-ADD     8             ZADEC
581200200529     C                   EXSR      ZALIGN
581300200529     C     *IN99         IFEQ      '1'                                          B*2
581400200529     C                   MOVEL     'CO00133'     ZAMSID
581500200529     C                   EXSR      ZASNMS
581600200529     C                   MOVE      'Y'           ERROR
581700200529     C                   MOVE      '1'           *IN24
581800200529     C                   ENDIF                                                  E*2
581900200529     C                   ENDIF                                                  E*1
582000200529      *
582100200529      **   IF 'MARKET EX PRICE' HAS BEEN ENTERED
582200200529      *
582300200529     C     #1EXPC        IFNE      *BLANKS                                      B*1
582400200529     C                   MOVE      *BLANKS       ZFIELD
582500200529     C                   MOVE      #1EXPC        ZFIELD
582600200529     C                   Z-ADD     7             ZADIG
582700200529     C                   Z-ADD     8             ZADEC
582800200529     C                   EXSR      ZALIGN
582900200529     C     *IN99         IFEQ      '1'                                          B*2
583000200529     C                   MOVEL     'CO00134'     ZAMSID
583100200529     C                   EXSR      ZASNMS
583200200529     C                   MOVE      'Y'           ERROR
583300200529     C                   MOVE      '1'           *IN31
583400200529     C                   ENDIF                                                  E*2
583500200529     C                   ENDIF                                                  E*1
583600200529      *
583700200529      **   IF 'CUSTOMER LAST REPLY DATE' HAS BEEN ENTERED
583800200529      *
583900200529     C     #1CLRD        IFNE      *BLANKS                                      B*1
584000200529      *
584100200529     C                   MOVE      #1CLRD        ZDATE
584200200529     C                   EXSR      ZDATE1
584300200529      *
584400200529      **   'CUSTOMER LAST REPLY DATE' MUST BE A VALID DATE FORMAT
584500200529      *
584600200529     C     *IN99         IFEQ      '1'                                          B*2
584700200529     C                   MOVE      'Y'           ERROR
584800200529     C                   MOVE      '1'           *IN83                          Reverse image
584900200529     C                   MOVEL     'CO00059'     ZAMSID                         Message id.
585000200529     C                   EXSR      ZASNMS                                       Send message
585100200529     C                   ENDIF                                                  E*2
585200200529     C                   ENDIF                                                  E*1
585300200529      *
585400200529      **   IF 'CUSTOMER LAST REPLY TIME' HAS BEEN ENTERED
585500200529      *
585600200529     C     #1CLRT        IFNE      *BLANKS                                      B*1
585700200529      *
585800200529      **   NO ENTRY ALLOWED WHEN 'CUSTOMER LAST REPLY DATE' IS NOT ENTERED
585900200529      *
586000200529     C     #1CLRD        IFEQ      *BLANKS                                      B*2
586100200529     C                   MOVE      'Y'           ERROR
586200200529     C                   MOVE      '1'           *IN13                          Reverse image
586300200529     C                   MOVEL     'CO00062'     ZAMSID                         Message id.
586400200529     C                   EXSR      ZASNMS                                       Send message
586500200529     C                   ELSE                                                   X*2
586600200529      *
586700200529     C                   MOVEL     #1CLRT        WWHOUR            2 0
586800200529     C                   MOVE      #1CLRT        WWMISE            4
586900200529     C                   MOVEL     WWMISE        WWMINS            2 0
587000200529     C                   MOVE      WWMISE        WWSECS            2 0
587100200529      *
587200200529      **   'CUSTOMER LAST REPLY TIME' MUST BE A VALID TIME FORMAT
587300200529      *
587400200529     C     WWHOUR        IFGT      23                                           B*3
587500200529     C     WWHOUR        ORLT      0
587600200529     C     WWMINS        ORGT      59
587700200529     C     WWMINS        ORLT      0
587800200529     C     WWSECS        ORGT      59
587900200529     C     WWSECS        ORLT      0
588000200529     C                   MOVE      'Y'           ERROR
588100200529     C                   MOVE      '1'           *IN13                          Reverse image
588200200529     C                   MOVEL     'CO00061'     ZAMSID                         Message id.
588300200529     C                   EXSR      ZASNMS                                       Send message
588400200529     C                   ENDIF                                                  E*3
588500200529     C                   ENDIF                                                  E*2
588600200529     C                   ENDIF                                                  E*1
588700200529      *
588800200529      **   IF 'DEPOT LAST REPLY DATE' HAS BEEN ENTERED
588900200529      *
589000200529     C     #1DLRD        IFNE      *BLANKS                                      B*1
589100200529      *
589200200529     C                   MOVE      #1DLRD        ZDATE
589300200529     C                   EXSR      ZDATE1
589400200529      *
589500200529      **   'DEPOT LAST REPLY DATE' MUST BE A VALID DATE FORMAT
589600200529      *
589700200529     C     *IN99         IFEQ      '1'                                          B*2
589800200529     C                   MOVE      'Y'           ERROR
589900200529     C                   MOVE      '1'           *IN85                          Reverse image
590000200529     C                   MOVEL     'CO00060'     ZAMSID                         Message id.
590100200529     C                   EXSR      ZASNMS                                       Send message
590200200529     C                   ENDIF                                                  E*2
590300200529     C                   ENDIF                                                  E*1
590400200529      *
590500200529      **   IF 'DEPOT LAST REPLY TIME' HAS BEEN ENTERED
590600200529      *
590700200529     C     #1DLRT        IFNE      *BLANKS                                      B*1
590800200529      *
590900200529      **   NO ENTRY ALLOWED WHEN 'DEPOT LAST REPLY DATE' IS NOT ENTERED
591000200529      *
591100200529     C     #1DLRD        IFEQ      *BLANKS                                      B*2
591200200529     C                   MOVE      'Y'           ERROR
591300200529     C                   MOVE      '1'           *IN14                          Reverse image
591400200529     C                   MOVEL     'CO00064'     ZAMSID                         Message id.
591500200529     C                   EXSR      ZASNMS                                       Send message
591600200529     C                   ELSE                                                   X*2
591700200529      *
591800200529     C                   MOVEL     #1DLRT        WWHOUR            2 0
591900200529     C                   MOVE      #1DLRT        WWMISE            4
592000200529     C                   MOVEL     WWMISE        WWMINS            2 0
592100200529     C                   MOVE      WWMISE        WWSECS            2 0
592200200529      *
592300200529      **   'CUSTOMER LAST REPLY TIME' MUST BE A VALID TIME FORMAT
592400200529      *
592500200529     C     WWHOUR        IFGT      23                                           B*3
592600200529     C     WWHOUR        ORLT      0
592700200529     C     WWMINS        ORGT      59
592800200529     C     WWMINS        ORLT      0
592900200529     C     WWSECS        ORGT      59
593000200529     C     WWSECS        ORLT      0
593100200529     C                   MOVE      'Y'           ERROR
593200200529     C                   MOVE      '1'           *IN14                          Reverse image
593300200529     C                   MOVEL     'CO00063'     ZAMSID                         Message id.
593400200529     C                   EXSR      ZASNMS                                       Send message
593500200529     C                   ENDIF                                                  E*3
593600200529     C                   ENDIF                                                  E*2
593700200529     C                   ENDIF                                                  E*1
593800200529      *
593900200529      **   IF 'BLOCK SECURITY' HAS BEEN ENTERED
594000200529      *
594100200529     C     #1BLOS        IFNE      *BLANKS                                      B*1
594200200529      *
594300200529      **   'BLOCK SECURITY' MUST BE EQUAL TO 'E', 'W' OR 'N'
594400200529      *
594500200529     C     #1BLOS        IFNE      'E'                                          B*2
594600200529     C     #1BLOS        ANDNE     'W'
594700200529     C     #1BLOS        ANDNE     'N'
594800200529     C                   MOVE      'Y'           ERROR
594900200529     C                   MOVE      '1'           *IN42                          Reverse image
595000200529     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
595100200529     C                   EXSR      ZASNMS                                       Send message
595200200529     C                   ENDIF                                                  E*2
595300200529     C                   ELSE                                                   X*1
595400200529     C                   MOVE      'N'           #1BLOS
595500200529     C                   ENDIF                                                  E*1
595600200529      *
595700200529      **   IF 'BLOCK POSITION' HAS BEEN ENTERED
595800200529      *
595900200529     C     #1BLOP        IFNE      *BLANKS                                      B*1
596000200529      *
596100200529      **   'BLOCK POSITION' MUST BE EQUAL TO 'E', 'W' OR 'N'
596200200529      *
596300200529     C     #1BLOP        IFNE      'E'                                          B*2
596400200529     C     #1BLOP        ANDNE     'W'
596500200529     C     #1BLOP        ANDNE     'N'
596600200529     C                   MOVE      'Y'           ERROR
596700200529     C                   MOVE      '1'           *IN72                          Reverse image
596800200529     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
596900200529     C                   EXSR      ZASNMS                                       Send message
597000200529     C                   ENDIF                                                  E*2
597100200529     C                   ELSE                                                   X*1
597200200529     C                   MOVE      'N'           #1BLOP
597300200529     C                   ENDIF                                                  E*1
597400200529      *
597500200529     C     #1BLOP        IFEQ      'E'                                          B*1
597600200529     C     #1BLOP        ANDEQ     'W'
597700200529     C     #1BLOS        OREQ      'E'
597800200529     C     #1BLOS        ANDEQ     'W'
597900200529      *
598000200529     C     #1BFRD        IFEQ      *BLANKS                                      B*2
598100200529     C                   MOVE      #1EXDT        #1BFRD
598200200529     C                   MOVE      #1EXDT        #2BFRD
598300200529     C                   ENDIF                                                  E*2
598400200529      *
598500200529     C     #1BEND        IFEQ      *BLANKS                                      B*2
598600200529     C                   MOVE      #1ALEF        #1BEND
598700200529     C                   MOVE      #1ALEF        #2BEND
598800200529     C                   ENDIF                                                  E*2
598900200529     C                   ENDIF                                                  E*1
599000200529      *
599100200529     C                   Z-ADD     *ZEROS        W1BFRD            5 0
599200200529      *
599300200529      **   IF 'BLOCK FROM DATE' HAS BEEN ENTERED
599400200529      *
599500200529     C     #1BFRD        IFNE      *BLANKS                                      B*1
599600200529      *
599700200529      **   'BLOCK FROM DATE' MUST NOT BEEN ENTERED IF BLOCK INDICATORS 'N'
599800200529      *
599900200529     C     #1BLOP        IFEQ      'N'                                          B*2
600000200529     C     #1BLOS        ANDEQ     'N'
600100200529     C                   MOVE      'Y'           ERROR
600200200529     C                   MOVE      '1'           *IN73                          Reverse image
600300200529     C                   MOVEL     'CO00046'     ZAMSID                         Message id.
600400200529     C                   EXSR      ZASNMS                                       Send message
600500200529     C                   ELSE                                                   X*2
600600200529      *
600700200529     C                   MOVE      #1BFRD        ZDATE
600800200529     C                   EXSR      ZDATE1
600900200529     C                   Z-ADD     ZDAYNO        W1BFRD
601000200529      *
601100200529      **   IF 'BLOCK FROM DATE' IS NOT A VALID DATE FORMAT
601200200529      *
601300200529     C     *IN99         IFEQ      '1'                                          B*3
601400200529     C                   MOVE      'Y'           ERROR
601500200529     C                   MOVE      '1'           *IN73                          Reverse image
601600200529     C                   MOVEL     'CO00048'     ZAMSID                         Message id.
601700200529     C                   EXSR      ZASNMS                                       Send message
601800200529     C                   ELSE                                                   X*3
601900200529      *
602000200529      **   'BLOCK FROM DATE' MUST BE GREATER THAN RUN DATE
602100200529      *
602200200529     C     ZDAYNO        IFLE      BJRDNB                                       B*4
602300200529     C                   MOVE      'Y'           ERROR
602400200529     C                   MOVE      '1'           *IN73                          Reverse image
602500200529     C                   MOVEL     'CO00050'     ZAMSID                         Message id.
602600200529     C                   EXSR      ZASNMS                                       Send message
602700200529     C                   ENDIF                                                  E*4
602800200529     C                   ENDIF                                                  E*3
602900200529     C                   ENDIF                                                  E*2
603000200529     C                   ELSE                                                   X*1
603100200529      *
603200200529      **   'BLOCK FROM DATE' MUST BE ENTERED IF BLOCK POSITION IS 'E' OR 'W
603300200529      *
603400200529     C     #1BLOP        IFEQ      'E'                                          B*2
603500200529     C     #1BLOP        OREQ      'W'
603600200529     C     #1BLOS        OREQ      'E'
603700200529     C     #1BLOS        OREQ      'W'
603800200529     C     #1BEND        IFEQ      *BLANKS                                      B*3            13693
603900200529     C                   MOVE      'Y'           ERROR
604000200529     C                   MOVE      '1'           *IN73                          Reverse image
604100200529     C                   MOVEL     'CO00243'     ZAMSID                         Message id.
604200200529     C                   EXSR      ZASNMS                                       Send message
604300200529     C                   ENDIF                                                  E*3            13693
604400200529     C                   ENDIF                                                  E*2
604500200529     C                   ENDIF                                                  E*1
604600200529      *
604700200529      **   IF 'BLOCK END DATE' HAS BEEN ENTERED
604800200529      *
604900200529     C     #1BEND        IFNE      *BLANKS                                      B*1
605000200529      *
605100200529      **   'BLOCK END DATE' MUST NOT BEEN ENTERED IF BLOCK INDICATORS 'N'
605200200529      *
605300200529     C     #1BLOP        IFEQ      'N'                                          B*2
605400200529     C     #1BLOS        ANDEQ     'N'
605500200529     C                   MOVE      'Y'           ERROR
605600200529     C                   MOVE      '1'           *IN74                          Reverse image
605700200529     C                   MOVEL     'CO00047'     ZAMSID                         Message id.
605800200529     C                   EXSR      ZASNMS                                       Send message
605900200529     C                   ELSE                                                   X*2
606000200529      *
606100200529     C                   MOVE      #1BEND        ZDATE
606200200529     C                   EXSR      ZDATE1
606300200529      *
606400200529      **   IF 'BLOCK END DATE' IS NOT A VALID DATE FORMAT
606500200529      *
606600200529     C     *IN99         IFEQ      '1'                                          B*3
606700200529     C                   MOVE      'Y'           ERROR
606800200529     C                   MOVE      '1'           *IN74                          Reverse image
606900200529     C                   MOVEL     'CO00049'     ZAMSID                         Message id.
607000200529     C                   EXSR      ZASNMS                                       Send message
607100200529     C                   ELSE                                                   X*3
607200200529      *
607300200529      **   'BLOCK END DATE' MUST BE GREATER THAN RUN DATE/FROM DATE
607400200529      **   AND BEFORE MATURITY DATE OF THE SECURITY
607500200529      *
607600200529     C     ZDAYNO        IFLE      BJRDNB                                       B*4
607700200529     C     ZDAYNO        ORLE      W1BFRD
607800200529     C     ZDAYNO        ORGE      MATY
607900200529     C     MATY          ANDNE     *ZEROS
608000200529     C                   MOVE      'Y'           ERROR
608100200529     C                   MOVE      '1'           *IN74                          Reverse image
608200200529     C                   MOVEL     'CO00051'     ZAMSID                         Message id.
608300200529     C                   EXSR      ZASNMS                                       Send message
608400200529     C                   ENDIF                                                  E*4
608500200529     C                   ENDIF                                                  E*3
608600200529     C                   ENDIF                                                  E*2
608700200529      *
608800200529     C                   ELSE                                                   X*1
608900200529      *
609000200529      **   'BLOCK END DATE' MUST BE ENTERED IF BLOCK POSITION IS 'E' OR 'W'
609100200529      *
609200200529     C     #1BLOP        IFEQ      'E'                                          B*2
609300200529     C     #1BLOP        OREQ      'W'
609400200529     C     #1BLOS        OREQ      'E'
609500200529     C     #1BLOS        OREQ      'W'
609600200529     C     #1BFRD        IFEQ      *BLANKS                                      B*3            13693
609700200529     C                   MOVE      'Y'           ERROR
609800200529     C                   MOVE      '1'           *IN74                          Reverse image
609900200529     C                   MOVEL     'CO00244'     ZAMSID                         Message id.
610000200529     C                   EXSR      ZASNMS                                       Send message
610100200529     C                   ENDIF                                                  E*3            13693
610200200529     C                   ENDIF                                                  E*2
610300200529     C                   ENDIF                                                  E*1
610400200529                                                                                              CGL031
610500200529      ** Validate Subject to European Tax if CGL031 is enabled.                               CGL031
610600200529                                                                                              CGL031
610700200529     C                   IF        CGL031 = 'Y'                                               CGL031
610800200529                                                                                              CGL031
610900200529     C                   IF        #1SETX = *BLANK                                            CGL031
611000200529                                                                                              CGL031
611100200529     C                   IF        #1COAT = 'DI'                                              CGL031
611200200529     C                   EVAL      #1SETX = SETX                                              CGL031
611300200529     C                   ELSE                                                                 CGL031
611400200529                                                                                              CGL031
611500200529      ** Subject to European Tax is mandatory.                                                CGL031
611600200529                                                                                              CGL031
611700200529     C                   EVAL      ERROR = 'Y'                                                CGL031
611800200529     C                   EVAL      *IN07 = *ON                                                CGL031
611900200529     C                   EVAL      ZAMSID = 'SEA0907'                                         CGL031
612000200529     C                   EXSR      ZASNMS                                                     CGL031
612100200529     C                   ENDIF                                                                CGL031
612200200529                                                                                              CGL031
612300200529     C                   ELSE                                                                 CGL031
612400200529                                                                                              CGL031
612500200529     C                   IF        #1SETX <> 'Y' AND                                          CGL031
612600200529     C                             #1SETX <> 'N'                                              CGL031
612700200529                                                                                              CGL031
612800200529      ** Subject to European Tax must be 'Y' or 'N'.                                          CGL031
612900200529                                                                                              CGL031
613000200529     C                   EVAL      ERROR = 'Y'                                                CGL031
613100200529     C                   EVAL      *IN07 = *ON                                                CGL031
613200200529     C                   EVAL      ZAMSID = 'SEA0908'                                         CGL031
613300200529     C                   EXSR      ZASNMS                                                     CGL031
613400200529     C                   ENDIF                                                                CGL031
613500200529                                                                                              CGL031
613600200529     C                   ENDIF                                                                CGL031
613700200529                                                                                              CGL031
613800200529     C                   ENDIF                                                                CGL031
613900200529      *
614000200529      **   IF 'NUMBER OF OPTIONS' GREATER THAN 1
614100200529      *
614200200529     C     *IN26         IFEQ      '0'                                          B*1
614300200529      *
614400200529      **   'REFUSE OFFER' MUST BE EQUAL TO 'Y' OR 'N'
614500200529      *
614600200529     C     #1REFO        IFNE      'Y'                                          B*2
614700200529     C     #1REFO        ANDNE     'N'
614800200529     C                   MOVE      'Y'           ERROR
614900200529     C                   MOVE      '1'           *IN76                          Reverse image
615000200529     C                   MOVEL     'CO00053'     ZAMSID                         Message id.
615100200529     C                   EXSR      ZASNMS                                       Send message
615200200529     C                   ENDIF                                                  E*2
615300200529      *
615400200529      **   VALIDATE 'CUSTOMER OPTION NARRATIVE'
615500200529      *
615600200529     C     #1CONR        IFEQ      *BLANKS                                      B*2
615700200529      *
615800200529      **   'CUSTOMER OPTION NARRATIVE' MANDATORY IF REFUSE OFFER 'Y'
615900200529      *
616000200529     C     #1REFO        IFEQ      'Y'                                          B*3
616100200529     C                   MOVE      'Y'           ERROR
616200200529     C                   MOVE      '1'           *IN77                          Reverse image
616300200529     C                   MOVEL     'CO00054'     ZAMSID                         Message id.
616400200529     C                   EXSR      ZASNMS                                       Send message
616500200529     C                   ENDIF                                                  E*3
616600200529      *
616700200529     C                   ELSE                                                   X*2
616800200529      *
616900200529      **   'CUSTOMER OPTION NARRATIVE' MUST REFER TO A VALID LIVE CODE
617000200529      *
617100200529     C     #1CONR        CHAIN     SECONAL0                           89
617200200529     C     *IN89         IFEQ      '1'                                          B*3
617300200529     C     MNRECI        ORNE      'D'
617400200529     C                   MOVE      'Y'           ERROR
617500200529     C                   MOVE      '1'           *IN77                          Reverse image
617600200529     C                   MOVEL     'CO00055'     ZAMSID                         Message id.
617700200529     C                   EXSR      ZASNMS                                       Send message
617800200529     C                   ENDIF                                                  E*3
617900200529     C                   ENDIF                                                  E*2
618000200529      *
618100200529      **   'DEFAULT FOR NO REPLY' MUST BE EQUAL TO ONE OF THE CUSTOMER OPTIONS
618200200529      *
618300200529     C     #1DFNR        IFNE      '1'                                          B*2
618400200529     C     #1DFNR        ANDNE     '2'
618500200529     C     #1DFNR        ANDNE     '3'
618600200529     C     #1DFNR        ANDNE     '4'
618700200529     C     #1DFNR        ANDNE     '5'
618800200529     C     #1DFNR        ANDNE     '6'
618900200529     C     #1DFNR        ANDNE     '7'
619000200529     C     #1DFNR        ANDNE     '8'
619100200529     C     #1DFNR        ANDNE     '9'
619200200529     C     #1DFNR        ANDNE     ' '
619300200529     C                   MOVE      'Y'           ERROR
619400200529     C                   MOVE      '1'           *IN78                          Reverse image
619500200529     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
619600200529     C                   EXSR      ZASNMS                                       Send message
619700200529     C                   ELSE                                                   X*2
619800200529     C                   MOVE      #1REFN        KCORF
619900200529     C                   Z-ADD     *ZEROS        KOPTN
620000200529     C                   MOVE      #1DFNR        KOPTN
620100200529      *
620200200529     C     #1PTYP        IFNE      'NC'                                         B*3
620300200529     C     #1PTYP        ANDNE     'NF'
620400200529     C     #1PTYP        ANDNE     'CC'                                                        CEU01
620500200529     C                   EXSR      P024
620600200529     C                   ELSE                                                   X*3
620700200529     C                   MOVE      '0'           *IN89
620800200529     C                   ENDIF                                                  E*3
620900200529      *
621000200529     C     *IN89         IFEQ      '1'                                          B*3
621100200529     C     #1PTYP        OREQ      'NC'
621200200529     C     #1DFNR        ANDNE     '1'
621300200529     C     #1PTYP        OREQ      'NF'
621400200529     C     #1DFNR        ANDNE     '1'
621500200529     C     #1PTYP        OREQ      'CC'                                                        CEU01
621600200529     C     #1DFNR        ANDNE     '1'                                                         CEU01
621700200529     C                   MOVE      'Y'           ERROR
621800200529     C                   MOVE      '1'           *IN78                          Reverse image
621900200529     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
622000200529     C                   EXSR      ZASNMS                                       Send message
622100200529     C                   ENDIF                                                  E*3
622200200529     C                   ENDIF                                                  E*2
622300200529      *
622400200529      **   'DEFAULT FOR CASH PREFERRED' MUST BE EQUAL TO ONE OF THE CUSTOMER OPT
622500200529      *
622600200529     C     #1DFCP        IFNE      '1'                                          B*2
622700200529     C     #1DFCP        ANDNE     '2'
622800200529     C     #1DFCP        ANDNE     '3'
622900200529     C     #1DFCP        ANDNE     '4'
623000200529     C     #1DFCP        ANDNE     '5'
623100200529     C     #1DFCP        ANDNE     '6'
623200200529     C     #1DFCP        ANDNE     '7'
623300200529     C     #1DFCP        ANDNE     '8'
623400200529     C     #1DFCP        ANDNE     '9'
623500200529     C     #1DFCP        ANDNE     ' '
623600200529     C                   MOVE      'Y'           ERROR
623700200529     C                   MOVE      '1'           *IN79                          Reverse image
623800200529     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
623900200529     C                   EXSR      ZASNMS                                       Send message
624000200529     C                   ELSE                                                   X*2
624100200529     C                   MOVE      #1REFN        KCORF
624200200529     C                   Z-ADD     *ZEROS        KOPTN
624300200529     C                   MOVE      #1DFCP        KOPTN
624400200529      *
624500200529     C     #1PTYP        IFNE      'NC'                                         B*3
624600200529     C     #1PTYP        ANDNE     'NF'
624700200529     C     #1PTYP        ANDNE     'CC'                                                        CEU01
624800200529     C                   EXSR      P024
624900200529     C                   ELSE                                                   X*3
625000200529     C                   MOVE      '0'           *IN89
625100200529     C                   ENDIF                                                  E*3
625200200529      *
625300200529     C     *IN89         IFEQ      '1'                                          B*3
625400200529     C     #1PTYP        OREQ      'NC'
625500200529     C     #1DFCP        ANDNE     '1'
625600200529     C     #1PTYP        OREQ      'NF'
625700200529     C     #1DFCP        ANDNE     '1'
625800200529     C     #1PTYP        OREQ      'CC'                                                        CEU01
625900200529     C     #1DFCP        ANDNE     '1'                                                         CEU01
626000200529     C                   MOVE      'Y'           ERROR
626100200529     C                   MOVE      '1'           *IN79                          Reverse image
626200200529     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
626300200529     C                   EXSR      ZASNMS                                       Send message
626400200529     C                   ENDIF                                                  E*3
626500200529     C                   ENDIF                                                  E*2
626600200529      *
626700200529      **   'DEFAULT FOR STOCK PREFERRED' MUST BE EQUAL TO ONE OF THE CUSTOMER OP
626800200529      *
626900200529     C     #1DFSP        IFNE      '1'                                          B*2
627000200529     C     #1DFSP        ANDNE     '2'
627100200529     C     #1DFSP        ANDNE     '3'
627200200529     C     #1DFSP        ANDNE     '4'
627300200529     C     #1DFSP        ANDNE     '5'
627400200529     C     #1DFSP        ANDNE     '6'
627500200529     C     #1DFSP        ANDNE     '7'
627600200529     C     #1DFSP        ANDNE     '8'
627700200529     C     #1DFSP        ANDNE     '9'
627800200529     C     #1DFSP        ANDNE     ' '
627900200529     C                   MOVE      'Y'           ERROR
628000200529     C                   MOVE      '1'           *IN82                          Reverse image
628100200529     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
628200200529     C                   EXSR      ZASNMS                                       Send message
628300200529     C                   ELSE                                                   X*2
628400200529     C                   MOVE      #1REFN        KCORF
628500200529     C                   Z-ADD     *ZEROS        KOPTN
628600200529     C                   MOVE      #1DFSP        KOPTN
628700200529      *
628800200529     C     #1PTYP        IFNE      'NC'                                         B*3
628900200529     C     #1PTYP        ANDNE     'NF'
629000200529     C     #1PTYP        ANDNE     'CC'                                                        CEU01
629100200529     C                   EXSR      P024
629200200529     C                   ELSE                                                   X*3
629300200529     C                   MOVE      '0'           *IN89
629400200529     C                   ENDIF                                                  E*3
629500200529      *
629600200529     C     *IN89         IFEQ      '1'                                          B*3
629700200529     C     #1PTYP        OREQ      'NC'
629800200529     C     #1DFSP        ANDNE     '1'
629900200529     C     #1PTYP        OREQ      'NF'
630000200529     C     #1DFSP        ANDNE     '1'
630100200529     C     #1PTYP        OREQ      'CC'                                                        CEU01
630200200529     C     #1DFSP        ANDNE     '1'                                                         CEU01
630300200529     C                   MOVE      'Y'           ERROR
630400200529     C                   MOVE      '1'           *IN82                          Reverse image
630500200529     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
630600200529     C                   EXSR      ZASNMS                                       Send message
630700200529     C                   ENDIF                                                  E*3
630800200529     C                   ENDIF                                                  E*2
630900200529     C                   ENDIF                                                  E*1
631000200529      *
631100200529      **   IF NO ERROR DETECTED
631200200529      *
631300200529     C     ERROR         IFEQ      'N'                                          B*1
631400200529     C/COPY WNCPYSRC,SE7502C063
631500200529      *
631600200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
631700200529      *
631800200529     C     #1REFN        CHAIN     SECORFL0                           88
631900200529      *
632000200529     C                   MOVE      'D'           MARECI
632100200529     C                   Z-ADD     BJRDNB        MALCD
632200200529     C                   MOVE      'A'           MACHTP
632300200529     C                   MOVE      ##USR         MALUID
632400200529      *
632500200529     C     *INKK         IFEQ      '0'                                          B*2            15668
632600200529     C                   MOVE      *BLANKS       MAJOBN
632700200529     C                   MOVE      *BLANKS       MAUSER
632800200529     C                   Z-ADD     *ZEROS        MAJNBR
632900200529     C                   ENDIF                                                  E*2            15668
633000200529      *
633100200529     C                   Z-ADD     WCOPD         MACOPD
633200200529     C                   Z-ADD     WTDDT         MATDDT
633300200529     C                   MOVE      #1TDVD        MATDVD
633400200529     C                   Z-ADD     WCOPD         MACOPD
633500200529     C                   Z-ADD     WTDDT         MATDDT
633600200529     C                   Z-ADD     WEVDT         MAEVDT
633700200529     C                   MOVE      #1CPNB        MACPNB
633800200529      *
633900200529     C                   MOVE      #1SHMD        ZDATE
634000200529     C                   EXSR      ZDATE1
634100200529     C                   Z-ADD     ZDAYNO        MASHMD
634200200529      *
634300200529     C                   MOVE      #1LTBS        MALTBS
634400200529      *
634500200529     C                   MOVE      *BLANKS       ZFLD17
634600200529     C                   MOVEL     #1OCPV        ZFLD17
634700200529     C     15            SUB       NMDP          ZSDIG
634800200529     C                   Z-ADD     NMDP          ZSDEC
634900200529     C                   EXSR      ZASIGN
635000200529     C                   MOVE      ZOUT15        WOUT15           15 0
635100200529      *
635200200529     C     ZFSIGN        IFEQ      '+'                                          B*1
635300200529     C                   Z-ADD     WOUT15        MAOCPV
635400200529     C                   ELSE                                                   X*1
635500200529     C                   Z-SUB     WOUT15        MAOCPV
635600200529     C                   ENDIF                                                  E*1
635700200529      *
635800200529     C                   MOVE      *BLANKS       ZFLD17
635900200529     C                   MOVEL     #1NCPV        ZFLD17
636000200529     C     15            SUB       NMDP          ZSDIG
636100200529     C                   Z-ADD     NMDP          ZSDEC
636200200529     C                   EXSR      ZASIGN
636300200529     C                   MOVE      ZOUT15        WOUT15
636400200529      *
636500200529     C     ZFSIGN        IFEQ      '+'                                          B*1
636600200529     C                   Z-ADD     WOUT15        MANCPV
636700200529     C                   ELSE                                                   X*1
636800200529     C                   Z-SUB     WOUT15        MANCPV
636900200529     C                   ENDIF                                                  E*1
637000200529      *
637100200529     C                   MOVE      *BLANKS       ZFLD17
637200200529     C                   MOVEL     #1ONML        ZFLD17
637300200529     C     15            SUB       NMDP          ZSDIG
637400200529     C                   Z-ADD     NMDP          ZSDEC
637500200529     C                   EXSR      ZASIGN
637600200529     C                   MOVE      ZOUT15        WOUT15
637700200529      *
637800200529     C     ZFSIGN        IFEQ      '+'                                          B*1
637900200529     C                   Z-ADD     WOUT15        MAONML
638000200529     C                   ELSE                                                   X*1
638100200529     C                   Z-SUB     WOUT15        MAONML
638200200529     C                   ENDIF                                                  E*1
638300200529      *
638400200529     C                   MOVE      *BLANKS       ZFLD17
638500200529     C                   MOVEL     #1NNML        ZFLD17
638600200529     C     15            SUB       NMDP          ZSDIG
638700200529     C                   Z-ADD     NMDP          ZSDEC
638800200529     C                   EXSR      ZASIGN
638900200529     C                   MOVE      ZOUT15        WOUT15
639000200529      *
639100200529     C     ZFSIGN        IFEQ      '+'                                          B*1
639200200529     C                   Z-ADD     WOUT15        MANNML
639300200529     C                   ELSE                                                   X*1
639400200529     C                   Z-SUB     WOUT15        MANNML
639500200529     C                   ENDIF                                                  E*1
639600200529      *
639700200529     C                   MOVE      *BLANKS       ZFIELD
639800200529     C                   MOVEL     #1CUPC        ZFIELD
639900200529     C                   Z-ADD     7             ZADIG
640000200529     C                   Z-ADD     8             ZADEC
640100200529     C                   EXSR      ZALIGN
640200200529     C                   MOVE      ZFIELD        MACUPC
640300200529      *
640400200529     C                   MOVE      *BLANKS       ZFIELD
640500200529     C                   MOVEL     #1EXPC        ZFIELD
640600200529     C                   Z-ADD     7             ZADIG
640700200529     C                   Z-ADD     8             ZADEC
640800200529     C                   EXSR      ZALIGN
640900200529     C                   MOVE      ZFIELD        MAEXPC
641000200529      *
641100200529     C                   MOVE      #1CLRD        ZDATE
641200200529     C                   EXSR      ZDATE1
641300200529     C                   Z-ADD     ZDAYNO        MACLRD
641400200529      *
641500200529     C                   MOVE      #1CLRT        MACLRT
641600200529      *
641700200529     C                   MOVE      #1DLRD        ZDATE
641800200529     C                   EXSR      ZDATE1
641900200529     C                   Z-ADD     ZDAYNO        MADLRD
642000200529      *
642100200529     C                   MOVE      #1DLRT        MADLRT
642200200529     C                   MOVE      #1BLOS        MABLOS
642300200529     C                   MOVE      #1BLOP        MABLOP
642400200529      *
642500200529     C                   MOVE      #1BFRD        ZDATE
642600200529     C                   EXSR      ZDATE1
642700200529     C                   Z-ADD     ZDAYNO        MABFRD
642800200529      *
642900200529     C     #1BEND        IFNE      *BLANKS                                                     13693
643000200529     C                   MOVE      #1BEND        ZDATE
643100200529     C                   EXSR      ZDATE1
643200200529     C                   Z-ADD     ZDAYNO        MABEND
643300200529     C                   ELSE                                                                  13693
643400200529     C     #1BLOS        IFEQ      'E'                                                         13693
643500200529     C     #1BLOS        OREQ      'W'                                                         13693
643600200529     C     #1BLOP        OREQ      'E'                                                         13693
643700200529     C     #1BLOP        OREQ      'W'                                                         13693
643800200529     C                   Z-ADD     *HIVAL        MABEND                                        13693
643900200529     C                   ELSE                                                                  13693
644000200529     C                   Z-ADD     *ZEROS        MABEND                                        13693
644100200529     C                   ENDIF                                                                 13693
644200200529     C                   ENDIF                                                                 13693
644300200529      *                                                                                       CGL031
644400200529      ** Move relevant screen fields to file fields if CGL031 is enabled.                     CGL031
644500200529      *                                                                                       CGL031
644600200529     C                   IF        CGL031 = 'Y'                                               CGL031
644700200529     C                   EVAL      MASETX = #1SETX                                            CGL031
644800200529     C                   ELSE                                                                 CGL031
644900200529     C                   EVAL      MASETX = *BLANK                                            CGL031
645000200529     C                   ENDIF                                                                CGL031
645100200529      *
645200200529     C                   MOVE      #1REFO        MAREFO
645300200529     C                   MOVE      #1CONR        MACONR
645400200529     C                   MOVE      #1DFNR        MADFNR
645500200529     C                   MOVE      #1DFCP        MADFCP
645600200529     C                   MOVE      #1DFSP        MADFSP
645700200529      *
645800200529      **   BLOCKING PROCESSING
645900200529      *
646000200529     C     #1BLOS        IFNE      #2BLOS                                       B*2
646100200529     C     #1BFRD        ORNE      #2BFRD
646200200529     C     #1BEND        ORNE      #2BEND
646300200529     C                   EXSR      P020
646400200529     C                   ENDIF                                                  E*2
646500200529      *
646600200529     C                   UPDATE    SECORFD0
646700200529     C                   MOVE      FIELD         #FIELD
646800200529      *
646900200529      **   ADD COMMITMENT INSTRUCTION
647000200529      *
647100200529     C                   COMMIT
647200200529      *
647300200529     C                   ENDIF                                                  E*1
647400200529      *
647500200529     C                   ENDSR
647600200529      *****************************************************************
647700200529      /EJECT
647800200529      *****************************************************************
647900200529      * P020  : BLOCKING PROCESSING                                   *
648000200529      *****************************************************************
648100200529      *
648200200529     C     P020          BEGSR
648300200529      *
648400200529      **   ACCESS BLOCKING FILE WITH THE CORPORATE ACTION REFERENCE
648500200529      *
648600200529     C     MACORF        CHAIN     SECOBKL2                           89
648700200529      *
648800200529      **   IF BLOCK EXISTS, REVERSE THE CURRENT BLOCKING RECORD
648900200529      *
649000200529     C     *IN89         IFEQ      '0'                                          B*1
649100200529     C                   MOVE      '*'           MURECI
649200200529     C                   UPDATE    SECOBKD2
649300200529     C                   ENDIF                                                  E*1
649400200529      *                                                                   149983
649500200529      **   ACCESS BLOCKING FILE WITH THE CORPORATE ACTION REFERENCE       149983
649600200529      *                                                                   149983
649700200529     C     MACORF        CHAIN     SECOBKL2                           89                       14998
649800200529      *                                                                   149983
649900200529      **   IF BLOCK EXISTS, REVERSE THE CURRENT BLOCKING RECORD           149983
650000200529      *                                                                   149983
650100200529     C     *IN89         IFEQ      '0'                                          B*1            14998
650200200529     C                   MOVE      '*'           MURECI                                        14998
650300200529     C                   UPDATE    SECOBKD2                                                    14998
650400200529     C                   ENDIF                                                  E*1            14998
650500200529      *
650600200529      **   CREATE THE NEW BLOCKING RECORD IF BLOCK POSITION 'E' OR'W'
650700200529      *
650800200529     C     MABLOS        IFEQ      'E'                                          B*1
650900200529     C     MABLOS        OREQ      'W'
651000200529     C                   MOVE      'D'           MURECI
651100200529     C                   Z-ADD     BJRDNB        MULCD
651200200529     C                   MOVE      'I'           MUCHTP
651300200529     C                   MOVE      ##USR         MULUID
651400200529     C                   MOVE      BVBRCD        MUBRCD
651500200529     C**********         Z-ADD     *ZEROS        MUCNUM                                       CSD027
651600200529     C                   EVAL      MUCNUM = *BLANKS                                           CSD027
651700200529     C                   MOVE      *BLANKS       MUPTFR
651800200529     C                   MOVE      'P'           MUBLTY
651900200529     C                   MOVE      MASESN        MUSESN
652000200529     C                   MOVE      MABEND        MUBEDT
652100200529     C                   Z-ADD     *ZEROS        MUNOMB
652200200529      *
652300200529     C                   MOVEL     MACOAT        WWBNAR            9
652400200529     C                   MOVE      MACORF        WWBNAR
652500200529     C                   MOVEL     WWBNAR        MUBNAR
652600200529      *
652700200529     C                   Z-ADD     1             MUSEQN
652800200529     C                   MOVE      MABFRD        MUBSTT
652900200529     C                   MOVE      MABLOS        MUBEWI
653000200529     C                   MOVE      MACORF        MUCORF
653100200529     C                   WRITE     SECOBKD2
653200200529     C                   MOVE      'S'           MUBLTY                                        14998
653300200529     C                   WRITE     SECOBKD2                                                    14998
653400200529     C                   ENDIF                                                  E*1
653500200529      *
653600200529     C                   ENDSR
653700200529      *****************************************************************
653800200529      /EJECT
653900200529      *****************************************************************
654000200529      * P021  : RETRIEVE NEXT AVAILABLE REFERENCE NUMBER              *
654100200529      *****************************************************************
654200200529      *
654300200529     C     P021          BEGSR
654400200529      *
654500200529      **   SETUP "REFERENCE" FIELD WITH NEXT AVAILABLE NUMBER
654600200529      *
654700200529     C                   MOVE      WWCORF        #1REFN
654800200529     C                   ADD       1             WWCORF
654900200529      *
655000200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
655100200529      *
655200200529     C***********#1REFN    CHAINSECORFL1             88                   136421
655300200529     C     #1REFN        CHAIN     SECORFL9                           88                       13642
655400200529      *
655500200529      **   IF A RECORD IS FOUND
655600200529      *
655700200529     C     *IN88         DOWEQ     '0'                                          B*1
655800200529      *
655900200529     C                   MOVE      WWCORF        #1REFN
656000200529     C                   ADD       1             WWCORF
656100200529      *
656200200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
656300200529      *
656400200529     C***********#1REFN    CHAINSECORFL1             88                   136421
656500200529     C     #1REFN        CHAIN     SECORFL9                           88                       13642
656600200529     C                   ENDDO                                                  E*1
656700200529      *
656800200529     C                   MOVE      #1BLOS        #2BLOS
656900200529     C                   MOVE      #1BEND        #2BEND
657000200529     C                   MOVE      #1BFRD        #2BFRD
657100200529      *
657200200529     C                   ENDSR
657300200529      ****************************************************************
657400200529      /EJECT
657500200529      *****************************************************************
657600200529      * P022  : APPLY ACTION TO ALL OPTIONS                           *
657700200529      *****************************************************************
657800200529      *
657900200529     C     P022          BEGSR
658000200529      *
658100200529     C     #1PTYP        IFEQ      'DV'                                         B*1
658200200529     C     #1REFN        SETLL     SECODVL0
658300200529     C     #1REFN        READE     SECODVL0                               89
658400200529      *
658500200529     C                   ELSE                                                   X*1
658600200529     C     #1PTYP        IFEQ      'FR'                                         B*2
658700200529     C     #1REFN        SETLL     SECOFRL0
658800200529     C     #1REFN        READE     SECOFRL0                               89
658900200529      *
659000200529     C                   ELSE                                                   X*2
659100200529     C     #1PTYP        IFEQ      'CE'                                         B*3
659200200529     C     #1REFN        SETLL     SECOCEL0
659300200529     C     #1REFN        READE     SECOCEL0                               89
659400200529      *
659500200529     C                   ELSE                                                   X*3
659600200529     C     #1PTYP        IFEQ      'CR'                                         B*4
659700200529     C     #1REFN        SETLL     SECOCRL0
659800200529     C     #1REFN        READE     SECOCRL0                               89
659900200529      *
660000200529     C                   ELSE                                                   X*4
660100200529     C     #1PTYP        IFEQ      'OF'                                         B*5
660200200529     C     #1REFN        SETLL     SECOOFL0
660300200529     C     #1REFN        READE     SECOOFL0                               89
660400200529      *
660500200529     C                   ELSE                                                   X*5
660600200529     C     #1PTYP        IFEQ      'RG'                                         B*6
660700200529     C     #1REFN        SETLL     SECORGL0
660800200529     C     #1REFN        READE     SECORGL0                               89
660900200529      *
661000200529     C                   ELSE                                                   X*6
661100200529     C     #1PTYP        IFEQ      'EX'                                         B*7
661200200529     C     #1REFN        SETLL     SECOEXL0
661300200529     C     #1REFN        READE     SECOEXL0                               89
661400200529      *
661500200529     C                   ELSE                                                   X*7
661600200529     C     #1PTYP        IFEQ      'NC'                                         B*8
661700200529     C     #1REFN        SETLL     SECONCL0
661800200529     C     #1REFN        READE     SECONCL0                               89
661900200529      *
662000200529     C                   ELSE                                                   X*8
662100200529     C     #1PTYP        IFEQ      'NF'                                         B*9
662200200529     C     #1REFN        SETLL     SECONFL0
662300200529     C     #1REFN        READE     SECONFL0                               89
662400200529      *                                                                   CEU017
662500200529     C                   ELSE                                                   X*9            CEU01
662600200529     C     #1PTYP        IFEQ      'CC'                                         B*10           CEU01
662700200529     C     #1REFN        SETLL     SECOCCL0                                                    CEU01
662800200529     C     #1REFN        READE     SECOCCL0                               89                   CEU01
662900200529     C/COPY WNCPYSRC,SE7502C048
663000200529     C                   ENDIF                                                  E*10           CEU01
663100200529     C                   ENDIF                                                  E*9
663200200529     C                   ENDIF                                                  E*8
663300200529     C                   ENDIF                                                  E*7
663400200529     C                   ENDIF                                                  E*6
663500200529     C                   ENDIF                                                  E*5
663600200529     C                   ENDIF                                                  E*4
663700200529     C                   ENDIF                                                  E*3
663800200529     C                   ENDIF                                                  E*2
663900200529     C                   ENDIF                                                  E*1
664000200529      *
664100200529     C     *IN89         DOWEQ     '0'                                          B*1
664200200529      *
664300200529     C     #1PTYP        IFEQ      'DV'                                         B*2
664400200529     C     #1SEL         IFEQ      'D'                                          B*3
664500200529     C                   DELETE    SECODVD0
664600200529     C                   ENDIF                                                  E*3
664700200529     C     #1REFN        READE     SECODVL0                               89
664800200529      *
664900200529     C                   ELSE                                                   X*2
665000200529      *
665100200529     C     #1PTYP        IFEQ      'FR'                                         B*3
665200200529      *
665300200529     C     #1SEL         IFEQ      'D'                                          B*3
665400200529     C                   DELETE    SECOFRD0
665500200529     C                   ENDIF                                                  E*3
665600200529     C     #1REFN        READE     SECOFRL0                               89
665700200529      *
665800200529     C                   ELSE                                                   X*3
665900200529     C     #1PTYP        IFEQ      'CE'                                         B*4
666000200529     C     #1SEL         IFEQ      'D'                                          B*3
666100200529     C                   DELETE    SECOCED0
666200200529     C                   ENDIF                                                  E*3
666300200529     C     #1REFN        READE     SECOCEL0                               89
666400200529      *
666500200529     C                   ELSE                                                   X*4
666600200529     C     #1PTYP        IFEQ      'CR'                                         B*5
666700200529     C     #1SEL         IFEQ      'D'                                          B*3
666800200529     C                   DELETE    SECOCRD0
666900200529     C                   ELSE                                                   X*3
667000200529     C                   ENDIF                                                  E*3
667100200529     C     #1REFN        READE     SECOCRL0                               89
667200200529      *
667300200529     C                   ELSE                                                   X*5
667400200529     C     #1PTYP        IFEQ      'OF'                                         B*6
667500200529     C     #1SEL         IFEQ      'D'                                          B*3
667600200529     C                   DELETE    SECOOFD0
667700200529     C                   ENDIF                                                  E*3
667800200529     C     #1REFN        READE     SECOOFL0                               89
667900200529      *
668000200529     C                   ELSE                                                   X*6
668100200529     C     #1PTYP        IFEQ      'RG'                                         B*7
668200200529     C     #1SEL         IFEQ      'D'                                          B*3
668300200529     C                   DELETE    SECORGD0
668400200529     C                   ENDIF                                                  E*3
668500200529     C     #1REFN        READE     SECORGL0                               89
668600200529      *
668700200529     C                   ELSE                                                   X*7
668800200529      *
668900200529     C     #1PTYP        IFEQ      'EX'                                         B*8
669000200529     C     #1SEL         IFEQ      'D'                                          B*3
669100200529     C                   DELETE    SECOEXD0
669200200529     C                   ENDIF                                                  E*3
669300200529      *
669400200529     C     #1REFN        READE     SECOEXL0                               89
669500200529      *
669600200529     C                   ELSE                                                   X*8
669700200529     C     #1PTYP        IFEQ      'NC'                                         B*9
669800200529     C     #1SEL         IFEQ      'D'                                          B*10
669900200529     C                   DELETE    SECONCD0
670000200529     C                   ENDIF                                                  E*10
670100200529     C     #1REFN        READE     SECONCL0                               89
670200200529      *
670300200529     C                   ELSE                                                   X*9
670400200529     C     #1PTYP        IFEQ      'NF'                                         B*10
670500200529     C     #1SEL         IFEQ      'D'                                          B*11
670600200529     C                   DELETE    SECONFD0
670700200529     C                   ENDIF                                                  E*11
670800200529     C     #1REFN        READE     SECONFL0                               89
670900200529      *                                                                   CEU017
671000200529     C                   ELSE                                                   X*10           CEU01
671100200529     C     #1PTYP        IFEQ      'CC'                                         B*11           CEU01
671200200529     C     #1SEL         IFEQ      'D'                                          B*12           CEU01
671300200529      *                                                                   CEU017
671400200529     C     NABLKR        IFNE      *ZEROS                                       B*13           CEU01
671500200529     C                   Z-ADD     *ZEROS        WCOUNT            5 0                         13787
671600200529     C                   MOVE      #1REFN        W1REFN            6 0                         13787
671700200529      *                                                                   CEU017
671800200529     C     NABLKR        SETLL     SECORSL0                                                    CEU01
671900200529     C     NABLKR        READE     SECORSL0                               88                   CEU01
672000200529     C     *IN88         DOWEQ     '0'                                          B*14           CEU01
672100200529     C                   ADD       1             WCOUNT                                        13787
672200200529     C     W1REFN        IFEQ      NCCORF                                       B*15           13787
672300200529     C     NCRECI        ORNE      'D'                                                         13787
672400200529     C                   DELETE    SECORSD0                                                    CEU01
672500200529     C                   SUB       1             WCOUNT                                        13787
672600200529     C                   ENDIF                                                  E*15           13787
672700200529     C     NABLKR        READE     SECORSL0                               88                   CEU01
672800200529     C                   ENDDO                                                  E*14           CEU01
672900200529      *                                                                   CEU017
673000200529     C     WCOUNT        IFEQ      *ZEROS                                                      13787
673100200529     C     NABLKR        CHAIN     SECORBL0                           88                       CEU01
673200200529     C     *IN88         IFEQ      '0'                                          B*14           CEU01
673300200529     C                   DELETE    SECORBD0                                                    CEU01
673400200529     C                   ENDIF                                                  E*14           CEU01
673500200529     C                   ENDIF                                                                 13787
673600200529     C                   ENDIF                                                  E*13           CEU01
673700200529      *                                                                   CEU017
673800200529     C                   DELETE    SECOCCD0                                                    CEU01
673900200529     C                   ENDIF                                                  E*12           CEU01
674000200529     C     #1REFN        READE     SECOCCL0                               89                   CEU01
674100200529     C/COPY WNCPYSRC,SE7502C062
674200200529     C                   ENDIF                                                  E*11           CEU01
674300200529     C                   ENDIF                                                  E*10
674400200529     C                   ENDIF                                                  E*9
674500200529     C                   ENDIF                                                  E*8
674600200529     C                   ENDIF                                                  E*7
674700200529     C                   ENDIF                                                  E*6
674800200529     C                   ENDIF                                                  E*5
674900200529     C                   ENDIF                                                  E*4
675000200529     C                   ENDIF                                                  E*3
675100200529     C                   ENDIF                                                  E*2
675200200529      *
675300200529     C                   ENDDO                                                  E*1
675400200529      *
675500200529     C/COPY WNCPYSRC,SE7502C065
675600200529     C                   ENDSR
675700200529      ****************************************************************
675800200529      /EJECT
675900200529      *****************************************************************
676000200529      * P023  : VIEW/CHANGE OPTION(S)                                 *
676100200529      *****************************************************************
676200200529      *
676300200529     C     P023          BEGSR
676400200529      *
676500200529     C                   MOVE      'Y'           ERROR
676600200529      *
676700200529     C     #1COAT        CHAIN     SECOATL0                           89
676800200529      *
676900200529     C                   MOVE      *BLANKS       WRTCD
677000200529      *
677100200529     C                   MOVE      #1EXDT        ZDATE
677200200529     C                   EXSR      ZDATE1
677300200529     C                   MOVE      ZDAYNO        WEXDAT
677400200529      *
677500200529     C                   MOVE      *BLANKS       WNBOP
677600200529     C                   MOVE      #1NBOP        WNBOP             2
677700200529     C                   MOVE      #1NBOP        SNBOP             2
677800200529      *
677900200529     C     MMPTYP        IFEQ      'NF'                                         B*3
678000200529     C                   CALL      'SE7510'                             99
678100200529     C                   PARM                    #1REFN                         ER Reference
678200200529     C                   PARM                    #1SECN                         Security Shortname
678300200529     C                   PARM                    #1COAT                         Corporate Action Typ
678400200529     C                   PARM                    #1STAT                         Corporate Action Sta
678500200529     C                   PARM                    #1FINA                         Final Allocation Ind
678600200529     C                   PARM                    MMPTYP                         Processing Type
678700200529     C                   PARM                    WEXDAT            5            Ex-Date
678800200529     C                   PARM                    #1SEL                          Action
678900200529     C                   PARM                    WRTCD             1            Return Code
679000200529     C/COPY WNCPYSRC,SE7502C049
679100200529     C                   ELSE                                                   X*3
679200200529      *
679300200529     C     MMPTYP        IFEQ      'NC'                                         B*4
679400200529     C                   CALL      'SE7511'                             99
679500200529     C                   PARM                    #1REFN                         ER Reference
679600200529     C                   PARM                    #1SECN                         Security Shortname
679700200529     C                   PARM                    #1COAT                         Corporate Action Typ
679800200529     C                   PARM                    #1STAT                         Corporate Action Sta
679900200529     C                   PARM                    #1FINA                         Final Allocation Ind
680000200529     C                   PARM                    MMPTYP                         Processing Type
680100200529     C                   PARM                    WEXDAT            5            Ex-Date
680200200529     C                   PARM                    #1SEL                          Action
680300200529     C                   PARM                    WRTCD             1            Return Code
680400200529     C/COPY WNCPYSRC,SE7502C050
680500200529     C                   ELSE                                                   X*4
680600200529      *                                                                   CEU017
680700200529     C     MMPTYP        IFEQ      'CC'                                         B*5            CEU01
680800200529     C                   CALL      'SE7520'                             99                     CEU01
680900200529     C                   PARM                    #1REFN                         Ref.           CEU01
681000200529     C                   PARM                    #1SECN                         Security       CEU01
681100200529     C                   PARM                    #1COAT                         Type           CEU01
681200200529     C                   PARM                    #1STAT                         Status         CEU01
681300200529     C                   PARM                    #1FINA                         Alloc.         CEU01
681400200529     C                   PARM                    MMPTYP                         Proc.          CEU01
681500200529     C                   PARM                    WEXDAT            5            Ex-Date        CEU01
681600200529     C                   PARM                    #1SEL                          Action         CEU01
681700200529     C                   PARM                    WRTCD             1            Return         CEU01
681800200529     C                   ELSE                                                   X*5            CEU01
681900200529     C/COPY WNCPYSRC,SE7502C051
682000200529      *
682100200529     C******IN46         IFEQ      '1'                                                 245165 247764
682200200529     C**********         MOVE      'X'           WRTCD                                 245165 247764
682300200529     C**********         END                                                           245165 247764
682400200529      *                                                                         215165
682500200529     C                   CALL      'SE7599'                             99
682600200529     C                   PARM                    #1REFN                         ER Reference
682700200529     C                   PARM                    #1SECN                         Security Shortname
682800200529     C                   PARM                    #1COAT                         Corporate Action Typ
682900200529     C                   PARM                    #1STAT                         Corporate Action Sta
683000200529     C                   PARM                    #1FINA                         Final Allocation Ind
683100200529     C                   PARM                    MMPTYP                         Processing Type
683200200529     C                   PARM                    WEXDAT            5            Ex-Date
683300200529     C                   PARM                    WNBOP                          Number of Options
683400200529     C                   PARM                    #1SEL                          Action
683500200529     C                   PARM      'E'           WWEVDP            1            Events or Depots
683600200529     C                   PARM                    #1TDVD                         Trade/Value Position
683700200529     C                   PARM                    WRTCD             1            Return Code
683800200529     C                   PARM      ' '           WWREX             1                           13896
683900200529     C/COPY WNCPYSRC,SE7502C052
684000200529     C                   ENDIF                                                  E*5            CEU01
684100200529     C                   ENDIF                                                  E*4
684200200529     C                   ENDIF                                                  E*3
684300200529      *
684400200529      **   IR ERROR INDICATOR OF THE PROGRAM CALL IS ON
684500200529      **   OR IF RETURN CODE IS EQUAL TO 'E' (ERROR)
684600200529      **         DATABASE ERROR
684700200529      *
684800200529     C     *IN99         IFEQ      '1'                                          B*3
684900200529     C     WRTCD         OREQ      'E'
685000200529      *
685100200529     C     MMPTYP        IFEQ      'NF'                                         B*4
685200200529     C                   MOVEL     NARR(2)       DBKEY            29
685300200529     C                   ELSE                                                   X*4
685400200529     C     MMPTYP        IFEQ      'NC'                                         B*5
685500200529     C                   MOVEL     NARR(3)       DBKEY
685600200529     C                   ELSE                                                   X*5
685700200529     C     MMPTYP        IFEQ      'CC'                                         B*6            CEU01
685800200529     C                   MOVEL     NARR(7)       DBKEY                                         CEU01
685900200529     C                   ELSE                                                   X*6            CEU01
686000200529     C                   MOVEL     NARR(1)       DBKEY
686100200529     C                   ENDIF                                                  E*6            CEU01
686200200529     C                   ENDIF                                                  E*5
686300200529     C                   ENDIF                                                  E*4
686400200529      *
686500200529     C                   MOVEL     '009'         DBASE             3 0          *****************
686600200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 09 **
686700200529     C                   EXSR      *PSSR                                        *****************
686800200529     C                   ENDIF                                                  E*3
686900200529      *
687000200529      **   IF RETURN CODE IS EQUAL TO '2', '3'
687100200529      *
687200200529     C     WRTCD         IFEQ      '3'                                          B*3
687300200529      *
687400200529      **   ACCESS TO ER REFERENCE FILE WITH CURRENT REFERENCE
687500200529      *
687600200529     C     #1REFN        CHAIN     SECORFL0                           88
687700200529      *
687800200529     C     *IN88         IFEQ      '0'                                          B*4            13787
687900200529     C                   MOVE      *BLANKS       MAJOBN
688000200529     C                   MOVE      *BLANKS       MAUSER
688100200529     C                   Z-ADD     *ZEROS        MAJNBR
688200200529      *
688300200529     C     MACHTP        IFNE      'R'                                          B*5            13787
688400200529     C     MASTAT        ANDNE     'R'                                                         13787
688500200529     C     MASTAT        ANDNE     'C'                                                         13787
688600200529     C                   MOVE      'D'           MARECI
688700200529     C                   Z-ADD     BJRDNB        MALCD
688800200529     C                   MOVE      'A'           MACHTP
688900200529     C                   MOVE      ##USR         MALUID
689000200529     C                   ENDIF                                                  E*5            13787
689100200529      *
689200200529     C                   UPDATE    SECORFD0
689300200529     C                   MOVE      FIELD         #FIELD
689400200529     C                   ENDIF                                                  E*4            13787
689500200529      *
689600200529      **   COMMITMENT INSTRUCTION
689700200529      *
689800200529     C                   COMMIT
689900200529     C                   ENDIF                                                  E*3
690000200529      *
690100200529     C     WRTCD         IFEQ      '3'                                          B*4
690200200529     C                   MOVE      '1'           *INKC
690300200529     C                   ELSE                                                   X*4            13787
690400200529     C     WWINPT        IFEQ      'Y'                                          B*5            13787
690500200529     C                   MOVE      '1'           *INKL                                         13787
690600200529     C                   ENDIF                                                  E*5            13787
690700200529     C                   ENDIF                                                  E*4
690800200529      *
690900200529     C     WNBOP         IFNE      SNBOP                                        B*3
691000200529     C***********        MOVE      '0'           *IN45                                        CSE020
691100200529     C                   MOVE      '0'           WIN45                                        CSE020
691200200529     C                   ENDIF                                                  E*3
691300200529     C/COPY WNCPYSRC,SE7502C053
691400200529      *
691500200529     C                   ENDSR
691600200529      ****************************************************************
691700200529      /EJECT
691800200529      *****************************************************************
691900200529      * P024  : VERIFY IF THE OPTION EXISTS                           *
692000200529      *****************************************************************
692100200529      *
692200200529     C     P024          BEGSR
692300200529      *
692400200529     C                   MOVE      '0'           *IN89
692500200529      *
692600200529     C     #1PTYP        IFEQ      'DV'                                         B*1
692700200529     C     KEY6          CHAIN     SECODVL0                           89
692800200529      *
692900200529     C                   ELSE                                                   X*1
693000200529     C     #1PTYP        IFEQ      'FR'                                         B*2
693100200529     C     KEY6          CHAIN     SECOFRL0                           89
693200200529      *
693300200529     C                   ELSE                                                   X*2
693400200529     C     #1PTYP        IFEQ      'CE'                                         B*3
693500200529     C     KEY6          CHAIN     SECOCEL0                           89
693600200529      *
693700200529     C                   ELSE                                                   X*3
693800200529     C     #1PTYP        IFEQ      'CR'                                         B*4
693900200529     C     KEY6          CHAIN     SECOCRL0                           89
694000200529      *
694100200529     C                   ELSE                                                   X*4
694200200529     C     #1PTYP        IFEQ      'OF'                                         B*5
694300200529     C     KEY6          CHAIN     SECOOFL0                           89
694400200529      *
694500200529     C                   ELSE                                                   X*5
694600200529     C     #1PTYP        IFEQ      'RG'                                         B*6
694700200529     C     KEY6          CHAIN     SECORGL0                           89
694800200529      *
694900200529     C                   ELSE                                                   X*6
695000200529     C     #1PTYP        IFEQ      'EX'                                         B*7
695100200529     C     KEY6          CHAIN     SECOEXL0                           89
695200200529     C                   ENDIF                                                  E*7
695300200529     C                   ENDIF                                                  E*6
695400200529     C                   ENDIF                                                  E*5
695500200529     C                   ENDIF                                                  E*4
695600200529     C                   ENDIF                                                  E*3
695700200529     C                   ENDIF                                                  E*2
695800200529     C                   ENDIF                                                  E*1
695900200529      *
696000200529     C                   ENDSR
696100200529      ****************************************************************
696200200529      /EJECT
696300200529      *****************************************************************
696400200529      * P025  : CHECK THAT NO POSITION EXISTS ON DEPOT POSITIONS FILE *
696500200529      *****************************************************************
696600200529      *
696700200529     C     P025          BEGSR
696800200529      *
696900200529     C                   MOVE      '0'           *IN89
697000200529      *
697100200529     C     #1SEL         IFEQ      'E'                                          B*1
697200200529     C     #1REFN        CHAIN     SECODPL1                           89
697300200529     C                   ELSE                                                   X*1
697400200529     C     #1SEL         IFEQ      'V'                                          B*2
697500200529     C     #1REFN        CHAIN     SECOALL1                           89
697600200529     C                   ENDIF                                                  E*2
697700200529     C                   ENDIF                                                  E*1
697800200529      *
697900200529     C     *IN89         IFEQ      '1'                                          B*1
698000200529     C                   MOVE      'Y'           ERMSG
698100200529     C                   MOVE      '1'           *IN62                          Reverse image
698200200529     C                   MOVEL     'CO00256'     ZAMSID                         Message id.
698300200529     C                   EXSR      ZASNMS                                       Send message
698400200529     C                   ENDIF                                                  E*1
698500200529      *
698600200529     C     #1SEL         IFEQ      'N'                                          B*1
698700200529     C     #1SECN        CHAIN     DPOSS                              89
698800200529      *
698900200529     C     *IN89         IFEQ      '0'                                          B*2
699000200529     C                   MOVE      'Y'           ERMSG
699100200529     C                   MOVE      '1'           *IN62                          Reverse image
699200200529     C                   MOVEL     'CO00255'     ZAMSID                         Message id.
699300200529     C                   EXSR      ZASNMS                                       Send message
699400200529     C                   ENDIF                                                  E*2
699500200529     C                   ENDIF                                                  E*1
699600200529      *
699700200529     C                   ENDSR
699800200529      ****************************************************************
699900200529      /EJECT
700000200529      *****************************************************************
700100200529      * R001 : POSITION INTO ER REFERENCE FILE                        *
700200200529      *****************************************************************
700300200529      *
700400200529     C     R001          BEGSR
700500200529      *
700600200529      **   FIRST TIME PROCESSING
700700200529      *
700800200529     C******IN45*        IFEQ      '0'                                          B*1           CSE020
700900200529     C     WIN45         IFEQ      '0'                                                        CSE020
701000200529     C     WDMNO         IFEQ      'Y'                                                        CSE020
701100200529     C                   Z-ADD     1             W#RRN             6 0                        CSE020
701200200529     C     W#RRN         SETLL     SECORFPM                                                   CSE020
701300200529     C                   ELSE                                                                 CSE020
701400200529     C************LOVAL    SETLLSECORFL1                                  136421
701500200529     C     *HIVAL        SETLL     SECORFL9                                                    13642
701600200529     C                   ENDIF                                                                CSE020
701700200529     C                   ENDIF                                                  E*1
701800200529      *
701900200529      **   ACCESS MUST BE DONE BY 'REFERENCE'
702000200529      *
702100200529     C     *IN55         IFEQ      '1'                                          B*1
702200200529      *
702300200529      **   IF ROLLUP
702400200529      *
702500200529     C     *IN27         IFEQ      '1'                                          B*2
702600200529     C***********KREFN     SETGTSECORFL1                                  136421
702700200529     C     WDMNO         IFEQ      'Y'                                                        CSE020
702800200529     C     W#RRN         SETLL     SECORFPM                                                   CSE020
702900200529     C                   ELSE                                                                 CSE020
703000200529     C     KREFN         SETGT     SECORFL9                                                    13642
703100200529     C                   ENDIF                                                                CSE020
703200200529     C                   ELSE                                                   X*2
703300200529     C***********KREFN     SETLLSECORFL1                                  136421
703400200529     C     WDMNO         IFEQ      'Y'                                                        CSE020
703500200529     C     W#RRN         SETLL     SECORFPM                                                   CSE020
703600200529     C                   ELSE                                                                 CSE020
703700200529     C     KREFN         SETLL     SECORFL9                                                    13642
703800200529     C                   ENDIF                                                                CSE020
703900200529     C                   ENDIF                                                  E*2
704000200529      *
704100200529     C                   ELSE                                                   X*1
704200200529      *
704300200529      **   ACCESS MUST BE DONE BY 'SECURITY' AND 'EX-DATE'
704400200529      *
704500200529     C******IN53*        IFEQ      '1'                                          B*2           CSE020
704600200529     C     WIN53         IFEQ      '1'                                          B*2           CSE020
704700200529      *
704800200529      **   IF ROLLUP
704900200529      *
705000200529     C     *IN27         IFEQ      '1'                                          B*3
705100200529     C     KEY1          SETGT     SECORFL3
705200200529     C                   ELSE                                                   X*3
705300200529     C     KEY1          SETLL     SECORFL3
705400200529     C                   ENDIF                                                  E*3
705500200529      *
705600200529     C                   ELSE                                                   X*2
705700200529      *
705800200529      **   ACCESS MUST BE DONE BY 'EX-DATE' AND 'SECURITY'
705900200529      *
706000200529     C     *IN54         IFEQ      '1'                                          B*3
706100200529      *
706200200529      **   IF ROLLUP
706300200529      *
706400200529     C     *IN27         IFEQ      '1'                                          B*4
706500200529     C     KEY2          SETGT     SECORFL4
706600200529     C                   ELSE                                                   X*4
706700200529     C     KEY2          SETLL     SECORFL4
706800200529     C                   ENDIF                                                  E*4
706900200529      *
707000200529     C                   ELSE                                                   X*3
707100200529      *
707200200529      **   IF ROLLUP IN AMEND/ENQUIRY MODE
707300200529      *
707400200529     C     *IN27         IFEQ      '1'                                          B*4
707500200529      *
707600200529     C     *IN43         IFEQ      '1'                                          B*5
707700200529     C     *IN61         OREQ      '1'
707800200529     C***********KREFN     SETGTSECORFL1                                  136421
707900200529     C     WDMNO         IFEQ      'Y'                                                        CSE020
708000200529     C     W#RRN         SETLL     SECORFPM                                                   CSE020
708100200529     C                   ELSE                                                                 CSE020
708200200529     C     KREFN         SETGT     SECORFL9                                                    13642
708300200529     C                   ENDIF                                                                CSE020
708400200529     C                   ENDIF                                                  E*5
708500200529     C                   ENDIF                                                  E*4
708600200529     C                   ENDIF                                                  E*3
708700200529     C                   ENDIF                                                  E*2
708800200529     C                   ENDIF                                                  E*1
708900200529      *
709000200529     C                   ENDSR
709100200529      ****************************************************************
709200200529      /EJECT
709300200529      *****************************************************************
709400200529      * R002 : READ NEXT RECORD OF THE ER REFERENCE FILE              *
709500200529      *****************************************************************
709600200529      *
709700200529     C     R002          BEGSR
709800200529      *
709900200529      **   ACCESS MUST BE DONE BY 'REFERENCE'
710000200529      *
710100200529     C     *IN55         IFEQ      '1'                                          B*1
710200200529     C******IN45*        OREQ      '0'                                                        CSE020
710300200529     C     WIN45         OREQ      '0'                                                        CSE020
710400200529     C************         READ SECORFL1                 30               136421
710500200529     C     WDMNO         IFEQ      'Y'                                                        CSE020
710600200529     C                   READ      SECORFPM                               30                  CSE020
710700200529     C                   ADD       1             W#RRN                                        CSE020
710800200529     C                   ELSE                                                                 CSE020
710900200529     C                   READ      SECORFL9                               30                   13642
711000200529     C                   ENDIF                                                                CSE020
711100200529     C                   ELSE                                                   X*1
711200200529      *
711300200529      **   ACCESS MUST BE DONE BY 'SECURITY' AND 'EX-DATE' AND 'REFERENCE'
711400200529      *
711500200529     C******IN53*        IFEQ      '1'                                          B*2           CSE020
711600200529     C     WIN53         IFEQ      '1'                                          B*2           CSE020
711700200529     C                   READ      SECORFL3                               30
711800200529     C                   ELSE                                                   X*2
711900200529      *
712000200529      **   ACCESS MUST BE DONE BY 'EX-DATE' AND 'SECURITY' AND 'REFERENCE'
712100200529      *
712200200529     C     *IN54         IFEQ      '1'                                          B*3
712300200529     C                   READ      SECORFL4                               30
712400200529     C                   ELSE                                                   X*3
712500200529      *
712600200529      **   IF ROLLUP IN AMEND/ENQUIRY MODE
712700200529      *
712800200529     C     *IN27         IFEQ      '1'                                          B*4
712900200529      *
713000200529     C     *IN43         IFEQ      '1'                                          B*5
713100200529     C     *IN61         OREQ      '1'
713200200529     C************         READ SECORFL1                 30               136421
713300200529     C     WDMNO         IFEQ      'Y'                                                        CSE020
713400200529     C                   READ      SECORFPM                               30                  CSE020
713500200529     C                   ADD       1             W#RRN                                        CSE020
713600200529     C                   ELSE                                                                 CSE020
713700200529     C                   READ      SECORFL9                               30                   13642
713800200529     C                   ENDIF                                                                CSE020
713900200529     C                   ENDIF                                                  E*5
714000200529     C                   ENDIF                                                  E*4
714100200529     C                   ENDIF                                                  E*3
714200200529     C                   ENDIF                                                  E*2
714300200529     C                   ENDIF                                                  E*1
714400200529      *
714500200529     C                   ENDSR
714600200529      ****************************************************************
714700200529     C/COPY WNCPYSRC,SE7502C054
714800200529      /EJECT
714900200529      *****************************************************************
715000200529      * *PSSR - TO PROCESS ABNORMAL END OF PROGRAM                    *
715100200529      *****************************************************************
715200200529     C     *PSSR         BEGSR
715300200529      *
715400200529      ** UPDATE LDA WITH ERROR INFORMATION
715500200529      *
715600200529     C     *DTAARA       DEFINE                  LDA
715700200529     C     *LOCK         IN        LDA
715800200529     C                   MOVEL     DBFILE        WWFILE
715900200529     C                   MOVEL     DBKEY         WWKEY
716000200529     C                   MOVEL     DBPGM         WWPGM
716100200529     C                   MOVEL     DBASE         WWASE
716200200529     C                   OUT       LDA
716300200529      *
716400200529      **   ROLLBACK CHANGES, PRINT DUMP AND CANCEL PROGRAM
716500200529      *
716600200529     C                   ROLBK
716700200529     C                   DUMP
716800200529      *
716900200529      **   TRY TO RELEASE CORPORATE ACTION BY ACCESS TO ER REFERENCE FILE
717000200529      **   IF CURRENT ER REFERENCE IS NOT BLANK
717100200529      *
717200200529     C     #1REFN        IFNE      *BLANKS                                      B*1
717300200529     C     #1REFN        SETLL     SECORFL0
717400200529     C                   READ      SECORFL0                               89
717500200529      *
717600200529      **   IF THE RECORD EXISTS
717700200529      *
717800200529     C     *IN89         IFEQ      '0'                                          B*2
717900200529      *
718000200529     C/COPY WNCPYSRC,SE7502C055
718100200529     C                   MOVE      *BLANKS       MAJOBN
718200200529     C                   MOVE      *BLANKS       MAUSER
718300200529     C                   Z-ADD     *ZEROS        MAJNBR
718400200529      *
718500200529      **   UPDATE THE RECORD
718600200529      *
718700200529     C                   UPDATE    SECORFD0
718800200529     C                   MOVE      FIELD         #FIELD
718900200529     C/COPY WNCPYSRC,SE7502C056
719000200529      *
719100200529      **   COMMITMENT INSTRUCTION
719200200529      *
719300200529     C                   COMMIT
719400200529     C                   ENDIF                                                  E*2
719500200529     C                   ENDIF                                                  E*1
719600200529      *
719700200529     C/COPY WNCPYSRC,SE7502C057
719800200529     C                   MOVE      '1'           *INU7
719900200529     C                   MOVE      '1'           *INU8
720000200529     C                   MOVE      '1'           *INLR
720100200529     C/COPY WNCPYSRC,SE7502C058
720200200529     C                   CALL      'DBERRCTL'
720300200529     C/COPY WNCPYSRC,SE7502C059
720400200529     C                   RETURN
720500200529      *
720600200529     C                   ENDSR
720700200529      *****************************************************************
720800200529      /EJECT
720900200529      ****************************************************************
721000200529      *  ZASNMS : SEND MESSAGE TO PROGRAM'S MESSAGE QUEUE            *
721100200529      ****************************************************************
721200200529      *
721300200529     C     ZASNMS        BEGSR
721400200529      *
721500200529      **   message file specified use PMSGF
721600200529      *
721700200529     C                   MOVEL     PMSGF         ZAMSGF
721800200529     C/COPY WNCPYSRC,SE7502C060
721900200529     C                   CALL      'Y2SNMGC'
722000200529     C                   PARM                    ZAPGM            10            Program queue
722100200529     C                   PARM                    ZAPGRL            5            Rel queue
722200200529     C                   PARM                    ZAMSID            7            Message Id.
722300200529     C                   PARM                    ZAMSGF           10            Message file.
722400200529     C                   PARM                    ZAMSDA          132            Message data.
722500200529     C                   PARM                    ZAMSTP            7            Message type.
722600200529      *
722700200529      **   Clear all fields for default mechanism next time.
722800200529      *
722900200529     C                   MOVEL     *BLANK        ZAPGM                          Program queue
723000200529     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
723100200529     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
723200200529     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
723300200529     C                   MOVEL     *BLANK        ZAMSGF                         Message file
723400200529     C                   MOVEL     *BLANK        ZAMSID                         Message id.
723500200529     C/COPY WNCPYSRC,SE7502C061
723600200529      *
723700200529     C                   ENDSR
723800200529      ********************************************************************
723900200529      /EJECT
724000200529      ********************************************************************
724100200529      **
724200200529      **   ZDATE1 SR. TO VALIDATE DATES SUBMITTED AND
724300200529      **              CONVERT TO A NUMBER OF DAYS.
724400200529      **
724500200529      **   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
724600200529      **
724700200529     C     ZDATE1        BEGSR                                                  *** ZDATE1 ***
724800200529      **
724900200529      **   CLEAR DAY NUMBER. RESET ERROR INDICATOR
725000200529     C                   Z-ADD     0             ZDAYNO            5 0
725100200529     C                   SETOFF                                       99
725200200529      **
725300200529      **   CALCULATION TO DEFINE INPUT DATE FIELD.
725400200529     C                   Z-ADD     ZDATE         ZDATE             6 0
725500200529      **
725600200529      **   GET INDIVIDUAL DAY, MONTH AND YEAR FIELDS.
725700200529     C                   MOVE      ZDATE         ZYEAR             2 0
725800200529     C  N98              MOVEL     ZDATE         ZDAY              2 0
725900200529     C   98              MOVEL     ZDATE         ZMTH              2 0
726000200529     C                   MOVE      ZDATE         ZWRK4             4 0
726100200529     C  N98              MOVEL     ZWRK4         ZMTH
726200200529     C   98              MOVEL     ZWRK4         ZDAY
726300200529      **
726400200529      **   ENSURE MONTH IS VALID. BYPASS IF ERROR
726500200529     C     ZMTH          IFLE      0
726600200529     C     ZMTH          ORGT      12
726700200529     C                   SETON                                        99
726800200529     C                   GOTO      ZDEND1
726900200529     C                   END
727000200529      **
727100200529      **   ENSURE DAY IS VALID. BYPASS IF ERROR
727200200529     C     ZDAY          IFLE      0
727300200529     C                   SETON                                        99
727400200529     C                   GOTO      ZDEND1
727500200529     C                   END
727600200529      **
727700200529      **   CHECK FOR 30 DAY MONTHS. BYPASS IF ERROR
727800200529     C     ZMTH          IFEQ      4
727900200529     C     ZMTH          OREQ      6
728000200529     C     ZMTH          OREQ      9
728100200529     C     ZMTH          OREQ      11
728200200529      **
728300200529     C     ZDAY          IFGT      30
728400200529     C                   SETON                                        99
728500200529     C                   GOTO      ZDEND1
728600200529     C                   END
728700200529      **
728800200529     C                   ELSE
728900200529      **
729000200529      **   CHECK FOR 31 DAY MONTHS (ALL OTHERS BUT FEB). BYPASS IF ERROR
729100200529     C     ZDAY          IFGT      31
729200200529     C     ZMTH          ANDNE     2
729300200529     C                   SETON                                        99
729400200529     C                   GOTO      ZDEND1
729500200529     C                   END
729600200529      **
729700200529     C                   END
729800200529      **
729900200529      **   CHECK FOR LEAP YEAR: REMAINDER WILL BE ZERO IF IT IS A LEAP YR
730000200529     C     ZYEAR         ADD       28            ZYEAR
730100200529     C     ZYEAR         DIV       4             ZLYR              2 0
730200200529     C                   MVR                     ZLY               1 0
730300200529      **
730400200529      **   IF FEBUARY FURTHER VALIDATE DAY.
730500200529     C     ZMTH          IFEQ      2
730600200529      **
730700200529      **   INVALID IF GREATER THAN 28 AND NOT A LEAP YEAR
730800200529     C     ZLY           IFGT      0
730900200529     C     ZDAY          ANDGT     28
731000200529     C                   SETON                                        99
731100200529     C                   GOTO      ZDEND1                                       BYPASS IF ERROR
731200200529     C                   END
731300200529      **
731400200529      **   INVALID IF GREATER THAN 29 AND A LEAP YEAR - BYPASS IF ERROR
731500200529     C     ZLY           IFEQ      0
731600200529     C     ZDAY          ANDGT     29
731700200529     C                   SETON                                        99
731800200529     C                   GOTO      ZDEND1
731900200529     C                   END
732000200529      **
732100200529     C                   END
732200200529      **
732300200529      **   DETERMINE NUMBER OF DAYS FROM 31/12/1971.
732400200529      **
732500200529      **   MULTIPLY NO. OF FOUR-YEAR SPANS, BY NO. OF DAYS IN SPAN
732600200529     C     ZLYR          MULT      1461          ZDAYNO
732700200529      **
732800200529      **   IF NOT A LEAP YEAR, ADD APPROPRIATE NO. OF DAYS FOR EXTRA
732900200529      **   YEARS USING REMAINDER FIELD (IE. 1, 2 OR 3 X 356)
733000200529     C     ZLY           IFGT      0
733100200529     C     ZDAYNO        ADD       ZYDY(ZLY)     ZDAYNO
733200200529     C                   END
733300200529      **
733400200529      **   IF IT IS A LEAP YEAR, AND LATER THAN FEBRUARY, ADD ONE FOR
733500200529      **   29TH OF FEB
733600200529     C     ZLY           IFEQ      0
733700200529     C     ZMTH          ANDGT     2
733800200529     C     ZDAYNO        ADD       1             ZDAYNO
733900200529     C                   END
734000200529      **
734100200529      **   ADD APPROPRIATE NUMBER OF DAYS FOR THE MONTH NUMBER
734200200529     C     ZDAYNO        ADD       ZMDY(ZMTH)    ZDAYNO
734300200529      **
734400200529      **   ADD NUMBER OF DAYS IN MONTH
734500200529     C     ZDAYNO        ADD       ZDAY          ZDAYNO
734600200529      **
734700200529     C     ZDEND1        ENDSR                                                  * ZDEND1 ENDSR*
734800200529      **
734900200529      ********************************************************************
735000200529      **
735100200529      **   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
735200200529      **
735300200529      **   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
735400200529      **
735500200529     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
735600200529      **
735700200529      **   CLEAR LEAP YEAR WORK FIELD.
735800200529     C                   MOVE      'N'           ZLEAP             1
735900200529      **
736000200529      **   CLEAR DATE FIELDS.
736100200529     C                   Z-ADD     0             ZDATE             6 0
736200200529     C                   MOVEL     '       '     ZADATE            7
736300200529      **
736400200529      **   CALCULATION TO DEFINE INPUT DAY NUMBER.
736500200529     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
736600200529      **
736700200529      **   DETERMINE YEAR NUMBER.
736800200529      **
736900200529      **   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
737000200529     C     ZDAYNO        SUB       1             ZDAYN1            5 0
737100200529     C     ZDAYN1        IFLT      0
737200200529     C                   GOTO      ZDEND2
737300200529     C                   END
737400200529      **
737500200529      **   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
737600200529     C     ZDAYN1        DIV       1461          ZLYR              2 0
737700200529     C                   MVR                     ZDAYN1                         SAVE REMAINING
737800200529      **                                                   DAYS
737900200529      **   CALCULATE NUMBER OF REMAINING YEARS.
738000200529     C                   Z-ADD     1             ZWRK2             2 0
738100200529     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
738200200529     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
738300200529     C     ZWRK2         ADD       1             ZWRK2
738400200529     C                   GOTO      ZDTAG1
738500200529     C                   END
738600200529      *
738700200529     C     ZWRK2         SUB       1             ZWRK2
738800200529      **
738900200529      **   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
739000200529     C     ZWRK2         IFNE      0
739100200529     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
739200200529     C                   END
739300200529      **
739400200529      **   CALCULATE ACTUAL YEAR NUMBER.
739500200529     C     ZLYR          MULT      4             ZWRK3             3 0
739600200529     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
739700200529     C                   Z-ADD     ZWRK3         ZYEAR             2 0
739800200529     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
739900200529      **
740000200529      **   DETERMINE MONTH NUMBER.
740100200529      **
740200200529      **   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
740300200529     C     ZWRK2         IFEQ      0
740400200529     C     ZDAYN1        IFEQ      59
740500200529     C                   MOVE      'Y'           ZLEAP
740600200529     C                   END
740700200529     C     ZDAYN1        IFGE      59
740800200529     C     ZDAYN1        SUB       1             ZDAYN1
740900200529     C                   END
741000200529     C                   END
741100200529      **
741200200529      **   CALCULATE MONTH NUMBER.
741300200529     C                   Z-ADD     2             ZWRK2
741400200529     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
741500200529     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
741600200529     C     ZWRK2         ADD       1             ZWRK2
741700200529     C                   GOTO      ZDTAG2
741800200529     C                   END
741900200529      *
742000200529     C     ZWRK2         SUB       1             ZWRK2
742100200529      **
742200200529     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
742300200529      **
742400200529      **   DETERMINE DAY OF MONTH.
742500200529      **
742600200529      **   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
742700200529     C     ZDAYN1        ADD       1             ZDAYN1
742800200529      **
742900200529      **   CALCULATE DAY OF MONTH.
743000200529     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
743100200529      **
743200200529      **   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
743300200529     C     ZLEAP         IFEQ      'Y'
743400200529     C     ZDAY          ADD       1             ZDAY
743500200529     C                   END
743600200529      **
743700200529      **   FORMAT DATE, DDMMYY OR MMDDYY.
743800200529     C  N98              MOVEL     ZDAY          ZWRK4             4 0
743900200529     C   98              MOVE      ZDAY          ZWRK4
744000200529     C  N98              MOVE      ZMTH          ZWRK4
744100200529     C   98              MOVEL     ZMTH          ZWRK4
744200200529     C                   MOVEL     ZWRK4         ZDATE
744300200529     C                   MOVE      ZYEAR         ZDATE
744400200529      **
744500200529      **   FORMAT ALPHA DATE, DDMMMYY.
744600200529     C                   MOVEL     ZDAY          ZWRK5             5
744700200529     C     ZDAY          IFLT      10
744800200529     C                   MOVEL     ' '           ZWRK5
744900200529     C                   END
745000200529     C                   MOVE      ZMNM(ZMTH)    ZWRK5
745100200529     C                   MOVEL     ZWRK5         ZADATE
745200200529     C                   MOVE      ZYEAR         ZADATE
745300200529      **
745400200529     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
745500200529      **
745600200529      **
745700200529      ********************************************************************
745800200529      /EJECT
745900200529      ********************************************************************
746000200529      *    SUBROUTINE- ZNCD
746100200529      *    DETERMINE NEXT COUPON DATE
746200200529      *
746300200529      **
746400200529      **  INPUT - CD ARRAY - COUPON DATES - SECTYD SECURITY FILE
746500200529      **          CR ARRAY - RATE/PAYT INDICS - SECTYD SECURITY FILE
746600200529      **          FCPN - FIRST COUPON DATE - SECTYD SECURITY FILE
746700200529      **          MATY - MATURITY DATE - SECTYD SECURITY FILE
746800200529      **          ECD - EVENT CONTROL DTAE - ZEVCD PROCESS
746900200529      **          *IN98 - DATE FORMAT - FROM TABTC10 RECORD VIA ZSYSTM
747000200529      **
747100200529      **  OUTPUT - NCD (5,0) - NEXT COUPON DATE
747200200529      **
747300200529      **  CALLS  - ZDATE1
747400200529      **           ZDATE2
747500200529      ********************************************************************
747600200529      *
747700200529     C     ZNCD          BEGSR                                                  *** ZNCD   ***
747800200529      *
747900200529     C                   EXSR      ZDATE2
748000200529     C                   MOVEL     ZDATE         ZZECD4            4 0
748100200529     C     *IN98         IFEQ      '0'
748200200529     C                   MOVEL     ZZECD4        ZZWRKD
748300200529     C                   MOVE      ZZECD4        ZZWRKM
748400200529     C                   Z-ADD     ZZWRKD        ZZECD4
748500200529     C                   MOVEL     ZZWRKM        ZZECD4
748600200529     C                   END
748700200529      *
748800200529      * IF DATE FORMAT IS DDMMYY TURN ROUND ARRAY OF COUPON DATES TO MMDD
748900200529     C     *IN98         IFEQ      '0'
749000200529     C                   DO        12            X                 2 0
749100200529     C                   MOVE      CD(X)         ZZWRKM            2 0
749200200529     C                   MOVEL     CD(X)         ZZWRKD            2 0
749300200529     C                   Z-ADD     ZZWRKD        CD(X)
749400200529     C                   MOVEL     ZZWRKM        CD(X)
749500200529     C                   END
749600200529     C                   END
749700200529      * GET YEAR FOR ECD
749800200529     C                   MOVE      ZDATE         ZECDYR            2 0
749900200529      *
750000200529      * FIND NEXT COUPON DATE FROM ARRAYS -
750100200529      *  IF RATE/PAYT INDS ALL BLANK NCD = MATURITY DATE
750200200529     C                   Z-ADD     MATY          NCD               5 0
750300200529     C     CRDS          IFNE      *BLANKS
750400200529      *  IF RATE/PAYT INDS NOT ALL BLANK -
750500200529      *    SEARCH FOR NEXT HIGHEST COUPON
750600200529     C                   MOVE      '0'           ZFOUND            1
750700200529     C                   DO        12            X
750800200529     C     CR(X)         IFEQ      'P'
750900200529     C     CR(X)         OREQ      'C'
751000200529     C     ZZECD4        IFLE      CD(X)
751100200529     C                   MOVE      '1'           ZFOUND
751200200529     C                   GOTO      ZNCD00
751300200529     C                   END
751400200529     C                   END
751500200529     C                   END
751600200529      *      FOUND - ADD ECD'S YY TO FORM DATE
751700200529     C     ZNCD00        TAG                                                    ZNCD00 TAG
751800200529     C     ZFOUND        IFEQ      '1'
751900200529     C                   Z-ADD     ZECDYR        ZDATE
752000200529     C                   MOVEL     CD(X)         ZDATE
752100200529      *      NOT FOUND - USE FIRST COUPON
752200200529      *                  ADD NEXT YEAR'S YY TO FORM DATE
752300200529     C                   ELSE
752400200529     C                   DO        12            X
752500200529     C     CR(X)         IFEQ      'P'
752600200529     C     CR(X)         OREQ      'C'
752700200529     C                   Z-ADD     ZECDYR        ZDATE
752800200529     C                   ADD       1             ZDATE
752900200529     C                   MOVEL     CD(X)         ZDATE
753000200529     C                   MOVE      '1'           ZFOUND
753100200529     C                   GOTO      ZNCD01
753200200529     C                   END
753300200529     C                   END
753400200529     C                   END
753500200529     C     ZNCD01        TAG                                                    ZNCD01 TAG
753600200529      *
753700200529      * CONVERT DATE TO DAY NO USING ZDATE1
753800200529      * (NOT DONE IF NO RATE/PAYT IND IS P OR C)
753900200529      * IF DDMMYY FORMAT TURN ROUND TO MMDDYY
754000200529     C     ZFOUND        IFEQ      '1'
754100200529     C     *IN98         IFEQ      '0'
754200200529     C                   MOVEL     ZDATE         ZZWRK             4 0
754300200529     C                   MOVE      ZZWRK         ZZWRKM
754400200529     C                   MOVEL     ZZWRK         ZZWRKD
754500200529     C                   Z-ADD     ZZWRKD        ZZWRK
754600200529     C                   MOVEL     ZZWRKM        ZZWRK
754700200529     C                   MOVEL     ZZWRK         ZDATE
754800200529     C                   END
754900200529     C                   EXSR      ZDATE1
755000200529     C                   Z-ADD     ZDAYNO        NCD
755100200529     C                   END
755200200529      *
755300200529      * IF NCD > MATURITY DATE , RESET NCD = MATURITY DATE
755400200529     C     NCD           IFGT      MATY
755500200529     C                   Z-ADD     MATY          NCD
755600200529     C                   END
755700200529     C                   END
755800200529      *
755900200529      * If the First Coupon Date is not zero, then
756000200529      * IF NCD < 1ST COUPON DATE , RESET NCD = 1ST COUPON DATE
756100200529      *
756200200529     C     FCPN          IFNE      *ZEROS
756300200529     C     NCD           ANDLT     FCPN
756400200529     C                   Z-ADD     FCPN          NCD
756500200529     C                   END
756600200529      *
756700200529      * IF DATE FORMAT IS DDMMYY TURN BACK ARRAY OF COUPON DATES TO DD/MM
756800200529     C     *IN98         IFEQ      '0'
756900200529     C                   DO        12            X                 2 0
757000200529     C                   MOVEL     CD(X)         ZZWRKM            2 0
757100200529     C                   MOVE      CD(X)         ZZWRKD            2 0
757200200529     C                   Z-ADD     ZZWRKM        CD(X)
757300200529     C                   MOVEL     ZZWRKD        CD(X)
757400200529     C                   END
757500200529     C                   END
757600200529      *
757700200529     C                   ENDSR
757800200529      *****************************************************************
757900200529      /EJECT
758000200529     C*/COPY ZSRSRC,ZALIGNZ2
758100200529      *****************************************************************
758200200529      *                                                               *
758300200529      *  Midas - /COPY Member (RPG)                                   *
758400200529      *                                                               *
758500200529      *  ZALIGNZ2 - To validate and right align numeric fields        *
758600200529      *                                                               *
758700200529      *  (c) Finastra International Limited 2001                      *
758800200529      *                                                               *
758900200529      *  Any changes made to this /COPY member may also need to be    *
759000200529      *  incorporated in ZALIGNZ2L.                                   *
759100200529      *                                                               *
759200200529      * Midas DBA 3.00 ---------------- Base -------------------------*
759300200529      *  Last Amend No. Xnnnnn  *CREATE    Date ddmmmyy               *
759400200529      *  Prev Amend No.                    Date ddmmmyy               *
759500200529      *                                                               *
759600200529      *---------------------------------------------------------------*
759700200529      *                                                               *
759800200529      *  nnnnnn - (fix details)                                       *
759900200529      *                                                               *
760000200529     C********************************************************************
760100200529     C**
760200200529     C**   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
760300200529     C**
760400200529     C     ZALIGN        BEGSR                                                  *** ZALIGN ***
760500200529     C**
760600200529     C                   SETOFF                                       929399
760700200529     C**
760800200529     C**   SAVE INPUT FIELD IN ARRAY, ZA1.
760900200529     C                   MOVEA     ZFIELD        ZA1
761000200529     C**
761100200529     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
761200200529     C                   Z-ADD     ZADIG         ZADIG             2 0
761300200529     C                   Z-ADD     ZADEC         ZADEC             1 0
761400200529     C**
761500200529     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
761600200529     C                   MOVE      ' '           ZA2
761700200529     C                   MOVEA     ZA2           ZFIELD           16
761800200529     C                   Z-ADD     0             ZX                2 0
761900200529     C                   Z-ADD     0             ZY                2 0
762000200529     C**
762100200529     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
762200200529     C     ZADIG         ADD       ZADEC         ZZ                2 0
762300200529     C     ZZ            COMP      15                                 99
762400200529     C   99              GOTO      ZAEND
762500200529     C**
762600200529     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
762700200529     C     ZATAG1        TAG                                                    ** ZATAG1 TAG *
762800200529     C     ZX            ADD       1             ZX
762900200529     C**
763000200529     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
763100200529     C     ZA1(ZX)       COMP      '.'                                    90
763200200529     C   90
763300200529     CAN 93              SETON                                        99
763400200529     C   99              GOTO      ZAEND
763500200529     C**
763600200529     C**
763700200529     C**   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
763800200529     C     ZA1(ZX)       COMP      'M'                                    96
763900200529     C   96              DO
764000200529     C     ZX            COMP      15                                 99  99
764100200529     C   99              GOTO      ZAEND
764200200529     C     ZX            ADD       1             ZX
764300200529     C     ZA1(ZX)       COMP      ' '                                9999
764400200529     C   99              GOTO      ZAEND
764500200529     C     ZX            SUB       1             ZX
764600200529     C     ZX            COMP      9                                  99
764700200529     C   99              GOTO      ZAEND
764800200529     C                   END
764900200529     C**
765000200529     C**   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
765100200529     C     ZA1(ZX)       COMP      'T'                                    97
765200200529     C   97              DO
765300200529     C     ZX            COMP      15                                 99  99
765400200529     C   99              GOTO      ZAEND
765500200529     C     ZX            ADD       1             ZX
765600200529     C     ZA1(ZX)       COMP      ' '                                9999
765700200529     C   99              GOTO      ZAEND
765800200529     C     ZX            SUB       1             ZX
765900200529     C     ZX            COMP      12                                 99
766000200529     C   99              GOTO      ZAEND
766100200529     C                   END
766200200529     C**
766300200529     C**   CLEAR ALPHAMERIC CONSTANT FROM ZA1
766400200529     C   96
766500200529     COR 97              MOVE      ' '           ZA1(ZX)
766600200529     C**
766700200529     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
766800200529     C     ZA1(ZX)       COMP      ' '                                    91
766900200529     C   91
767000200529     CAN 92              GOTO      ZATAG2
767100200529     C**
767200200529     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
767300200529     C  N90
767400200529     CANN91ZA1(ZX)       COMP      '0'                                  99
767500200529     C  N90
767600200529     CANN91
767700200529     CANN99ZA1(ZX)       COMP      '9'                                99
767800200529     C   99              GOTO      ZAEND                                        NOT NUMERIC
767900200529     C**
768000200529     C**   STORE DIGITS IN ARRAY AND HOW MANY.
768100200529     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
768200200529     C**   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
768300200529     C  N90
768400200529     CANN91ZY            ADD       1             ZY                   92
768500200529     C  N90
768600200529     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
768700200529     C   90              Z-ADD     ZY            ZZ                   93  93
768800200529     C**
768900200529     C     ZX            COMP      16                                   94      CHECK IF ALL
769000200529     C   94              GOTO      ZATAG1
769100200529     C**
769200200529     C     ZATAG2        TAG                                                    ** ZATAG2 TAG *
769300200529     C**
769400200529     C**   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
769500200529     C   96ZZ            ADD       6             ZZ
769600200529     C**
769700200529     C**   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
769800200529     C   97ZZ            ADD       3             ZZ
769900200529     C**
770000200529     C**   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
770100200529     C   96
770200200529     CAN 93
770300200529     COR 97
770400200529     CAN 93ZZ            DOWGT     ZY
770500200529     C     ZY            ADD       1             ZY
770600200529     C                   MOVE      '0'           ZA2(ZY)
770700200529     C                   END
770800200529     C**
770900200529     C**   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
771000200529     C   96
771100200529     CANN93              DO        6
771200200529     C     ZY            ADD       1             ZY
771300200529     C                   MOVE      '0'           ZA2(ZY)
771400200529     C                   END
771500200529     C**
771600200529     C   97
771700200529     CANN93              DO        3
771800200529     C     ZY            ADD       1             ZY
771900200529     C                   MOVE      '0'           ZA2(ZY)
772000200529     C                   END
772100200529     C**
772200200529     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
772300200529     C  N93              Z-ADD     ZY            ZZ
772400200529     C**
772500200529     C**   CHECK FOR EMBEDDED BLANKS.
772600200529     C   91
772700200529     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
772800200529     C   91
772900200529     CAN 92ZFIELD        COMP      ' '                                9999
773000200529     C   99              GOTO      ZAEND                                        EMBEDDED BLANK
773100200529     C**
773200200529     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
773300200529     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
773400200529     C     ZZ            COMP      ZADIG                              99
773500200529     C     ZY            SUB       ZZ            ZX
773600200529     C  N99ZADEC         SUB       ZX            ZX                     9995
773700200529     C   99              GOTO      ZAEND
773800200529     C   95              GOTO      ZATAG4                                       NO TRAILING
773900200529     C**                                                   BLANKS.
774000200529     C**   FILL THE TRAILING BLANKS WITH ZEROS.
774100200529     C     ZY            ADD       ZX            ZZ
774200200529     C     ZATAG3        TAG                                                    ** ZATAG3 TAG *
774300200529     C     ZY            ADD       1             ZY
774400200529     C                   MOVE      '0'           ZA2(ZY)
774500200529     C     ZY            COMP      ZZ                                   94
774600200529     C   94              GOTO      ZATAG3
774700200529     C**
774800200529     C**   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
774900200529     C     ZATAG4        TAG                                                    ** ZATAG4 TAG *
775000200529     C                   MOVE      '0'           ZA1
775100200529     C                   Z-ADD     16            ZX
775200200529     C     ZATAG5        TAG                                                    ** ZATAG5 TAG *
775300200529     C     ZY            COMP      0                                      94
775400200529     C   94              GOTO      ZATAG6
775500200529     C                   MOVE      ZA2(ZY)       ZA1(ZX)
775600200529     C     ZY            SUB       1             ZY
775700200529     C     ZX            SUB       1             ZX
775800200529     C                   GOTO      ZATAG5
775900200529     C     ZATAG6        TAG                                                    ** ZATAG6 TAG *
776000200529     C**
776100200529     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
776200200529     C                   MOVEA     ZA1           ZFIELD
776300200529     C**
776400200529     C                   SETOFF                                       9697
776500200529     C**
776600200529     C     ZAEND         ENDSR                                                  * ZAEND ENDSR *
776700200529     C**
776800200529     C**
776900200529     C********************************************************************
777000200529      /EJECT
777100200529     C*/COPY ZSRSRC,ZASIGNZ2
777200200529     C********************************************************************
777300200529     C**                                                                 *
777400200529     C** ZASIGN subroutine to validate and right-align signed numeric    *
777500200529     C** fields                                                          *
777600200529     C**     Input fields:   ZFLD17 17/                                  *
777700200529     C**                     ZSDIG  2/0                                  *
777800200529     C**                     ZSDEC  1/0                                  *
777900200529     C**                     ZSDCSP 1                                    *156689
778000200529     C**                                                                 *
778100200529     C**     Arrays:         ZS3    17/1/                                *
778200200529     C**                     ZS4    15/1/                                *
778300200529     C**                                                                 *
778400200529     C**     Output fields:  ZOUT15 15/                                  *
778500200529     C**                     ZFSIGN  1/                                  *
778600200529     C**                                                                 *
778700200529     C** ID F  C  H  L    FUNCTION OF INDICATORS
778800200529     C**
778900200529     C**       90         Decimal point found
779000200529     C**       91         Blank character found
779100200529     C**       92         After 1st time pass
779200200529     C**       93         Decimal point processed
779300200529     C**       95         No trailing blanks after decimal point position
779400200529     C**       96         Character 'M' found
779500200529     C**       97         Character 'T' found
779600200529     C**       99         SR ended abnormally - data invalid
779700200529     C**                                                                 *
779800200529     C********************************************************************
779900200529     C*                                                                  *
780000200529      * Midas DBA 3.00 ---------------- Base -------------------------*
780100200529     C*  LAST AMEND NO. 156689             DATE  08MAR99                 *
780200200529     C*  PREV AMEND NO. S01176             DATE 17/08/88                 *
780300200529     C*                                                                  *
780400200529     C*------------------------------------------------------------------*
780500200529     C*                                                                  *
780600200529     C*  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR    *
780700200529     C*  S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                     *S01176
780800200529     C*                                                                  *
780900200529     C********************************************************************
781000200529     C**
781100200529     CSR   ZASIGN        BEGSR                                                  *** ZASIGN ***
781200200529     C**
781300200529     C                   SETOFF                                       929399
781400200529     C**
781500200529     C**   SAVE INPUT FIELD IN ARRAY, ZS3.
781600200529     C**
781700200529     C                   MOVEA     ZFLD17        ZS3
781800200529     C**
781900200529     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
782000200529     C**
782100200529     C                   Z-ADD     ZSDIG         ZSDIG             2 0
782200200529     C                   Z-ADD     ZSDEC         ZSDEC             1 0
782300200529     C**                                                                  156689
782400200529     C**   DECIMAL SEPARATOR                                              156689
782500200529     C     ZSDCSP        IFEQ      *BLANK                                                      15668
782600200529     C                   MOVEL     '.'           ZSDCSP            1                           15668
782700200529     C                   ENDIF                                                                 15668
782800200529     C**
782900200529     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
783000200529     C**
783100200529     C                   MOVE      ' '           ZS4
783200200529     C                   MOVEA     ZS4           ZFLD17           17
783300200529     C                   Z-ADD     0             ZX                2 0
783400200529     C                   Z-ADD     0             ZY                2 0
783500200529     C                   MOVE      ' '           ZFSIGN            1
783600200529     C**
783700200529     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
783800200529     C**
783900200529     C     ZSDIG         ADD       ZSDEC         ZSINT             2 0
784000200529     C     ZSINT         CABGT     15            ZSEND                99
784100200529     C**
784200200529     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
784300200529     C**
784400200529     C                   DO        17            ZX
784500200529     C**
784600200529     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
784700200529     C**
784800200529     C***********ZS3,ZX    COMP '.'                      90               156689
784900200529     C     ZS3(ZX)       COMP      ZSDCSP                                 90                   15668
785000200529     C   90
785100200529     CAN 93              SETON                                        99
785200200529     C   99              GOTO      ZSEND
785300200529     C**
785400200529     C**   Check for 'M' constant. Error if not followed by '+', '-' or
785500200529     C**   blank.
785600200529     C**
785700200529     C     ZS3(ZX)       COMP      'M'                                    96
785800200529     C     *IN96         IFEQ      '1'
785900200529     C     ZX            CABGT     9             ZSEND                99
786000200529     C                   ADD       1             ZX
786100200529     C     ZS3(ZX)       IFNE      ' '
786200200529     C     ZS3(ZX)       ANDNE     '+'
786300200529     C     ZS3(ZX)       ANDNE     '-'
786400200529     C                   SETON                                        99
786500200529     C                   GOTO      ZSEND
786600200529     C                   END
786700200529     C                   SUB       1             ZX
786800200529     C**
786900200529     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
787000200529     C**
787100200529     C                   MOVE      ' '           ZS3(ZX)
787200200529     C**
787300200529     C** Fetch next arry element to check for '+' or '-' and bypass
787400200529     C** embedded blank edit as 'M' now replaced by ' '
787500200529     C**
787600200529     C                   ADD       1             ZX
787700200529     C                   END
787800200529     C**
787900200529     C**   Check for 'T' constant. Error if not followed by '+', '-' or
788000200529     C**   blank.
788100200529     C**
788200200529     C     ZS3(ZX)       COMP      'T'                                    97
788300200529     C     *IN97         IFEQ      '1'
788400200529     C     ZX            CABGT     12            ZSEND                99
788500200529     C                   ADD       1             ZX
788600200529     C     ZS3(ZX)       IFNE      ' '
788700200529     C     ZS3(ZX)       ANDNE     '+'
788800200529     C     ZS3(ZX)       ANDNE     '-'
788900200529     C                   SETON                                        99
789000200529     C                   GOTO      ZSEND
789100200529     C                   END
789200200529     C                   SUB       1             ZX
789300200529     C**
789400200529     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
789500200529     C**
789600200529     C                   MOVE      ' '           ZS3(ZX)
789700200529     C**
789800200529     C** Fetch next arry element to check for '+' or '-' and bypass
789900200529     C** embedded blank edit as 'T' now replaced by ' '
790000200529     C**
790100200529     C                   ADD       1             ZX
790200200529     C                   END
790300200529     C**
790400200529     C**   Check for '-' constant. Error if not followed by blank
790500200529     C**
790600200529     C     ZS3(ZX)       IFEQ      '-'
790700200529     C     ZX            IFLT      17
790800200529     C                   ADD       1             ZX
790900200529     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
791000200529     C                   SUB       1             ZX
791100200529     C                   END
791200200529     C**
791300200529     C** Place '-' in output sign field
791400200529     C**
791500200529     C                   MOVE      '-'           ZFSIGN
791600200529     C**
791700200529     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
791800200529     C**
791900200529     C                   MOVE      ' '           ZS3(ZX)
792000200529     C**
792100200529     C                   END
792200200529     C**
792300200529     C**   Check for '+' constant. Error if not followed by blank
792400200529     C**
792500200529     C     ZS3(ZX)       IFEQ      '+'
792600200529     C                   ADD       1             ZX
792700200529     C     ZX            IFLE      17                                                          S0117
792800200529     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
792900200529     C                   END                                                                   S0117
793000200529     C                   SUB       1             ZX
793100200529     C**
793200200529     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
793300200529     C**
793400200529     C                   MOVE      ' '           ZS3(ZX)
793500200529     C                   END
793600200529     C**
793700200529     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
793800200529     C**
793900200529     C   96
794000200529     COR 97              SUB       1             ZX
794100200529     C     ZS3(ZX)       COMP      ' '                                    91
794200200529     C   91
794300200529     CAN 92              GOTO      ZSTAG1
794400200529     C**
794500200529     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
794600200529     C**
794700200529     C  N90
794800200529     CANN91ZS3(ZX)       COMP      '0'                                  99
794900200529     C  N90
795000200529     CANN91
795100200529     CANN99ZS3(ZX)       COMP      '9'                                99
795200200529     C   99              GOTO      ZSEND
795300200529     C**
795400200529     C**   STORE DIGITS IN ARRAY AND HOW MANY.
795500200529     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
795600200529     C**   ZSINT, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
795700200529     C**
795800200529     C  N90
795900200529     CANN91              ADD       1             ZY                   92
796000200529     C     ZY            IFLE      15                                                          S0117
796100200529     C  N90
796200200529     CANN91              MOVE      ZS3(ZX)       ZS4(ZY)
796300200529     C                   END                                                                   S0117
796400200529     C   90              Z-ADD     ZY            ZSINT                93  93
796500200529     C**
796600200529     C** End of array read loop.
796700200529     C**
796800200529     C                   END
796900200529     C**
797000200529     C     ZSTAG1        TAG                                                    ** ZSTAG1 TAG *
797100200529     C**
797200200529     C**   IF 'M' SPECIFIED, MULTIPLY ZS3 BY 1 MILLION
797300200529     C**
797400200529     C     *IN96         IFEQ      '1'
797500200529     C                   ADD       6             ZSINT
797600200529     C                   ADD       6             ZSDIG
797700200529     C                   END
797800200529     C**
797900200529     C**   IF 'T' SPECIFIED, MULTIPLY ZS3 BY 1 THOUSAND
798000200529     C**
798100200529     C     *IN97         IFEQ      '1'
798200200529     C                   ADD       3             ZSINT
798300200529     C                   ADD       3             ZSDIG
798400200529     C                   END
798500200529     C**
798600200529     C**   IF CONSTANT SPECIFIED, MULTIPLY BY RESPECTIVE AMOUNT
798700200529     C**
798800200529     C   96              DO        6
798900200529     C                   ADD       1             ZY
799000200529     C                   MOVE      '0'           ZS4(ZY)
799100200529     C                   END
799200200529     C**
799300200529     C   97              DO        3
799400200529     C                   ADD       1             ZY
799500200529     C                   MOVE      '0'           ZS4(ZY)
799600200529     C                   END
799700200529     C**
799800200529     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZSINT
799900200529     C**
800000200529     C  N93              Z-ADD     ZY            ZSINT
800100200529     C**
800200200529     C**   CHECK FOR EMBEDDED BLANKS.
800300200529     C**
800400200529     C                   MOVE      *BLANKS       ZFLD17
800500200529     C   91
800600200529     CAN 92              MOVEA     ZS3(ZX)       ZFLD17
800700200529     C   91
800800200529     CAN 92ZFLD17        CABNE     ' '           ZSEND                9999
800900200529     C**
801000200529     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
801100200529     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
801200200529     C**
801300200529     C     ZSINT         COMP      ZSDIG                              99
801400200529     C     ZY            SUB       ZSINT         ZX
801500200529     C  N99ZSDEC         SUB       ZX            ZX                     9995
801600200529     C   99              GOTO      ZSEND
801700200529     C   95              GOTO      ZSTAG2
801800200529     C**
801900200529     C**   FILL THE TRAILING BLANKS WITH ZEROS.
802000200529     C**
802100200529     C                   DO        ZX
802200200529     C                   ADD       1             ZY
802300200529     C                   MOVE      '0'           ZS4(ZY)
802400200529     C                   END
802500200529     C**
802600200529     C**   RIGHT-ALIGN THE VALUE BY MOVING TO ARRAY, ZS5.
802700200529     C**
802800200529     C     ZSTAG2        TAG                                                    ** ZSTAG2 TAG *
802900200529     C                   MOVE      '0'           ZS5
803000200529     C                   Z-ADD     15            ZX
803100200529     C                   Z-ADD     16            ZY
803200200529     C                   DO        16
803300200529     C     ZS4(ZY)       IFNE      ' '
803400200529     C                   MOVE      ZS4(ZY)       ZS5(ZX)
803500200529     C                   SUB       1             ZX
803600200529     C                   END
803700200529     C                   SUB       1             ZY
803800200529     C                   END
803900200529     C**
804000200529     C**   Replace leading blanks with zeros.
804100200529     C**
804200200529     C                   Z-ADD     1             ZX
804300200529     C                   DO        15
804400200529     C     ZS5(ZX)       IFEQ      ' '
804500200529     C                   MOVE      '0'           ZS5(ZX)
804600200529     C                   ADD       1             ZX
804700200529     C                   ELSE
804800200529     C                   GOTO      ZSTAG3
804900200529     C                   END
805000200529     C                   END
805100200529     C**
805200200529     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFLD17.
805300200529     C**
805400200529     C     ZSTAG3        TAG                                                    ** ZSTAG3 TAG *
805500200529     C                   MOVEA     ZS5           ZOUT15           15
805600200529     C**
805700200529     C**   If output sign field is not -ive, make +ive.
805800200529     C**
805900200529     C     ZFSIGN        IFNE      '-'
806000200529     C                   MOVE      '+'           ZFSIGN
806100200529     C                   END
806200200529     C**
806300200529     C                   SETOFF                                       9697
806400200529     C**
806500200529     CSR   ZSEND         ENDSR                                                  * ZSEND ENDSR *
806600200529     C*****************************************************************
806700200529      /EJECT
806800200529     C*/COPY ZSRSRC,ZSEDITZ3
806900200529     C********************************************************************
807000200529     C********************************************************************
807100200529     C**                                                                 *
807200200529     C** ZSEDIT subroutine to insert a decimal point and sign into a     *
807300200529     C** numeric field and to blank out leading zeros (optionaly         *
807400200529     C** inserting commas).                                              *
807500200529     C**     Input fields:   ZFLD15 15/0                                 *
807600200529     C**                     ZDECS  1/0                                  *
807700200529     C**                     ZECODE 1/  ('J', 'L' or blank)              *
807800200529     C**                                                                 *
807900200529     C**     Arrays:         ZS1    15/1/0                               *
808000200529     C**                     ZS2    21/1/                                *
808100200529     C**                                                                 *
808200200529     C**     Output fields:  ZOUT21 21                                   *
808300200529     C**                                                                 *
808400200529     CSR   ZSEDIT        BEGSR                                                  **  ZSEDIT   *
808500200529     C*
808600200529     C* Define/Clear fields
808700200529     C*
808800200529     C                   Z-ADD     ZFLD15        ZFLD15           15 0
808900200529     C                   Z-ADD     ZDECS         ZDECS             1 0
809000200529     C                   MOVE      ZECODE        ZECODE            1
809100200529     C                   MOVE      *BLANKS       ZOUT21           21
809200200529     C*
809300200529     C*       SET UP WORK FIELDS
809400200529     C*
809500200529     C                   Z-ADD     0             ZS1
809600200529     C                   MOVE      ' '           ZS2
809700200529     C*
809800200529     C                   Z-ADD     15            Z1                2 0
809900200529     C                   Z-ADD     20            Z2                2 0
810000200529     C*
810100200529     C     15            SUB       ZDECS         ZINTS             2 0
810200200529     C*
810300200529     C* Check if numeric field is negative
810400200529     C*
810500200529     C     ZFLD15        IFLT      *ZEROS
810600200529     C                   MOVE      '-'           ZS2(21)
810700200529     C                   Z-SUB     ZFLD15        ZFLD15
810800200529     C                   END
810900200529     C*
811000200529     C                   Z-ADD     ZFLD15        WORK15
811100200529     C*
811200200529     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
811300200529     C*
811400200529     C     ZDECS         CABEQ     0             ZS10
811500200529     C*
811600200529     C*       SET UP DECIMALS
811700200529     C*
811800200529     C                   Z-ADD     *ZEROS        ZCNT              1 0
811900200529     C     ZCNT          DOUEQ     ZDECS
812000200529     C                   MOVE      ZS1(Z1)       ZS2(Z2)
812100200529     C                   SUB       1             Z2
812200200529     C                   ADD       1             ZCNT
812300200529     C                   SUB       1             Z1
812400200529     C                   END
812500200529     C*
812600200529     C*       PUT IN DECIMAL PLACE
812700200529     C*
812800200529     C                   MOVE      '.'           ZS2(Z2)
812900200529     C                   SUB       1             Z2
813000200529     C*
813100200529     C     ZS10          TAG                                                    ** ZS10 TAG **
813200200529     C*
813300200529     C*       SET UP INTEGERS
813400200529     C*
813500200529     C                   Z-ADD     *ZEROS        CNT3              1 0
813600200529     C     Z1            DOUEQ     *ZEROS
813700200529     C                   MOVE      ZS1(Z1)       ZS2(Z2)
813800200529     C                   SUB       1             Z1
813900200529     C                   SUB       1             Z2
814000200529     C*
814100200529     C* If edit code is 'J', insert a ',' before each group of three
814200200529     C* digits - not if beginning of array reached.
814300200529     C*
814400200529     C     Z2            IFGT      *ZEROS
814500200529     C     ZECODE        ANDEQ     'J'
814600200529     C                   ADD       1             CNT3
814700200529     C     CNT3          IFEQ      3
814800200529     C                   MOVE      ','           ZS2(Z2)
814900200529     C                   SUB       1             Z2
815000200529     C                   Z-ADD     *ZEROS        CNT3
815100200529     C                   END
815200200529     C                   END
815300200529     C*
815400200529     C                   END
815500200529     C*
815600200529     C*       PUT IN LEADING BLANKS
815700200529     C*
815800200529     C                   Z-ADD     1             Z2
815900200529     C     ZS2(Z2)       DOWEQ     '0'
816000200529     C     ZS2(Z2)       OREQ      ' '
816100200529     C     ZS2(Z2)       OREQ      ','
816200200529     C                   MOVE      ' '           ZS2(Z2)
816300200529     C                   ADD       1             Z2
816400200529     C     Z2            CABEQ     22            ZS20
816500200529     C                   END
816600200529     C*
816700200529     C*       IF NO INTEGERS PUT IN LEADING ZERO
816800200529     C*
816900200529     C     ZS20          TAG                                                    ** ZS20 TAG **
817000200529     C*
817100200529     C     Z2            IFEQ      22
817200200529     C                   SUB       2             Z2
817300200529     C                   MOVE      '0'           ZS2(Z2)
817400200529     C                   ELSE
817500200529     C*
817600200529     C     ZS2(Z2)       IFEQ      '.'
817700200529     C                   SUB       1             Z2
817800200529     C                   MOVE      '0'           ZS2(Z2)
817900200529     C                   END
818000200529     C                   END
818100200529     C*
818200200529     C*       SET UP OUTPUT FIELD
818300200529     C*
818400200529     C                   MOVEA     ZS2           ZOUT21
818500200529     C*
818600200529     CSR                 ENDSR
818700200529     C*****************************************************************
818800200529      /EJECT
818900200529     C*/COPY ZSRSRC,ZACCH
819000200529      /EJECT
819100200529      *****************************************************************
819200200529      * Midas DBA 3.00 ---------------- Base -------------------------*
819300200529      *  Last Amend No. 154799             Date 24Feb99               *
819400200529      *   Prev Amend No 115603                Date 23APR97
819500200529      *---------------------------------------------------------------*
819600200529      *  154799 - Array index error                                   *
819700200529      *           Restore DGJDNB and DGDDNB from ZSJAN and ZSDCM as   *
819800200529      *           they may have been changed by other SR(ZF2C).       *
819900200529      *           Applied fix 115603.                                 *
820000200529      *   115603  - ARRAY INDEX ERROR
820100200529      *             RESTORE DGJDNB AND DGDDNB FROM ZSJAN AND ZSDCM AS THEY MAY
820200200529      *             HAVE BEEN CHANGED BY OTHER SR(ZF2C)
820300200529      *****************************************************************
820400200529     C     ZACCH         BEGSR
820500200529      *
820600200529      * This standard sub-routine is to be used in conjunction with
820700200529      * the holiday standard sub-routines. Its function is to
820800200529      * determine if the access program AOHOLS0 needs to be called and
820900200529      * sets up the holiday record appropriately. It is common to all
821000200529      * the new holiday sub-routines, but should only be included in
821100200529      * a program once, using /COPY.
821200200529      *
821300200529      *
821400200529      * If stored parameters from last call are not within the same
821500200529      * bounds - ie. same ccy/location and date is within 1st. Jan &
821600200529      * 31st. Dec of current holiday record - continue processing.
821700200529      *
821800200529      **
821900200529      *Define input parameters
822000200529      **
822100200529     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
822200200529     C                   MOVE      ZCCY          ZCCY              3
822300200529     C                   MOVE      ZLOC          ZLOC              3
822400200529     C                   MOVE      ZOPTN         ZOPTN             7
822500200529     C*
822600200529     C     ZOPTN         IFEQ      '*FREE  '                                      IF 2
822700200529     C*
822800200529     C                   CALL      'AOHOLS0'
822900200529     C                   PARM      *BLANK        RTNCD
823000200529     C                   PARM                    ZOPTN
823100200529     C                   PARM      ZCCY          ZZCCY
823200200529     C                   PARM      ZLOC          ZZLOC
823300200529     C                   PARM      ZDAYNO        ZZDYNO
823400200529     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B
823500200529     C*
823600200529     C                   ELSE                                                                  S0119
823700200529     C*
823800200529     C     ZCCY          IFNE      ZSCCY                                        IF 1
823900200529     C     ZLOC          ORNE      ZSLOC                                         OR
824000200529     C     ZDAYNO        ORLT      ZSJAN                                         OR
824100200529     C     ZDAYNO        ORGT      ZSDCM                                         OR
824200200529      *
824300200529      * Get appropriate holiday record
824400200529      *
824500200529     C                   CALL      'AOHOLS0'
824600200529     C                   PARM      *BLANK        RTNCD
824700200529     C                   PARM                    ZOPTN
824800200529     C                   PARM      ZCCY          ZZCCY
824900200529     C                   PARM      ZLOC          ZZLOC
825000200529     C                   PARM      ZDAYNO        ZZDYNO            5 0
825100200529     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B
825200200529      *
825300200529      * If no record was found, assume all days in year are working
825400200529      * days.
825500200529      *
825600200529     C     RTNCD         IFEQ      '*NRF   '                                      IF 2
825700200529      *
825800200529     C                   MOVE      *ALL' '       ZHL
825900200529      *
826000200529      * Save 1st. Jan/31st. Dec dates as input date as we cannot say
826100200529      * anything about this year in future calls.
826200200529      *
826300200529     C                   Z-ADD     ZDAYNO        ZSJAN
826400200529     C                   Z-ADD     ZDAYNO        ZSDCM
826500200529      *
826600200529     C                   ELSE                                                     ELSE 2
826700200529      *
826800200529      * Save 1st. Jan/31st. Dec for future calls
826900200529      *
827000200529     C                   Z-ADD     DGJDNB        ZSJAN
827100200529     C                   Z-ADD     DGDDNB        ZSDCM
827200200529      *
827300200529      * Left adjust the holiday array over FEB 29th if the
827400200529      * holiday record is not for a leap year.
827500200529      *
827600200529     C                   MOVE      DGYRNB        Z@YR              4 0
827700200529     C     Z@YR          DIV       4             Z@WK1             4 0
827800200529     C                   MVR                     Z@WK2             4 0
827900200529     C*
828000200529     C     Z@WK2         IFNE      0
828100200529     C*
828200200529     C                   MOVEA     ZHL           ZHL1
828300200529     C                   MOVEA     ZHL1(61)      ZHL(60)
828400200529     C*
828500200529     C                   END
828600200529     C*
828700200529     C                   END                                                      FI 2
828800200529      *
828900200529      * Save currency and location for future calls. Need to save
829000200529      * return code as well.
829100200529      *
829200200529     C                   MOVE      ZCCY          ZSCCY
829300200529     C                   MOVE      ZLOC          ZSLOC
829400200529     C                   MOVE      RTNCD         ZSRTN
829500200529      *
829600200529     C                   ELSE                                                   ELSE 1
829700200529      *
829800200529      * Move saved return code back again as there may have been no
829900200529      * record found last time.
830000200529      *
830100200529     C**********           Z-ADDZSJAN     DGJDNB                          115603
830200200529     C**********           Z-ADDZSDCM     DGDDNB                          115603
830300200529     C                   Z-ADD     ZSJAN         DGJDNB                                        15479
830400200529     C                   Z-ADD     ZSDCM         DGDDNB                                        15479
830500200529     C                   MOVE      ZSRTN         RTNCD
830600200529      *
830700200529     C                   END                                                    FI 1
830800200529      *
830900200529     C                   END
831000200529      *
831100200529     C                   ENDSR
831200200529      *****************************************************************
831300200529      /EJECT
831400200529      *
831500200529     C*/COPY ZSRSRC,ZCHKH
831600200529      *****************************************************************
831700200529      *                                                               *
831800200529      *  Midas - /COPY Member (RPG)                                   *
831900200529      *                                                               *
832000200529      *  ZCHKH - Check if Holiday for Ccy/Locn                        *
832100200529      *                                                               *
832200200529      * Midas DBA 3.00 ---------------- Base -------------------------*
832300200529      *  Last Amend No. 151295  *CREATE    Date ddmmmyy               *
832400200529      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
832500200529      *                                                               *
832600200529      *---------------------------------------------------------------*
832700200529      *                                                               *
832800200529      *  151295 - Problems authorising repayment schedules.           *
832900200529      *                                                               *
833000200529      *****************************************************************
833100200529      *
833200200529      /EJECT
833300200529      *****************************************************************
833400200529     C     ZCHKH         BEGSR
833500200529      **
833600200529      *Define input parameters
833700200529      **
833800200529     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
833900200529     C                   MOVE      ZCCY          ZCCY              3
834000200529     C                   MOVE      ZLOC          ZLOC              3
834100200529      **
834200200529      *Define output parameter
834300200529      **
834400200529     C                   MOVE      ZIND          ZIND              1
834500200529      *
834600200529      * Standard sub-routine to determine if a MIDAS day no. is a
834700200529      * holiday or working day for a given currency and (optionally)
834800200529      * location.
834900200529      * NB. This sub-routine must be used in conjunction with ZACCH.
835000200529      *
835100200529      * Access holiday record.
835200200529      *
835300200529      *
835400200529     C                   MOVE      '*SETGT '     ZOPTN
835500200529     C                   EXSR      ZACCH
835600200529      *
835700200529      * If no record was found then all days for year are assumed to be
835800200529      * working days, so set holiday indicator appropriately.
835900200529      *
836000200529     C     RTNCD         IFEQ      '*NRF   '                                    IF 1
836100200529      *
836200200529     C                   MOVE      'W'           ZIND
836300200529      *
836400200529     C                   ELSE                                                   ELSE 1
836500200529      *
836600200529      * Subtract 1st. Jan date from given date and add 1 to give the
836700200529      * nth day in the year (ZINDX).
836800200529      *
836900200529     C     ZDAYNO        IFGT      ZSJAN                                                       15129
837000200529     C     ZDAYNO        SUB       ZSJAN         ZINDX                                         15129
837100200529     C                   ADD       1             ZINDX                                         15129
837200200529     C                   ELSE                                                                  15129
837300200529     C     ZDAYNO        SUB       DGJDNB        ZINDX
837400200529     C                   ADD       1             ZINDX
837500200529     C                   ENDIF                                                                 15129
837600200529      *
837700200529      * Move the nth day in the year value to the holiday indicator
837800200529      *
837900200529     C                   MOVE      ZHL(ZINDX)    ZIND
838000200529      *
838100200529      * If holiday indicator is 'X' change to 'H' to show holiday
838200200529      *
838300200529     C     ZIND          IFEQ      'X'                                           IF 2
838400200529     C                   MOVE      'H'           ZIND
838500200529     C                   ELSE
838600200529     C                   MOVE      'W'           ZIND
838700200529     C                   END                                                     FI 2
838800200529      *
838900200529     C                   END                                                    FI 1
839000200529      *
839100200529     C                   ENDSR
839200200529      *
839300200529      *****************************************************************
839400200529      * End of /COPY ZCHKH                                            *
839500200529      *****************************************************************
839600200529      /EJECT
839700200529      *
839800200529     C/EJECT
839900200529      *****************************************************************
840000200529**CTDATA ZYDY
8401002005290366073110961461
840200200529**CTDATA ZMDY
840300200529000031059090120151181212243273304334365
840400200529**CTDATA ZMNM
840500200529JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
840600200529**CTDATA CPY@
840700200529(c) Finastra International Limited 2001
840800200529**CTDATA TXT
840900200529F3=Exit  F5=Refresh Screen  F11=View Option(s) Rollup/Rolldown
841000200529F3=Exit  F5=Refresh Screen  F9=Go to 'Change' Mode  Rollup/Rolldown
841100200529F3=Exit  F5=Refresh Screen  F9=Go to 'Add' Mode  Rollup/Rolldown
841200200529F3=Exit  F11=View Option(s)  F12=Previous
841300200529F3=Exit  F11=Change Option(s)  F12=Previous
841400200529F3=Exit  F12=Previous
841500200529F3=Exit  F11=View Option(s)    F12=Previous  F8=Subordinate Action                            CSE020
841600200529F3=Exit  F11=Change Option(s)  F12=Previous  F8=Subordinate Action                            CSE020
841700200529F3=Exit  F5=Refresh  F9=Go to 'Add' Mode  Rollup/Rolldown  F12=Parent Action                  CSE020
841800200529F3=Exit  F5=Refresh  F9=Go to Change Mode  Rollup/Rolldown  F12=Parent Action                 CSE020
841900200529**CTDATA NARR
842000200529ERROR CALL PGM 'SE7599'
842100200529ERROR CALL PGM 'SE7510'
842200200529ERROR CALL PGM 'SE7511'
842300200529OPTION SHORTNAME NUMBER
842400200529ERROR CALL PGM 'SE7512'
842500200529ERROR CALL PGM 'SE7514'
842600200529ERROR CALL PGM 'SE7520'                                                   CEU017
842700200529ERROR CALL PGM 'SE7533'
842800200529ERROR CALL PGM 'SE7540'
