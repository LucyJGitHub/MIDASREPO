     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Normal Cust/NAHO Classfn Upd - List Enq')     *
      *****************************************************************
      *  Includes MD025814, MD024747                                  *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000552 - Normal Customer/NAHO Classification Upd - List    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027209B          Date 25Sep14               *
      *                 MD027335           Date 20Aug14               *
      *                 MD027209           Date 07Aug14               *
      *                 CGL132   *CREATE   Date 01Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027209B - F4-Print Report is not available in USIT and NCUP*
      *  MD027335 - Incorrect Label for NAHO enquired after           *
      *             Information/Update Mode                           *
      *  MD027209 - F4-Print Report is not available in USIT and NCUP *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
     FSD000552DFCF   E             WORKSTN SFILE(SD000552S0:WSflRRN)
     F                                     INFSR(*PSSR)
      ** FATCA Customers for Classfn Update - List
     FSDNACUL0  IF   E             DISK
 
      ** FATCA Customers for Classfn Update - Keyed
     FSDNACUL1  IF   E           K DISK    RENAME(SDNACUD0:SDNACUD1)
     F                                     PREFIX(W)
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
     D SDNACU        E DS                  EXTNAME(SDNACUPD)
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
      *
     D Mode            S              7A
     D ReturnDS        DS
     D RetCode                        7A
     D ClsCode                        5A
     D ClsDesc                       50A
      *
     D DetMode         S              1A
     D DetRetCode      S              7A
     D DetClsCode      S              5A
 
     D PRetCode        S              7
     D POption         S              7
     D PClsCode1       S              5A
     D PClsDesc1       S             50A
     D PClsCode2       S              5A
     D PClsDesc2       S             50A
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WSFlRRN         S              4  0
     D WClsCdValPrm    S              5    INZ(*Blanks)
     D WValErr         S              1
     D WRetCode        S              7    INZ(*Blanks)
     D Recursive       S              1    INZ('N')
      *
     D ZAPGM           S             10    INZ('SD000552')
     D ZAPGRL          S              5    INZ(*Blanks)
     D ZAMSID          S              7    INZ(*Blanks)
     D ZAMSGF          S             10    INZ(*Blanks)
     D ZAMSDA          S            132    INZ(*Blanks)
     D ZAMSTP          S              7    INZ(*Blanks)
      *
 
      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************
      *
      *
      ** Invoke List Screen
      *
     C                   EXSR      ListScreen
      *
      ** End Program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E S                                         *
      *                                                               *
      *****************************************************************
      *
      *******************************************************************
      *                                                                 *
      * ListScreen - Load Subfile with Driver file data                 *
      *                                                                 *
      *******************************************************************
      *
     C     ListScreen    BEGSR
      *
     C                   EVAL      WValErr = '1'
     C                   EXSR      InitSfl
     C                   DOW       *INKC = *OFF
     C                             and *INKL = *OFF
     C                             and *INKR = *OFF
     C                             and *INKS = *OFF
     C                   EXSR      InitSfl
     C                   EXSR      BuildSfl
 
     C                   READC     SD000552S0
     C                   DOW       NOT(%EOF)
 
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   IF        %trim(LAACTN) <> *BLANKS
     C                   EXSR      ValOption
     C                   EXSR      DspDetails
     C                   ENDIF
 
      * Reset validated/processed option taken
     C                   EVAL      LAACTN = ''
     C                   READC     SD000552S0
     C                   ENDDO
     C                   ENDDO
 
     C                   IF        *INKL = *ON
     C                   EVAL      PretCode = '*PREV'
     C                   ELSEIF    *INKC = *ON
     C*                  IF        *INKC = *ON
     C                   EVAL      PretCode = '*QUIT'
     C*                  ELSEIF    *INKR = *ON
     C*                  EVAL      PretCode = '*INFO'
     C*                  ELSEIF    *INKS = *ON
     C*                  EVAL      PretCode = '*UPDT'
     C                   ENDIF
 
     C     ListScreenE   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * INITSFL - Initialise subfile                                    *
      *                                                                 *
      *******************************************************************
      *
     C     InitSfl       BEGSR
      *
     C                   EVAL      *INKC = *OFF
     C                   EVAL      *INKL = *OFF
     C                   EVAL      WSflRRN = 0
     C                   EVAL      MATCH = 1
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000552C0
     C                   EVAL      *IN80 = *OFF
     C*                  EXSR      ClrMsgQue
     C*                  WRITE     #MSGCTL
 
     C     InitSflE      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildSfl - Build subfile                                      *
      *                                                               *
      *****************************************************************
      *
     C     BuildSfl      BEGSR
      *
     C     1             SETLL     SDNACUD0
     C                   READ(N)   SDNACUD0
     C                   IF        %EOF <> '0'
      *
      **  No Data to Display
      *
     C                   EXSR      NoRecords
     C                   ENDIF
      *
      **  Else, Fill SubFile
      *
     C                   DOW       %EOF <> '1'
 
     C                   EVAL      WSflRRN = WSflRRN + 1
 
     C                   EVAL      LACUST = NCCUST
     C                   EVAL      LANAHO = NCNAHO
     C                   EVAL      LARPNM = NCRPNM
     C                   EVAL      LARPTN = NCRPTN
     C                   EVAL      LAHVAC = NCHVAC
     C                   EVAL      LANCLS = NCNCLS
     C                   EVAL      LACCLS = NCCCLS
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000552S0
     C                   EVAL      *IN80 = *OFF
 
     C     ReadNext      TAG
     C                   READ(N)   SDNACUD0
     C                   ENDDO
      *
      ** Display subfile / Prompt user selection
      *
     C                   EVAL      *IN82 = *ON
     C                   WRITE     SD000552F0
     C                   EXFMT     SD000552C0
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
                                                                                            MD027209
     C                   IF        *INKD = *ON                                              MD027209
     C                   EXSR      SRPrint                                                  MD027209
     C                   ENDIF                                                              MD027209
      *
     C     BuildSflE     ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * NoRecords - Notify user that there are no active records        *
      *                                                                 *
      *******************************************************************
      *
     C     NoRecords     BEGSR
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      WSflRRN = WSflRRN + 1
     C                   WRITE     SD000552S0
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0307'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ValOption - Check option taken in regard of current mode        *
      *                                                                 *
      *******************************************************************
      *
     C     ValOption     BEGSR
 
     C                   EVAL      WValErr = '0'
     C                   IF        LAACTN <> 'E'
     C*               // Error message here
     C                   EVAL      WValErr = '1'
     C                   ENDIF
 
     C     ValOptionE    ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * *INZSR - Initialisation                                         *
      *                                                                 *
      *******************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode          7
     C                   PARM                    PMode             1
 
     C                   EVAL      WValErr = '1'
      ** Access installation control data
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'SD000552'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SPGM = PSProcName
     C                   EVAL      NAUSER = PSUser
     C                   EVAL      NAJOBN = PSJobName
     C                   EVAL      NAMRDT = BJMRDT
 
     C     CUSNAHREF     KLIST
     C                   KFLD                    CUSTNO            6
     C                   KFLD                    NAHORF           10
 
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
 
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   IF        PMode = 'U'
     C                   MOVEL     'USS0269'     ZAMSID
     C                   EVAL      *IN26 = *ON                                             MD027209B
     C                   ELSE
     C                   MOVEL     'USS0283'     ZAMSID
     C                   EVAL      *IN26 = *OFF                                            MD027209B
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
 
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * RtvClassfn - Rtv Classification Codes On File                   *
      *                                                                 *
      *******************************************************************
      *
     C     RtvClassfn    BEGSR
      ** Classification Code Input Must Exist On File
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      WClsCdValPrm  @CLAC             5
     C     SDFATC        PARM      SDFATC        DSFDY
     C
 
      ** Error on initialisation
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     RtvClassfnE   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * WrtHeadFoot - Write Header and Footer Formats                   *
      *                                                                 *
      *******************************************************************
      *
     C     WrtHeadFoot   BEGSR
     C                   WRITE     SD000552F0
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * DSPDETAILS - Invoke details processing program for enquiry      *
      *                                                                 *
      *******************************************************************
      *
     C     DspDetails    BEGSR
      *
     C                   EVAL      *IN26 = *ON                                             MD027209B
     C                   EVAL      *IN30 = *ON
     C                   EVAL      CUSTNO = LACUST
     C                   EVAL      NAHORF = LANAHO
     C     CUSNAHREF     CHAIN     SDNACUD1
     C                   IF        %FOUND = '1'
                                                                                            MD027335
      ** Set Naho reference screen field description                                        MD027335
                                                                                            MD027335
     C                   IF        NAHORF <> *BLANKS                                        MD027335
     C                   EVAL      *IN20 = *ON                                              MD027335
     C                   EVAL      NAHORF = *BLANKS                                         MD027335
     C                   ELSE                                                               MD027335
     C                   EVAL      *IN20 = *OFF                                             MD027335
     C                   ENDIF                                                              MD027335
                                                                                            MD027335
     C                   DOW       *INKC = *OFF
     C                             and *INKL = *OFF
     C                   IF        WNCCUST = *BLANKS
     C                   EVAL      EAREFR = WNCNAHO
     C                   ELSEIF    WNCNAHO = *BLANKS
     C                   EVAL      EAREFR = WNCCUST
     C                   ENDIF
 
     C                   EVAL      EARPNM = WNCRPNM
     C                   EVAL      EARPTN = WNCRPTN
     C                   EVAL      EAHVAC = WNCHVAC
     C                   EVAL      EACCLS = WNCCCLS
     C                   EVAL      EACCLD = WNCCCLD
     C                   EVAL      EANCLS = WNCNCLS
     C                   EVAL      EANCLD = WNCNCLD
     C                   EVAL      EAINFC = WNCINFC
     C                   WRITE     SD000552F0
     C                   EXFMT     SD000552D0
                                                                                            MD027209
     C**********         IF        *INKD = *ON                                    MD027209 MD027209B
     C                   IF        PMODE = 'U'                                             MD027209B
     C                   EXSR      SRPrint                                                  MD027209
     C                   ENDIF                                                              MD027209
                                                                                            MD027209
     C                   ENDDO
     C                   ENDIF
     C                   EVAL      *INKL = *OFF
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN26 = *OFF                                            MD027209B
      *
     C     DspDetailsE   ENDSR
      *
      /EJECT
      *******************************************************************                   MD027209
      *                                                                 *                   MD027209
      * SRPrint - Normal Customer/NAHO Report                           *                   MD027209
      *                                                                 *                   MD027209
      *******************************************************************                   MD027209
     C     SRPrint       BEGSR                                                              MD027209
     C                   CALL      'SD000553'                                               MD027209
     C                   PARM      'P'           PMode                                      MD027209
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                     MD027209
     C                   MOVEL     'USS0286'     ZAMSID                                     MD027209
     C                   EXSR      ZASNMS                                                   MD027209
     C                   WRITE     #MSGCTL                                                  MD027209
     C                   ENDSR                                                              MD027209
      /EJECT                                                                                MD027209
      *******************************************************************
      *                                                                 *
      * ClrMsgQue - Clear program message queue                         *
      *                                                                 *
      *******************************************************************
      *
     C     ClrMsgQue     BEGSR
 
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
     C     ZASNMS        BEGSR
 
     C                   IF        ZAMSGF = *BLANKS
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   END
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM                          Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZAMSID                         Message Id
     C                   PARM                    ZAMSGF                         Message file
     C                   PARM                    ZAMSDA                         Message data
     C                   PARM                    ZAMSTP                         Message type
 
     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
