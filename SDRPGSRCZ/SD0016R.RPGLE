     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Currency/Time of Netting Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0016R - Curency/Time of Netting Maintenance                *
      *                                                               *
      *  Function:  This program maintains the Curr/Time of Netting   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG7129            Date 11May05               *
      *                 CDL025   *CREATE   Date 10Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG7129- FX Netting set up should be unique to customer      *
      *  CDL025 - FX Netting Payment Generation                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    33         Invalid Country of Treaty                       *
      *    34         Invalid Income Code                             *
      *    35         Invalid Narrative                               *
      *    40         Global Error Indicator                          *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    78         Protect Country of Treaty and Income Code       *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SRSubfileRec  -  Process modified subfile record             *
      *  SRAction      -  Process subfile record                      *
      *  SRValidKey    -  Validate subfile record                     *
      *  SRValidate    -  Validate subfile record relations           *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRUpdReq      -  Process update request                      *
      *  SRDelReq      -  Process delete request                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRWrite       -  Create                                      *
      *  SRAmend       -  Amende                                      *
      *  SRDelete      -  Delete           es                         *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Screen Formats
     FSD0016DF  CF   E             WORKSTN USROPN
     F                                     SFILE(SD0016F0:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
      ** Currency/Time of Netting - Retrieve
     FSDCTNML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SDCTNMP0:CTNMV0)
      *
      ** Currency/Time of Netting - Update
     FSDCTNML1  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SDCTNMP0:CTNMV1)
     F                                     COMMIT
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------------------------
 
      /EJECT
 
      ** Array of TIME for validation
     D ARTime          S              1A   DIM(5)
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *  Customer Details format for access object pgm
     D SDCUST        E DS                  ExtName(SDCUSTPD)
 
      ** External data structure for Currency Details file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  ExtName(DSFDY)
 
     D DSTime          DS
     D  W#Hrs                         2
     D  W#Mns                         2
 
     D @RUN            S              1
 
      ** Define Key Fields
     D K#CUST          S                   Like(LCUST)
     D K#LCCY1         S                   Like(LCCY1)
     D K#LCCY2         S                   Like(LCCY2)
 
      ** Define Passed Fields
     D P#RtCd          S              7A
     D P#Cust          S                   Like(BBCUST)
     D P#NTCP          S                   Like(BBNTCP)
     D P#Mode          S              1A
 
      ** Define Parameter fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKySt           S              7A
 
      ** Define Work Fields
     D W#Cnt           S              5S 0
     D W#LRcd          S              4S 0
     D W#SfPg          S              3S 0 Inz(12)
     D W#2S0           S              2S 0
     D X               S              1S 0
     D W#Posn1         S                   Like(LCCY1)
     D W#Posn2         S                   Like(LCCY2)
     D W#TXND          S              1
     D W#PMD           S              3
     D W#IPin          S              1
     D W#RSF           S              1
     D W#Eror          S              1
     D W#Error         S              1
 
      /EJECT
      *****************************************************************
      *
      ** Main Program
      *
      *****************************************************************
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
     C                   Exsr      SRBuild
     C                   Eval      W#RSF = 'N'
 
      ** Display screen until reload requested
     C                   DoW       W#RSF = 'N'
 
      ** Display screen
     C                   Exsr      SRDisplay
 
      ** Process response
     C                   Select
      ** CMD3 - Exit
     C                   When      *In03 = *On
     C                   Eval      P#Rtcd = '03'
     C                   Exsr      SREnd
 
      ** CMD3 - Exit
     C                   When      *In12 = *On
     C                   Eval      P#Rtcd = '12'
     C                   Exsr      SREnd
 
      ** CMD5 - Refresh
     C                   When      *In05 = *On
     C                   Eval      W#RSF = 'Y'
     C                   Eval      SPOSN1 = *Blanks
     C                   Eval      SPOSN2 = *Blanks
     C                   Eval      S1SEL = *Blanks
      *
      ** Rollup
     C                   When      *In27 = *On
     C                   Exsr      SRLoad
 
     C                   Other
     C                   Exsr      SRProcess
     C                   EndSl
 
     C                   EndDo
 
     C                   EndDo
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRLoad, SRZasnms                                   *
      *                                                               *
      *****************************************************************
     C     SRBuild       BegSr
 
      ** Initialise & load subfile page
     C                   Eval      *In80 = *On
     C                   Write     SD0016F1
     C                   Eval      *In80 = *Off
     C                   Eval      *In81 = *Off
 
      ** Reset Number of Records in Subfile
     C                   Eval      W#LRCD = 0
 
      ** If CHANGE mode, then position file
     C                   If        W#PMD <> 'ADD'
     C                   Eval      K#Cust = P#Cust
     C                   Eval      W#Posn1 = SPosn1
     C                   Eval      W#Posn2 = SPosn2
     C                   Eval      K#LCCY1 = SPosn1
     C                   Eval      K#LCCY2 = SPosn2
 
      ** Setup key
     C     KEY1          Setll     CTNMV0                             82
     C*********          Read      CTNMV0                                 82              BUG7129
     C     KEY1          ReadE     CTNMV0                                 82              BUG7129
     C                   Else
     C                   Eval      *In82 = *Off
     C                   EndIf
 
      ** Load subfile page
     C                   Exsr      SRLoad
 
      ** If no records found, display error message
     C                   If        *In82 and SRLRN = 0
     C                   MoveL     'USR7560'     WZMsgID
     C                   Exsr      SRZasnms
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      *                                                               *
      * Calls    : SRMove, SRValidate, SRProtect                      *
      *                                                               *
      *****************************************************************
     C     SRLoad        BegSr
 
      ** Load subfile page but write empty page if add mode
     C                   Eval      *In84 = *Off
 
      ** Start at previous highest record in SFL
     C                   Eval      SRLRN = W#LRCD
     C                   Eval      W#Cnt = 1
 
      ** Load next subfile page
     C                   DoW       *In82 = *Off and W#Cnt <= W#SfPg
 
      ** Select records by Paired or Single currency
     C                   If        W#PMD = 'ADD' or
     C                             (W#PMD <> 'ADD' and P#NTCP = LNTCP)
     C                   Eval      SRLRN = SRLRN + 1
     C                   Movea     '000000'      *IN(32)
     C                   Eval      *In87 = *Off
 
      ** Protect fields during Enquiry Mode
     C                   If        P#Mode = 'E'
     C                   Eval      *IN77 = *On
     C                   Eval      *IN78 = *On
     C                   Eval      *IN79 = *On
     C                   Eval      *IN87 = *On
     C                   EndIf
 
      ** Clear subfile fields
     C                   Clear                   SD0016F0
 
      ** If CHANGE mode, load subfile fields
     C                   If        W#PMD <> 'ADD'
     C                   Eval      S#RNTD = LRNTD
     C                   Eval      S#TIME = LTIME
     C                   Eval      S#LCCY1 = LCCY1
     C                   Eval      S#LCCY2 = LCCY2
     C                   Move      LRNTD         SLRNTD
     C                   Eval      SLCCY1 = LCCY1
     C                   Eval      SLCCY2 = LCCY2
     C                   If        LTIME <> *Blanks
     C                   Move      LTIME         DSTime
     C                   Eval      SLTime = W#Hrs + ':' + W#Mns
     C                   Else
     C                   Eval      SLTime = *Blanks
     C                   EndIf
     C                   Endif
 
      ** Output to subfile
     C                   Eval      W#Cnt = W#Cnt + 1
     C                   Eval      *In81 = *On
 
      ** Set screen conditioning indicators
     C                   Exsr      SRProtect
     C                   Write     SD0016F0
 
     C                   EndIf
 
      ** End of File
     C                   If        W#PMD <> 'ADD'
     C**********         Read      CTNMV0                                 82              BUG7129
     C     KEY1          ReadE     CTNMV0                                 82              BUG7129
     C                   EndIf
 
     C                   EndDo
 
      ** Save last record No.
     C                   Eval      W#LRCD = SRLRN
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : ZA0250                                            *
      *                                                               *
      *****************************************************************
     C     SRDisplay     BEGSR
 
     C                   Eval      SPOSN1 = *Blanks
     C                   Eval      SPOSN2 = *Blanks
      ** Set screen conditioning indicators
     C                   If        W#PMD = 'ADD'
     C                   Eval      *In89 = *On
     C                   Else
     C                   Eval      *In89 = *Off
     C                   EndIf
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
     C                   If        P#Mode = 'E'
     C                   Eval      *In31 = *On
     C                   EndIf
 
     C                   Time                    STime
     C                   Write     #MSGCTL
     C                   Write     SD0016F2
     C                   ExFmt     SD0016F1
 
      ** Clear messages from program message queue
     C                   Call      'ZA0250'
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRSubfileRec, SRUpdate                             *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Change of position specified
     C                   If        W#PMD <> 'ADD' and
     C                             (W#Posn1 <> SPOSN1 or W#Posn2 <> SPOSN2)
     C                   Eval      W#RSF = 'Y'
     C                   EndIf
 
      ** Quit if reload requested
     C                   If        W#RSF <> 'Y'
 
     C                   If        *In81 = *On and *In09 = *Off
     C                   Eval      W#IPin = 'N'
 
      ** Process subfile records
     C                   Exsr      SRSubfileRec
 
      ** Update DBF from subfile
     C                   If        *In40 = *Off and W#IPin = 'Y'
     C                   Exsr      SRUpdate
     C                   EndIf
 
     C                   EndIf
 
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
     C                   If        *In09 = *On and *In40 = *Off
 
      ** Switch between *ADD/*CHANGE modes
     C                   If        W#PMD <> 'ADD'
     C                   Eval      W#PMD = 'ADD'
     C                   Else
     C                   Eval      W#PMD = 'CHG'
     C                   EndIf
 
     C                   Eval      W#RSF = 'Y'
     C                   Eval      SPOSN1 = *Blanks
     C                   Eval      SPOSN2 = *Blanks
     C                   Eval      S1SEL = *Blanks
 
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubfileRec - Process Modified Subfile Record                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRAction, SRProtect                                *
      *                                                               *
      *****************************************************************
     C     SRSubfileRec  BegSr
 
      ** Process modified subfile record
     C                   ReadC     SD0016F0                               62
 
     C                   DoW       *In62 = *Off
     C                   Exsr      SRAction
     C                   Eval      *In87 = *Off
     C                   Exsr      SRProtect
     C                   UpDate    SD0016F0
 
     C                   ReadC     SD0016F0                               62
     C                   EndDo
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAction - Process Subfile Record                             *
      *                                                               *
      * Called by: SRSubfileRec                                       *
      *                                                               *
      * Calls    : SRNullRecord, SRValidKey                           *
      *                                                               *
      *****************************************************************
     C     SRAction      BEGSR
 
      ** Set off error indicators
     C                   MoveA     '000000'      *IN(32)
     C                   MoveA     '00'          *IN(83)
 
     C                   Eval      W#IPin = 'Y'
     C                   Eval      *In84 = *On
 
      ** Validate record
     C                   Exsr      SRValidKey
 
      ** Seton Global Error Indicator if error exists
     C                   If        *In83 = *On
     C                   Eval      *In40 = *On
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidKey - Validate Subfile Record                          *
      *                                                               *
      * Called by: SRAction                                           *
      *                                                               *
      * Calls    : SRZasnms, SRValidate                               *
      *                                                               *
      *****************************************************************
     C     SRValidKey    BegSr
 
     C                   MoveA     '00'          *In(41)
      ** In Add mode, need to move screen value to hidden file field
     C                   If        W#PMD = 'ADD'
     C                   Eval      S#LCCY1 = SLCCY1
     C                   Eval      S#LCCY2 = SLCCY2
 
      ** Currency1 is blank ?
     C     '?'           Scan      SLCCY1                                 41
     C                   If        SLCCY1 = *Blanks
     C                   Eval      *IN33 =*On
     C                   Eval      *IN83 =*On
     C                   Eval      WZMsgID = 'USR0233'
     C                   Exsr      SRZasnms
     C                   EndIf
 
      ** Currency2 is blank ?
     C                   If        *In70 = *On and SLCCY2 = *Blanks and
     C                             *In41 = *Off
     C                   Eval      *IN36 =*On
     C                   Eval      *IN83 =*On
     C                   Eval      WZMsgID = 'USR0233'
     C                   Exsr      SRZasnms
     C                   EndIf
 
     C                   Else
      ** Validate Action
     C                   If        S1SEL <> 'D' and S1SEL <> *Blanks
     C****                         and S1SEL <> 'A'
     C                   Eval      *IN32 =*On
     C                   Eval      *IN83 =*On
     C                   Eval      WZMsgID = 'USR7561'
     C                   Exsr      SRZasnms
     C                   EndIf
 
     C                   EndIf
 
      ** Validate subfile record relations
     C                   If        S1SEL <> 'D'
     C                   Exsr      SRValidate
     C                   EndIf
     C
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Subfile Record Relations                *
      *                                                               *
      * Called by: SRLoad, SRValidKey                                 *
      *                                                               *
      * Calls    : AOCTRYR0 - Access Country Codes                    *
      *            SRZasnms                                           *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Validate Currency Code
     C                   Call      'AOCURRR0'
     C                   Parm      '       '     PRTCD             7
     C                   Parm      '*KEY   '     POPTN             7
     C                   Parm      SLCCY1        @CRKEY            3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRTCD <> *BLANKS
     C                   Eval      *In33 = *On
     C                   Eval      *In83 = *On
     C                   Eval      WZMsgID = 'USR0235'
     C                   Exsr      SRZasnms
     C                   Else
     C                   Move      A6TXND        W#TXND
     C                   Eval      SLCCY1 = A6CYCD
     C                   If        W#PMD = 'ADD'
     C                   Eval      S#LCCY1 = A6CYCD
     C                   EndIf
     C                   EndIf
 
     C                   If        P#NTCP = 'Y'
     C     '?'           Scan      SLCCY2                                 42
     C                   If        (*In41 = *On and *In42 = *On) or
     C                             *In41 = *Off
      ** Validate Currency Code
     C                   Call      'AOCURRR0'
     C                   Parm      '       '     PRTCD             7
     C                   Parm      '*KEY   '     POPTN             7
     C                   Parm      SLCCY2        @CRKEY            3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRTCD <> *BLANKS
     C                   Eval      *In36 = *On
     C                   Eval      *In83 = *On
     C                   Eval      WZMsgID = 'USR0235'
     C                   Exsr      SRZasnms
     C                   Else
     C                   Eval      SLCCY2 = A6CYCD
     C                   If        W#PMD = 'ADD'
     C                   Eval      S#LCCY2 = A6CYCD
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   If        *In41 = *On or *In42 = *On
     C                   Eval      *In83 = *On
     C                   EndIf
 
      ** skip time validation if ? on currency
     C                   If        *In83 = *Off
      ** Validate Notice Days
      ** Valid Value 0-9
     C                   If        SLRNTD < '0' or SLRNTD > '9'
     C                   Eval      *In37 = *On
     C                   Eval      *In83 = *On
     C                   Eval      WZMsgID = 'USR4596'
     C                   Exsr      SRZasnms
     C                   EndIf
      ** Notice days must be < Telex days
     C                   If        SLRNTD > W#TXND
     C                   Eval      *In37 = *On
     C                   Eval      *In83 = *On
     C                   Eval      WZMsgID = 'USR4596'
     C                   Exsr      SRZasnms
     C                   EndIf
      ** Notice days OK
     C                   If        *In83 = *Off
     C                   Move      SLRNTD        S#RNTD
     C                   EndIf
 
      ** Validate Time
      *** Blanks is Valid 'Catch All' for COB
     C                   If        SLTIME = *Blanks
     C                   Eval      S#Time = *Blanks
     C                   Else
     C                   Eval      W#Error = 'N'
     C                   Eval      X = 0
     C                   MoveA     SLTime        ARTIME
     C                   DoU       X = 5
     C                   Eval      X = X + 1
     C                   If        ARTIME(X) < '0' or ARTIME(X) >'9'
     C                   Select
      ** InValid - Ok If 3rd char and a colon
     C                   When      X = 3 and ARTIME(X) = ':'
 
      ** If its 5th char is Blank and 3rd is not : Ok
     C                   When      X = 5 and
     C                             ARTIME(3) <> ':' and ARTIME(5) = ' '
 
     C                   Other
     C                   Eval      W#Error = 'Y'
     C                   Leave
 
     C                   EndSl
     C                   EndIf
     C                   EndDo
 
     C                   If        W#Error = 'N' and
     C                             ARTIME(3) <> ':' and ARTIME(5) <> ' '
     C                   Eval      W#Error = 'Y'
     C                   EndIF
 
      ** Set up time fields for file
     C                   If        W#Error <> 'Y'
     C                   Eval      W#Hrs = ARTime(1) + ARTime(2)
     C                   If        ARTime(3) <> ':'
     C                   Eval      W#Mns = ARTime(3) + ARTime(4)
     C                   Else
     C                   Eval      W#Mns = ARTime(4) + ARTime(5)
     C                   Endif
      ** Valid Hours ?
     C                   Move      W#Hrs         W#2S0
     C                   If        W#2S0 < 7 or W#2S0 > 19
     C                   Eval      W#Error = 'Y'
     C                   Endif
     C                   Endif
      ** Valid Mins ?
     C                   If        W#Error <> 'Y' and
     C                             W#Mns <> '00' and W#Mns <> '30'
     C                   Eval      W#Error = 'Y'
     C                   Endif
      ** Valid time
     C                   If        W#Hrs = '19' and W#Mns <> '00'
     C                   Eval      W#Error = 'Y'
     C                   Endif
 
     C                   If        W#Error = 'Y'
     C                   Eval      *In34 = *On
     C                   Eval      *In83 = *On
     C                   Eval      WZMsgID = 'USR4597'
     C                   Exsr      SRZasnms
     C                   Else
     C                   Move      DSTime        S#Time
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDetail, SRProtect                                *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BegSr
 
      ** Initialise subfile reload flag
     C                   If        W#PMD = 'ADD'
     C                   Eval      W#RSF = 'Y'
     C                   Else
     C                   Eval      W#RSF = 'N'
     C                   EndIf
 
      ** Process all modified subfile records
     C                   ReadC     SD0016F0                               62
 
     C     *IN62         DowEQ     '0'
     C                   Exsr      SRDetail
 
      ** Rollback any DBF changes if error occur
      *
     C                   If        W#EROR <> *BLANKS
     C                   Rolbk
     C                   Else
     C                   Commit
     C                   EndIf
 
      ** Set screen conditioning indicators
     C                   Eval      S1Sel = *BLANKS
     C                   Exsr      SRProtect
     C                   UpDate    SD0016F0
 
     C                   ReadC     SD0016F0                               62
     C                   EndDo
 
      ** Cancel reload if errors occur
     C                   If        *IN40 = *On
     C                   Eval      W#RSF = 'N'
     C                   EndIf
 
     C                   EndSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls    : SRNullRecord, SRAddReq, SRDelReq, SRUpdReq         *
      *                                                               *
      *****************************************************************
     C     SRDetail      BEGSR
 
      ** Set off error indicators
     C                   MoveA     '000000'      *IN(32)
     C                   Eval      *In83 = *Off
 
      ** Process add request
     C                   If        W#PMD = 'ADD'
     C                   Exsr      SRAddReq
 
     C                   Else
      ** Process delete request
     C                   If        S1SEL = 'D'
     C                   Exsr      SRDelReq
     C                   Else
     C                   Exsr      SRUpdReq
     C                   Endif
     C                   EndIf
 
      * Errors ?
     C                   If        *IN83 = *On
     C                   Eval      *In40 = *On
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRWrite                                            *
      *                                                               *
      *****************************************************************
     C     SRAddReq      BegSr
 
      ** Create Record
     C                   Exsr      SRWrite
 
      ** Error detected
     C                   If        W#EROR <> *BLANKS
     C                   MoveA     '011111'      *IN(32)
     C                   MoveA     '11'          *IN(83)
     C                   Eval      *In87 = *Off
     C                   EndIf
 
     C                   EndSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdReq - Process Add Request                                *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRAmend                                            *
      *                                                               *
      *****************************************************************
     C     SRUpdReq      BegSr
 
      ** Create Record
     C                   Exsr      SRAmend
 
      ** Error detected
     C                   If        W#EROR <> *BLANKS
     C                   MoveA     '111111'      *IN(32)
     C                   MoveA     '11'          *IN(83)
     C                   Eval      *In87 = *Off
     C                   EndIf
 
     C                   EndSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRDelete                                           *
      *                                                               *
      *****************************************************************
     C     SRDelReq      BegSr
 
      ** Delete Record
     C                   Exsr      SRDelete
 
     C                   If        W#EROR <> *BLANKS
 
      ** Delete unsuccessful
     C                   MoveA     '111111'      *IN(32)
     C                   MoveA     '11'          *IN(83)
     C                   Eval      *In87 = *Off
     C                   Eval      S#RNTD = LRNTD
     C                   Eval      S#TIME = LTIME
     C                   Eval      S#LCCY1 = LCCY1
     C                   Eval      S#LCCY2 = LCCY2
     C                   Move      LRNTD         SLRNTD
     C                   Move      LTIME         DSTime
     C                   Eval      SLTime = W#Hrs + ':' + W#Mns
     C                   Eval      SLCCY1 = LCCY1
     C                   Eval      SLCCY2 = LCCY2
 
     C                   Else
 
      ** Blank out record and protect from entry
     C                   Clear                   SD0016F0
     C                   Eval      *In84 = *Off
     C                   Eval      *In87 = *On
 
      ** Reload subfile
     C                   Eval      W#RSF = 'Y'
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProtect - Set Display Attributes for Subfile Record         *
      *                                                               *
      * Called by: SRLoad, SRSubfileRec, SRUpdate                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRProtect     BegSr
      *
     C                   If        W#PMD = 'ADD'
     C                   Eval      *In89 = *On
     C                   Else
     C                   Eval      *In89 = *Off
     C                   EndIf
 
      ** Protect keys if change mode or updated record
     C                   Eval      *In79 = *In87
     C                   If        *In89 = *On
     C                   Eval      *In79 = *On
     C                   EndIf
 
     C                   Eval      *In78 = *In87
     C                   If        W#PMD = 'CHG'
     C                   Eval      *In78 = *On
     C                   EndIf
 
     C                   EndSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Currency/Time of Netting details             *
      *                                                               *
      * Called by: SRAddReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
     C     SRWrite       BegSr
 
     C                   Eval      W#Eror = *BLANKS
 
      ** Create New Record
     C                   Eval      LCust = P#Cust
     C                   Eval      LCCY1 = S#LCCY1
     C                   Eval      LCCY2 = S#LCCY2
     C                   Eval      LTime = S#Time
     C                   Eval      LRNTD = S#RNTD
     C                   Eval      LNTCP = P#NTCP
     C                   Eval      LTYLC = 'I'
     C                   Eval      LLCD = BJRDNB
 
      ** Check for duplicate primary key
     C                   Eval      K#LCCY1 = S#LCCY1
     C                   Eval      K#LCCY2 = S#LCCY2
     C*****KEY1          Setll     CTNMV1                                 60              BUG7129
     C     KEY2          Setll     CTNMV1                                 60              BUG7129
 
     C                   If        %Equal
     C                   Eval      W#Eror = 'Y'
     C                   Movel     'USR4598'     WZMsgID
     C                   Exsr      SRZasnms
     C                   Else
 
     C                   Write(e)  CTNMV1
 
      ** Write error detected
     C                   If        %Error
     C                   Eval      W#Eror = 'Y'
     C                   EndIf
 
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend - Create Currency/Time of Netting details             *
      *                                                               *
      * Called by: SRUpdReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
     C     SRAmend       BegSr
 
     C                   Eval      W#Eror = *BLANKS
 
      ** Check for duplicate primary key
     C                   Eval      K#LCCY1 = S#LCCY1
     C                   Eval      K#LCCY2 = S#LCCY2
     C*****KEY1          Chain     CTNMV1                                                 BUG7129
     C     KEY2          Chain     CTNMV1                                                 BUG7129
     C                   If        Not %Found
     C                   Eval      W#Eror = 'Y'
     C                   Else
      ** Update Record
     C                   Eval      LTime = S#Time
     C                   Eval      LRNTD = S#RNTD
     C                   Eval      LNTCP = P#NTCP
     C                   Eval      LTYLC = 'A'
     C                   Eval      LLCD = BJRDNB
 
     C                   Update(e) CTNMV1
 
      ** Write error detected
     C                   If        %Error
     C                   Eval      W#Eror = 'Y'
     C                   EndIf
 
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Currency/Time of Netting details            *
      *                                                               *
      * Called by: SRDelreq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
     C     SRDelete      BegSr
 
      ** Delete Currency/Time of Netting details
     C                   Eval      W#Eror = *Blanks
 
      ** Set Key Fields
     C                   Eval      K#LCCY1 = SLCCY1
     C                   Eval      K#LCCY2 = SLCCY2
 
     C                   If        W#Eror <> 'Y'
     C*****KEY1          Chain     CTNMV1                             6061                BUG7129
     C     KEY2          Chain     CTNMV1                             6061                BUG7129
 
      ** Record already deleted
     C                   If        *In60 = *On
     C                   Eval      W#Eror = 'Y'
     C                   Eval      WZMsgID = 'USR7566'
     C                   Exsr      SRZasnms
     C                   Else
 
      ** Record locked
     C                   If        *In61 = *On
     C                   Eval      W#Eror = 'Y'
     C                   Eval      WZMsgID = 'USR7567'
     C                   Exsr      SRZasnms
     C                   Else
 
     C                   Delete(e) CTNMV1
 
      ** Delete error detected
     C                   If        %Error
     C                   Eval      W#Eror = 'Y'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   Endif
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SREnd         BegSr
 
      ** Rollback any uncommitted DBF changes
     C                   RolBk                                          60
 
      ** Terminate program
     C                   Eval      *InLr = *On
 
      ** Exit program
     C                   Return
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************
     C     *InzSr        BegSr
 
      ** Receive entry parameters
     C     *Entry        PList
     C                   Parm                    P#RtCd
     C                   Parm                    P#Cust
     C                   Parm                    P#NTCP
     C                   Parm                    P#Mode
 
      ** Define LDA
     C     *Lock         In        LDA
     C                   Eval      DBPGM = 'SD0016'
     C                   Eval      DBFILE = *BLANKS
     C                   Eval      DBKEY =  *BLANKS
     C                   Eval      DBASE = 0
     C                   Out       LDA
 
      ** Obtain default message file
     C     *DtaAra       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
 
      ** Call Access Program for Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      '*MSG   '     PRtCd
     C                   Parm      '*FIRST '     POptn
     C     SDBANK        Parm      SDBANK        DSSDY
 
      ** Database error
     C                   If        PRtCd <> *Blanks
     C                   Eval      DBFILE = 'SDBANKPD'
     C                   Eval      DBASE = 1
     C                   Eval      DBKEY = POptn
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Retrieve Customer Details
     C                   Eval      PCust = P#Cust
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCust
     C                   Parm                    PKySt
     C     SDCUST        Parm      SDCUST        DSSDY
 
      ** Database error
     C                   If        PRtCd <> *Blanks
     C                   Eval      DBFILE = 'SDCUSTPD'
     C                   Eval      DBASE = 1
     C                   Eval      DBKEY = POptn
     C                   Exsr      *PSSR
     C                   EndIf
 
 
      ** Open files
      ** Screen Formats
     C                   Open      SD0016DF
      ** Retrieval File
     C                   If        Not %Open(SDCTNML0)
     C                   Open      SDCTNML0
     C                   EndIf
      ** Update File
     C                   If        Not %Open(SDCTNML1)
     C                   Open      SDCTNML1
     C                   EndIf
 
      ** Set to *CHANGE mode
     C                   Movel     'CHG'         W#PMD
 
      ** Initialise subfile control
     C                   Eval      SPOSN1 = *Blanks
     C                   Eval      SPOSN2 = *Blanks
     C                   Eval      SRUNA = BJMRDT
     C                   Eval      SPGM = PSProcName
     C                   Eval      SWSID = PSJobName
     C                   Eval      SUSER = PSUser
     C                   Eval      #1CUST = P#Cust
     C                   Eval      #1CSSN = BBCSSN
     C                   Eval      #1CNA1 = BBCNA1
      ** Set Paired currency Indicator
     C                   If        P#NTCP = 'Y'
     C                   Eval      *In70 = *On
     C                   Else
     C                   Eval      *In70 = *Off
     C                   EndIf
 
      ** Initialise Key Lists
     C     KEY1          KList
     C                   KFld                    K#CUST
     C**********         KFld                    K#LCCY1                                 BUG7129
     C**********         KFld                    K#LCCY2                                 BUG7129
 
     C     KEY2          KList                                                           BUG7129
     C                   KFld                    K#CUST                                  BUG7129
     C                   KFld                    K#LCCY1                                 BUG7129
     C                   KFld                    K#LCCY2                                 BUG7129
                                                                                         BUG7129
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BegSr
 
     C                   If        WZMsgFile = *BLANKS
     C                   Eval      WZMsgFile = ZADFMF
     C                   EndIf
 
     C                   Call      'ZA0340'
     C                   Parm                    WZMsgFile        10
     C                   Parm                    WZMsgID          10
 
     C                   Eval      WZMsgFile = *Blanks
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   Dump
 
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   Call      'DBERRCTL'
     C                   EndIf
      *
     C                   Eval      *InU7 = *ON
     C                   Eval      *InU8 = *ON
     C                   Eval      *InLR = *ON
     C                   Return
 
     C                   EndSr
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
