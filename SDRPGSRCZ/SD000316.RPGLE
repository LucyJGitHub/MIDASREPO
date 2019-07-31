     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS Normal Cust/NAHO Classfn Upd - List')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000316 - CRS Normal Customer/NAHO Classification Upd - List*
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
     FSD000316DFCF   E             WORKSTN SFILE(SD000316S0:WSflRRN)
     F                                     INFSR(*PSSR)
      ** CRS Customers for Classfn Update - List
     FSDCRNAL0  IF   E             DISK

      ** CRS Customers for Classfn Update - Keyed
     FSDCRNAL1  IF   E           K DISK    RENAME(SDCRNAD0:SDCRNAD1)
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
     D SDCRNA        E DS                  EXTNAME(SDCRNAPD)
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

     D PRetCode        S              7A
     D POption         S              7
     D PClsCode1       S              5A
     D PClsDesc1       S             50A
     D PClsCode2       S              5A
     D PClsDesc2       S             50A
     D PMode           S              1A

     D CUSTNO          S              6A
     D NAHORF          S             10A
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WSFlRRN         S              4  0
     D WClsCdValPrm    S              5    INZ(*Blanks)
     D WValErr         S              1
     D WEnqAct         S              1    INZ('Y')
     D WRetCode        S              7    INZ(*Blanks)
     D Recursive       S              1    INZ('N')
      *
     D ZAPGM           S             10    INZ('SD000316')
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
      *
     C                   EXSR      InitSfl
     C                   DOW       *INKC = *OFF
     C                             and *INKL = *OFF
     C                             and *INKR = *OFF
     C                             and *INKS = *OFF
     C                   EXSR      InitSfl
     C                   EXSR      BuildSfl

     C                   READC     SD000316S0
     C                   DOW       NOT(%EOF)

     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL

     C                   READC     SD000316S0
     C                   ENDDO
     C                   ENDDO

     C                   IF        *INKL = *ON
     C                   EVAL      PretCode = '*PREV'
     C                   ELSEIF    *INKC = *ON
     C                   EVAL      PretCode = '*QUIT'
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
     C                   WRITE     SD000316C0
     C                   EVAL      *IN80 = *OFF

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
     C     1             SETLL     SDCRNAD0
     C                   READ(N)   SDCRNAD0
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
     C                   EVAL      LAINFC = NCINFC

     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000316S0
     C                   EVAL      *IN80 = *OFF

     C     ReadNext      TAG
     C                   READ(N)   SDCRNAD0
     C                   ENDDO
      *
      ** Display subfile / Prompt user selection
      *
     C                   EVAL      *IN82 = *ON
     C                   WRITE     SD000316F0
     C                   EXFMT     SD000316C0
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
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
     C                   WRITE     SD000316S0
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
      * *INZSR - Initialisation                                         *
      *                                                                 *
      *******************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PMode

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
     C                   EVAL      DBPGM = 'SD000316'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SPGM = PSProcName
     C                   EVAL      NAUSER = PSUser
     C                   EVAL      NAJOBN = PSJobName
     C                   EVAL      NAMRDT = BJMRDT

     C     CUSNAHREF     KLIST
     C                   KFLD                    CUSTNO
     C                   KFLD                    NAHORF

     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL

     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   IF        PMode = 'U'
     C                   MOVEL     'USS0269'     ZAMSID
     C                   ELSE
     C                   MOVEL     'USS0283'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * WrtHeadFoot - Write Header and Footer Formats                   *
      *                                                                 *
      *******************************************************************
      *
     C     WrtHeadFoot   BEGSR
     C                   WRITE     SD000316F0
     C                   ENDSR
      *******************************************************************
      /EJECT
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
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP

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
