     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Bridge DDS sanity report')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP4032 - This program run the sanity DDS report              *
      *                                                               *
      *  (c) Finastra International 2021                              *
      *                                                               *
      *  Last Amend No. MD059476 *CREATE   Date 01Dec21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059476 - Bridge improvement for refresh                    *
      *                                                               *
      *****************************************************************
     FUP4032P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D Recursive       S              1
      *
     D                 DS
      *
      /SPACE 3
      *
      *
      ** Program Status Data Structure
      *

     D UPCNTF        E DS                  EXTNAME(UPCNTFTD)

      ** API used for adding a validation list entry
     D OpenAPI         PR                  EXTPGM('QSYOLVLE')
     D  theRCVR                            LIKE(RCVR)
     D  theRCVRL                           LIKE(RCVRL)
     D  theLIST                            LIKE(LIST)
     D  theNRR                             LIKE(NRR)
     D  theFORMAT                          LIKE(FMT)
     D  theVLDL                            LIKE(VLDL)
     D  thequsec                           LIKE(QUSEC)

     D RCVR            DS
     D RCVRx                      29999A
     D RCVRL           DS
     D RCVRLx                         4B 0 INZ(9999)
      * 2-"Attribute" information.
     D LIST            DS
      * Number of attributes
      * Total records
     D  TotRec                 1      4B 0 INZ(0)
      * Records returned
     D  RecsRetn               5      8B 0 INZ(0)
      * Request handle
     D  ReqHdl                 9     12B 0 INZ(0)
      * Record length
     D  RecLength             13     16B 0 INZ(0)
      * Information complete indicator
     D  InfComInd             17     17
      * Date and time created
     D  DateTimeCr            18     30
      * List status indicator
     D  ListStsInd            31     31
      * Reserved
     D  Res1                  32     32
      * Length of information returned
     D  LengthInf             33     36B 0 INZ(0)
      * First record in buffer
     D  FirstRec              37     40B 0 INZ(0)
      * Reserved
     D  Res2                  41     68

     D NRR             S              4B 0 INZ(2000)
     D FMT             S              8A   INZ('VLDE0100')

     D XumbEnt         S             10  0
     D XumbRec         S             10  0

     D VLDL            DS                  ALIGN
     D   ValidList                   10A
     D   Library                     10A

     DQUSEC            DS
      * Bytes Provided.
     D QUSBPRV                       10I 0 INZ(%SIZE(QUSEC))
      * Bytes Available.
     D QUSBAVL                       10I 0 INZ(*ZEROS)
      * Exception ID.
     D QUSEI                          7
      * Reserved.
     D                                1
      * Message data.
     D MSDDATA                      500
     D PReturnCode                   20A
     **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    LAYER             7
      *

      * Write main page header.
     C                   setoff                                       20
     C                   IF        Layer = '*GLOBAL'
     C                   seton                                        20
     C                   ENDIF

      * Write main page header.
     C                   WRITE     HEADH
     C                   WRITE     HEADER

      * Read log file and process for each entry
     C/exec SQL
     C+ declare CursorRdG cursor for
     C+ select *
     C+ from UPCNTFTD
     C+ order by UPFILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPCNTF
     C/end-exec

      *
     C                   DOW       SQLCODE = 0
      *
      * If records are found print details
     C                   EXSR      Details
      *
      *
      * Read next record.
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPCNTF
     C/end-exec

      *
     C                   ENDDO
      *
      * Write trailer and end program.
     C                   WRITE     TRAILP
      *
     C/exec SQL
     C+ close CursorRdG
     C/end-exec

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * Details -                                                     *
      *                                                               *
      *****************************************************************
     C     Details       BEGSR

     C                   clear                   DETAIL


      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     HEADER
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF

     C                   eval      R_FILE =  UPFILE
     C                   eval      R_CTD  =  %char(UPCTDC)
     C                   eval      R_BTD  =  %char(UPCTDB)
     C                   eval      R_XTD  =  %char(UPCTDX)
     C                   eval      R_DEL  =  %char(UPXTDD)
     C                   eval      R_XAC  =  %char(UPXTDC)
     C                   eval      R_XAB  =  %char(UPXTDB)

      ** print error !! is CTD + BTD <> XTD
     C                   setoff                                       7071
     C                   if        UPCTDC + UPCTDB <> UPCTDX
     C                   seton                                        70
     C                   eval      R_ERR = 'Number of records in XTD' +
     C                             ' does not match sum of CTD and BTD' +
     C                             ' records'
     C                   ENDIF

      ** If features, check password
     C                   IF        %subst(UPFILE:3:3) = 'SRD'

     C                   IF        Layer = '*GLOBAL'
     C                   EVAL      ValidList = 'GPFEATVL'
     C                   else
     C                   EVAL      ValidList = 'SCFEATVL'
     C                   endif
     C                   EVAL      Library  = '*LIBL'

      ** retrieve VLDL number of entries
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     OpenAPI(RCVR:RCVRL:LIST:NRR:FMT:
     C                             VLDL:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   EVAL      XumbEnt = TotRec
     C                   ENDIF

      ** and retrieve number of features
     C                   IF        Layer = '*GLOBAL'
     C/exec SQL
     C+ select count(*) into :XumbRec
     C+ from GPSRDXTD
     C/end-exec
     C                   else
     C/exec SQL
     C+ select count(*) into :XumbRec
     C+ from SCSRDXTD
     C/end-exec
     C                   endif

      ** compare both and print error if different
     C                   if        XumbRec <> XumbEnt
     C                   seton                                        71
     C                   ENDIF

     C                   ENDIF

      ** if duplicate report error
     C                   IF        UPDUPL > 0
     C                   seton                                        71
     C                   ENDIF

     C                   WRITE     DETAIL
     C   70              WRITE     ERROR

      ** compare both and print error if different
     C                   IF        %subst(UPFILE:3:3) = 'SRD'
     C                   if        XumbRec <> XumbEnt
     C                   eval      R_ERR = 'There seems to be missing' +
     C                             ' passwords in the validation list: ' +
     C                             'in file: ' + %char(XumbRec) + ' vs in' +
     C                             ' validation list: ' + %char(XumbEnt)
     C                   WRITE     ERROR
     C                   ENDIF
     C                   ENDIF

      ** if duplicate report error
     C                   IF        UPDUPL > 0
     C                   eval      R_ERR = 'There are ' + %trim(%char(UPDUPL)) +
     C                             ' duplicate recor' +
     C                             'ds. These are both in CTD and in BTD'
     C                   WRITE     ERROR
     C                   ENDIF


     C     DetailsE      ENDSR


      /EJECT

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     Recursive     IFEQ      *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
